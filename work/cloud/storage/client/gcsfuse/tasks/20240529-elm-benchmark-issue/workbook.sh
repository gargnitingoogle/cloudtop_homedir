#!/bin/bash
# export bucket=gargnitin-us-west4-bucket
# 
# gcloud compute images create debian-10-buster-v20240515-gvnic --source-image=debian-10-buster-v20240515 --source-image-project=debian-cloud --guest-os-features=GVNIC
# gcloud compute images describe debian-10-buster-v20240515-gvnic
# 
# chmod +x create_vm.sh
# ./create_vm.sh

# create VM
gcloud compute instances create gargnitin-c3highmem176-useast4-20240601-071616 \
  --project=gcs-fuse-test \
  --zone=us-east4-c \
  --machine-type=c3-highmem-176 \
  --network-interface=network-tier=PREMIUM,nic-type=GVNIC,stack-type=IPV4_ONLY,subnet=default \
  --metadata=enable-osconfig=TRUE,enable-oslogin=true \
  --maintenance-policy=TERMINATE \
  --provisioning-model=STANDARD \
  --service-account=927584127901-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=gargnitin-c3highmem176-useast4-2,image=projects/debian-cloud/global/images/debian-11-bullseye-v20240515,mode=rw,size=80,type=projects/gcs-fuse-test/zones/us-east4-c/diskTypes/pd-ssd \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels=goog-ops-agent-policy=v2-x86-template-1-2-0,goog-ec-src=vm_add-gcloud \
  --reservation-affinity=any

# connect to vm
# pre-existing VM
# gcsfusetestvmconnect gargnitin-c3highmem176-useast4-1 us-east4-c
gcsfusetestvmconnect gargnitin-c3highmem176-useast4-20240601-071616 us-east4-c

# find disks
ls -l /dev/disk/by-id/google-*
# this lists disks such as /dev/<DEVICE_NAME>

function MountDisk() {
  DEVICE_NAME=$1
  MOUNT_POINT=$2

  #format disk
  sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME

  #mount disk to /mount2
  sudo mkdir -pv $MOUNT_POINT
  sudo mount -o discard,defaults /dev/$DEVICE_NAME $MOUNT_POINT
  sudo chmod a+w $MOUNT_POINT
}

#do this for DEVICE_NAME=nvme0n3 and MOUNT_POINT=/mount2
#do this for DEVICE_NAME=nvme0n2 and MOUNT_POINT=~/work
MountDisk nvme0n3 /mnt/disks/nvme0n3
MountDisk nvme0n2 /mnt/disks/nvme0n2

ln -sfv /mnt/disks/nvme0n3 /mount2
ln -sfv /mnt/disks/nvme0n2 ~/work

# set up mount parameters
export bucket=gargnitin-us-east4-bucket
export mountpath=/mount2/${bucket}-mount
mkdir -pv $mountpath

# add permissions for access to bucket
gcloud auth application-default login

#install gcsfuse
sudo apt-get install -y curl
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.asc
sudo apt-get update
sudo apt-get install gcsfuse=2.0.1
gcsfuse -v

# re-mount
sudo fusermount -uz $mountpath ; sudo gcsfuse $bucket $mountpath 
sudo fusermount -uz $mountpath

# create job files
echo <<EOF> job-for-read-test.fio
[global]
ioengine=libaio
direct=1
fadvise_hint=0
verify=0
fsync=10  // For write tests only
rw=${RW}
bs=1M
iodepth=64
invalidate=1
ramp_time=10s
runtime=60s
time_based=1
nrfiles=1
thread=1
filesize=10M 
openfiles=1
group_reporting=1
allrandrepeat=1
directory=${DIRECTORY}
filename_format=$jobname.$jobnum.$filenum

[40_thread]
stonewall
numjobs=100
EOF

echo <<EOF> job-for-write-test.fio
[global]
ioengine=libaio
direct=1
fadvise_hint=0
verify=0
fsync=10  // For write tests only
rw=${RW}
bs=1M
iodepth=64
invalidate=1
#ramp_time=10s
#runtime=60s
time_based=0
nrfiles=30
thread=1
filesize=10M 
openfiles=1
group_reporting=1
allrandrepeat=1
directory=${DIRECTORY}
filename_format=$jobname.$jobnum.$filenum

[40_thread]
stonewall
numjobs=100
EOF

echo <<EOF> run.sh
#!/bin/bash
set -x
set -e
numiters=1

if [ $# -gt 0 ] ; then
        RW=$1
        if [ $# -gt 1 ] ; then
                numiters=$2
        else
                >1 echo "numiters (\$2) not passed, so using "$numiters
        fi
else
        >2 echo "RW (\$1) not passed"
        exit 1
fi

if [ -z "$bucket" -o "$bucket" = "" ] ; then
        echo "bucket="$bucket" has not been set"
        exit 1
fi

if [ ! -d "$mountpath" ] ; then
        echo "mountpath="$mountpath" does not exist"
        exit 1
fi

fusermount -uz $mountpath || true

mkdir -pv $mountpath

readonly gcsfuse_args=
echo RW=$RW
echo numiters=$numiters

gcsfuse -v
gcsfuse ${gcsfuse_args} $bucket $mountpath
for i in $(seq 1 $numiters) ; do
        echo ""
        echo "epoch # "$i":"
        echo ""
        DIRECTORY=$mountpath RW=${RW} fio job.fio --name=40_thread || true
done

fusermount -uz $mountpath || true
EOF

# run tests
for op in write randwrite ; do echo op=$op ... &&
  logfile=${op}-fio-output-nrfiles30-10runs.log && echo "   "logfile=$logfile"..." && rm -fv $logfile && touch $logfile && ./run.sh $op 10 &> $logfile ;
done

# analyze logs
for file in read-fio-output-nrfiles1-runtime60s-10runs.log  randread-fio-output-nrfiles1-runtime60s-10runs.log  ; do 
  echo "" && echo "" && echo file=$file && (cat $file | grep -A 1 'Run status group 1' | more)  ; 
done

