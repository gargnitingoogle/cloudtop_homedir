function genericAliases() {
  alias ........='cd ../../../../../../..'
  alias .......='cd ../../../../../..'
  alias ......='cd ../../../../..'
  alias .....='cd ../../../..'
  alias ....='cd ../../..'
  alias ...='cd ../..'
  alias ..='cd ..'
  alias cls='clear'
  # alias dlv='~/go/bin/dlv --check-go-version=false --init <(config source-list-line-count 20)'
  alias dlv='$(which dlv) --check-go-version=false'
  alias goctl='/google/bin/releases/golinks/goctl/goctl.par'
  alias htop='htop -u $USER -t'
  alias install='sudo apt-get -y install'
  alias l='ls -lah'
  alias lint='golangci-lint run'
  alias pstree='pstree -ps'
  alias tailf='tail -f'
  alias runubuntucontainer='docker run --rm -it --entrypoint /bin/bash ubuntu'
  alias rungocontainer='docker run -it --rm --entrypoint /bin/bash golang'
  alias study='mkdir -p $HOME/work/study && cd $HOME/work/study'
  alias tmx='tmux'
  alias home='git -C $HOME'
}

function diffDirs() {
  if [ $# -ne 2 ] ; then
    echo "Expected 2 arguments for comparing directories, but got $# arguments: \"$@\" "
    return 1
  fi

  local dir1="$1"
  [ -d "${dir1}" ] || ( echo "Directory \"${dir1}\" does not exist" ; return 1 ; )
  local dir2="$2"
  [ -d "${dir2}" ] || ( echo "Directory \"${dir2}\" does not exist" ; return 1 ; )

  echo "Comparing \"${dir1}\" and \"${dir2}\" ..." && \
  diff -qr "${dir1}" "${dir2}" | \

  egrep -i "Files [a-z0-9\.\/\-]+ and [a-z0-9\.\/\-]+ differ" | \
  cut -d' ' -f2,4 $diffOutput | while read files ; do \
    f1=""$(echo $files | cut -d' ' -f1) \
    && f2=""$(echo $files | cut -d' ' -f2) \
    && echo "Comparing ${f1} and ${f2} ..." \
    && sleep 2 \
    && vimdiff $f1 $f2 </dev/tty ; \
  done
}

function showLastNGitCommits() {
  local n=${1}
  for i in $(seq $((n-1)) -1 0 ) ; do
    git log -1 HEAD~$i --name-only \
      && sleep 5 \
      && git vimdiff HEAD~$((i+1))..HEAD~$i
  done
}

function showUncommittedGitChanges() {
  git diff --name-only HEAD && sleep 2 && git vimdiff HEAD
}

genericAliases

function shpool-ssh () {
    if [ $# -ne 2 ] ; then
  echo "usage: shpool-ssh <remote-machine> <session-name>" >&2
  return 1
    fi
    ssh -t "-oRemoteCommand=shpool attach -f $2" "$1"
}

function openConfigFile() {
  alias aliases='vi ~/.bash_aliases && source ~/.bash_aliases'
  alias bashrc='vi ~/.bashrc'
  alias history='vi ~/.bash_history +:$'
  alias vimrc='vi ~/.vimrc'
  alias tmuxconf='vi ~/.tmux.conf && tmux source ~/.tmux.conf'
}

openConfigFile

function gitAliases() {
  alias gi='git'
  alias gitconfig='vi ~/.gitconfig'
  alias gitl='git l'
  alias gt='git'
  alias gti='git'
  alias gtl='git l'
  alias gitresolve='vi -p $(git diff --name-only --diff-filter=U --relative | tr -s '"'"'\n'"'"' '"'"' '"'"')'
}

gitAliases

function uploadchain() {
  if test -z ${branches}; then
    echo "No branches to upload. Did you miss setting the branches variables ?"
  else
    for branch in ${branches}; do
      git pushbranch -f $branch;
    done;
  fi
}

function cloudtopAliases() {
  alias restartCRD='sudo systemctl restart chrome-remote-desktop@${USER}'
}

cloudtopAliases

function ssh2vm() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  # printf "Warning: This won't work from inside tmux ...\n\n"

  # if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  if test -z "$TMUX"; then
    set -x
    ssh "$vmname"."$zone"."$projectname" "${@:4}" || ssh ${USER}_google_com@nic0.${vmname}.${zone}.c.${projectname}.internal.gcpnode.com
    set +x
  else
    echo "Error: ${FUNCNAME[0]} from inside tmux is not supported."
    return 1
  fi
}

function vmconnect() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  set -x
  gcloud compute --project "$projectname" ssh --zone "$zone" "$vmname" -- -o ProxyCommand='corp-ssh-helper %h %p' "${@:4}"
  set +x
}

function gcsfusetestvmconnect() {
  local projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  local zone=$2
  local vmname=$1

  vmconnect "$vmname" "$zone" "$projectname" "${@:3}"
}

function stopvm() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  set -x
  gcloud compute instances stop "$vmname" --project="$projectname" --zone="$zone" "${@:4}"
  set +x
}

function gcestop() {
  local projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  local zone=$2
  local vmname=$1

  stopvm "$vmname" "$zone" "$projectname" "${@:3}"
}

function startvm() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  set -x
  gcloud compute instances start "$vmname" --project="$projectname" --zone="$zone"
  set +x
}

function gcestart() {
  local projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  local zone=$2
  local vmname=$1

  startvm "$vmname" "$zone" "$projectname" "${@:3}"
}

function rmvm() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  set -x
  gcloud compute instances delete "$vmname" --project="$projectname" --zone="$zone"
  set +x
}

function gcerm() {
  local projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  local zone=$2
  local vmname=$1

  rmvm "$vmname" "$zone" "$projectname" "${@:3}"
}

function describevm() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  local projectname=$3
  local zone=$2
  local vmname=$1

  set -x
  gcloud compute instances describe "$vmname" --project="$projectname" --zone="$zone"
  set +x
}

function gcedescribe() {
  local projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  local zone=$2
  local vmname=$1

  describevm "$vmname" "$zone" "$projectname" "${@:3}"
}

function installGoVersion () {
  echo "Will not override the managed go installation on cloudtop"
  if false; then
    if [[ $# -lt 1 ]]; then
      echo "No arguments passed. Pass a go-lang version number e.g. 1.20.4";
      return 1
    fi;

    version=$1;
    echo "Installing go version "$version" ..."
    wget -O go_tar.tar.gz https://go.dev/dl/go${version}.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && tar -xzf go_tar.tar.gz && sudo mv go /usr/local && export PATH=$PATH:/usr/local/go/bin && go version
  fi
}

function listAllContainers() {
  if [ $# -lt 1 ] ; then
    >2 echo "expected at least one input (pod-name)"
    return 1
  fi
  local podname=$1
  shift 1
  kubectl get pods ${podname} -o jsonpath='{.spec.containers[*].name}'  "$@"
  echo ""
}

function listAllPods() {
  kubectl get pods --namespace=default "$@"
}

function deleteAllPods() {
  kubectl get pods "$@" | tail -n +2 | cut -d' ' -f1 | while read podname ; do kubectl delete pod/$podname "$@" ; done
}

function transferApplianceAliases() {
  # appliance OS
  alias buildimaedgeForVm='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --b_cld=true --env=dev --os=imaedge --bucket=$USER-bucket'
  alias buildimaedgeForHw='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --env=dev --os=imaedge --bucket=$USER-bucket'
  alias buildzimbrageForVm='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --b_cld=true --env=dev --bucket=$USER-bucket'
  alias buildzimbrageForHw='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --env=dev --bucket=$USER-bucket'
  # appliance binaries
  alias buildOnboardBinary='blaze build //cloud/transfer/appliance/offline/external/assembly/appliance_onboard:zimbru_appliance_onboard'
  alias uploadOnboardBinary='gcloud storage cp blaze-bin/cloud/transfer/appliance/offline/external/assembly/appliance_onboard/zimbru_appliance_onboard gs://$USER-bucket/appliance_binaries/latest'
  alias downloadOnboardBinary='mkdir -p /tmp && gcloud storage cp gs://$USER-bucket/appliance_binaries/latest/zimbru_appliance_onboard /tmp/ && chmod +x /tmp/zimbru_appliance_onboard'
  alias buildTaBinary='blaze build //cloud/transfer/appliance/offline/external/capture:ta'
  alias uploadTaBinary='gcloud storage cp blaze-bin/cloud/transfer/appliance/offline/external/capture/ta gs://$USER-bucket/appliance_binaries/latest'
  alias downloadTaBinary='gcloud storage cp gs://$USER-bucket/appliance_binaries/latest/ta /tmp && chmod +x /tmp/ta'

  ##helpful commands for nsjaili and strace on transfer appliances
  #export UBUNTU_CONTAINER_FS='/mnt/ta_local/$USER/ubuntu_expt/ubuntu_container_fs'
  #alias nsjail='LD_LIBRARY_PATH=$UBUNTU_CONTAINER_FS/usr/lib/x86_64-linux-gnu/ $UBUNTU_CONTAINER_FS/./bin/nsjail'
  #alias strace='LD_LIBRARY_PATH=$(UBUNTU_CONTAINER_FS)/usr/lib/x86_64-linux-gnu/ $(UBUNTU_CONTAINER_FS)/./usr/bin/strace'

  # aliases related to appliances
  alias svlpxeserver='sshpass -p cdj40mmss330 ssh -D 8080 zimbru@100.127.95.2'
  alias zeapxeserver='sshpass -p cdj40mmss330 ssh -D 8080 zimbru@100.107.99.194'
  alias superboybmc='google-chrome-stable --proxy-server=socks://localhost:8080 http://100.107.99.226'
  alias httpserver='google-chrome-stable --proxy-server=socks://localhost:8080'
  alias superboy='sshpass -p LWoD4K ssh ta_operator@100.107.99.227'
  alias superboycust='sshpass -p VhTZWi ssh ta_customer@100.107.99.227'
  alias pingsuperboy='ping 100.107.99.227'

  export SS3_IP='100.127.95.14'
  export SS3_PWD='u4XV2r'
  #export SS3_PWD='cdj40mmss330'
  alias ss3='sshpass -p $SS3_PWD ssh ta_operator@$SS3_IP'

  export SS2_IP='100.127.95.12'
  #export SS2_PWD='u4XV2r'
  export SS2_PWD='cdj40mmss330'
  alias ss2='sshpass -p $SS2_PWD ssh ta_operator@$SS2_IP'

  export HALEY_IP='100.107.99.219'
  export HALEY_PWD='WeD5wf'
  #export HALEY_PWD='cdj40mmss330'
  alias haley='sshpass -p $HALEY_PWD ssh ta_operator@$HALEY_IP'
  export HALEYCUST_PWD='h7w2yT'
  alias haleycust='sshpass -p $HALEYCUST_PWD ssh ta_customer@$HALEY_IP'

  #alias ss3customer='sshpass -p 3pwmyU ssh ta_customer@$SS3_IP'
  export ACE_IP='100.107.99.209'
}

# transferApplianceAliases

function mkbucket() {
  if [ $# -lt 2 ] ; then
    echo "Not enough arguments for mkbucket. expected arguments:\
      \$1: bucket-name e.g. ${USER}-test-bucket
      \$2: location e.g. us-central1 or us or asia-southeast1 \
      "
      return 1
  fi

  local bucket=$1
  local location=$2
  shift 2

  set -x
  gcloud storage buckets create gs://$bucket --location=$location "$@"
  set +x
}

function mkhnsbucket() {
  if [ $# -lt 2 ] ; then
    echo "Not enough arguments for mkbucket. expected arguments:\
      \$1: bucket-name e.g. ${USER}-test-bucket
      \$2: location e.g. us-central1 or us or asia-southeast1 \
      "
      return 1
  fi

  local bucket=$1
  local location=$2
  shift 2

  set -x
  gcloud alpha storage buckets create gs://$bucket --location=$location "$@" --enable-hierarchical-namespace --uniform-bucket-level-access
  set +x
}

function rmbucket() {
  if [ $# -lt 1 ] ; then
    echo "Too few arguments for rmbucket. expected arguments: [-y|-n] bucket-name"
    return 1
  fi

  if [ "$1" = "-n" ] ; then
    #echo "skipping because of -n"
    return 0
  elif [ "$1" != "-y" ] ; then
    local bucket="$1"
    # prompting for confirmation
    read -p "Do you really want to delete the bucket \"${bucket}\" (y)Yes/(n)No [Default: No]:- " choice

    # giving choices there tasks using
    case $choice in
      [yY]* ) echo "Going ahead with deleting \"${bucket}\" ..." ;;
      [nN]* ) echo "Cancelling deletion of \"${bucket}\"" ; return 0 ;;
      *) echo "No confirmation received, so cancelling deletion." ;;
    esac
  else
    shift 1
    local bucket="$1"
  fi

  if  [ -z "$bucket" ] ; then
    echo "no bucket-name passed"
    return 1
  fi

  set -x
  gcloud storage buckets delete gs://${bucket}
  set +x
}

function lsbuckets() {
  set -x
  gcloud storage ls "$@" | grep $USER | rev | cut -f2 -d/ | rev
  set +x
}

function lsallbuckets() {
  set -x
  gcloud storage ls "$@" | rev | cut -f2 -d/ | rev
  set +x
}

function lsvm() {
  set -x
  gcloud compute instances list "$@" | grep ${USER}
  set +x
}

function lsallvm() {
  set -x
  gcloud compute instances list "$@"
  set +x
}

function lsclusters() {
  set -x
  gcloud container clusters list "$@" | grep ${USER}
  set +x
}

function lsallclusters() {
  set -x
  gcloud container clusters list "$@"
  set +x
}

function resizecluster() {
  if [ $# -lt 3 ]; then
    echo "expected at least 3 arguments. Usage: ${0} <cluster-name> <zone> <num-nodes> [OPTIONS]"
    return 1
  fi
  local cluster_name=$1
  local zone=$2
  local num_nodes=$3
  if [ ${num_nodes} -lt 0 ]; then
    echo "num_nodes < 0 is not supported."
    return 1
  fi
  shift 3

  set -x
  gcloud -q container clusters resize ${cluster_name} --num-nodes=${num_nodes} \
    --zone=${zone} \
    --async \
    "$@"
  set +x
}

function rmcluster() {
  if [ $# -lt 2 ]; then
    echo "expected at least 1 arguments. Usage: ${0} <cluster-name> <zone> [OPTIONS]"
    return 1
  fi
  local cluster_name=$1
  local zone=$2
  shift 2

  set -x
  gcloud -q container clusters delete ${cluster_name} \
    --zone ${zone} \
    --async \
    "$@"
  set +x
}

function gcsfuseSrcAliases() {
  export gcsfuse_src_dir=~/work/cloud/storage/client/gcsfuse/src/gcsfuse
  export csi_src_dir=~/work/cloud/storage/client/gcsfuse/src/gcs-fuse-csi-driver
  export gcsfuse_src2_dir=~/work/cloud/storage/client/gcsfuse/src2/gcsfuse
  export gcsfuse_src3_dir=~/work/cloud/storage/client/gcsfuse/src3/gcsfuse
  alias src='cd ${gcsfuse_src_dir}'
  alias csi='cd ${csi_src_dir}'
  alias src2='cd ${gcsfuse_src2_dir}'
  alias src3='cd ${gcsfuse_src3_dir}'
  alias lsfusemnts='cat /etc/mtab | grep gcsfuse | cut -d '"'"' '"'"' -f1-2'
  # alias lsfusemnts='echo From df command: ; df -h --output=source,fstype,target | grep '"'"'gcsfuse\|Mounted'"'"' ; echo . ; echo From /etc/mtab:  ;  cat /etc/mtab | grep gcsfuse | cut -d '"'"' '"'"' -f1-2 '
  alias localwork='cd ~/work/cloud/storage/client/gcsfuse/tasks'
  alias work='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks'
  #alias golang='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-golang1.20.5'
  #alias encoding='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-08-gzip-support'
  alias lsIamStorageRoles='gcloud iam roles list | egrep '"'"'^name: roles/storage\\..*'"'"''

  #gcsfuse unit test runs - TODO: move to a different function/file
  alias runAllUnitTests='go test ./... -timeout 10m'
  # unitTestOptions='-v -timeout 30s'
  unitTestOptions='-timeout 30s'
  # unitTestOptions='-v -timeout 5m'
  alias runFsTest='go test $unitTestOptions -run ^TestFS$ github.com/googlecloudplatform/gcsfuse/v2/internal/fs'
  alias runBucketHandleUnitTests='go test $unitTestOptions -run ^TestBucketHandleTestSuite$ github.com/googlecloudplatform/gcsfuse/v2/internal/storage'
  alias runBucketUnitTests='go test $unitTestOptions -run ^TestBucket$ github.com/googlecloudplatform/gcsfuse/v2/internal/storage/fake'
  alias runAppendObjectCreatorUnitTests='go test $unitTestOptions -run ^TestAppendObjectCreator$ github.com/googlecloudplatform/gcsfuse/v2/internal/gcsx'
  alias runUtilUnitTests='go test $unitTestOptions -run ^TestUtilSuite$ github.com/googlecloudplatform/gcsfuse/v2/internal/util'
  alias runDirUnitTests='go test $unitTestOptions -run ^TestDir$ github.com/googlecloudplatform/gcsfuse/v2/internal/fs/inode'
  alias debugBucketUnitTests='cd internal/storage/fake && dlv test . -- -test.v -test.run ^TestBucket$ github.com/googlecloudplatform/gcsfuse/v2/internal/storage/fake ; cd -'
  alias debugDirUnitTests='cd internal/fs/inode && dlv test . -- -test.v -test.run ^TestDir$ github.com/googlecloudplatform/gcsfuse/v2/internal/fs/inode ; cd -'
  alias debugFsTest='cd internal/fs && dlv test -- -test.v -test.run ^TestFS$ ; cd -'

  #gcsfuse integration test runs
  alias runIntegrationTestCurDir='GODEBUG=asyncpreemptoff=1 go test . -test.parallel 1 --integrationTest -test.v -testbucket=$bucket -mountedDirectory=$mountpath'
  alias runIntegrationTestListDirectoryRecursively='cd tools/integration_tests/operations/ && runIntegrationTestCurDir -test.run TestListDirectoryRecursively ; cd -'
  alias runIntegrationTestListImplicitObjectsFromBucket='cd tools/integration_tests/implicit_dir && runIntegrationTestCurDir -test.run TestListImplicitObjectsFromBucket ; cd -'
  alias debugIntegrationTestCurDir='GODEBUG=asyncpreemptoff=1 dlv test . -- -test.parallel 1 --integrationTest -test.v -testbucket=$bucket -mountedDirectory=$mountpath'
  alias debugIntegrationTestListDirectoryRecursively='cd tools/integration_tests/operations/ && debugIntegrationTestCurDir -test.run TestListDirectoryRecursively ; cd -'
  alias debugIntegrationTestListImplicitObjectsFromBucket='cd tools/integration_tests/implicit_dir && debugIntegrationTestCurDir -test.run TestListImplicitObjectsFromBucket -mountedDirectory=$mountpath -testbucket=$bucket ; cd -'
}

function unmountGcsfuse() {
  if [[ $# -ne 1 ]]; then
    echo "unmountGcsfuse: expected 1 input: <gcsfuse-mount-path-to-be-unmounted>"
    return 1
  fi
  mntpath=$1
  echo "Unmounting gcsfuse mount "${mntpath}" ..."
  fusermount -uz $mntpath
  echo "... Unmounted "${mntpath}
}

# function mountGcsfuse() {
#   set -e

#   if [[ $# -lt 1]]; then
#     echo "mountGcsfuse: at least one argument is required: <gcsfuse-mount-path> <bucket-name-to-be-mounted> <options>"
#     return 1
#   fi

#   bucket=
#   options=

#   mountpath=$1

#   if [[ $# -gt 1 ]]; then
#     bucket=$2

#     if [[ $# -gt 1 ]]; then
#       options="${@:3}"
#     fi
#   else
#     echo "mountGcsfuse: bucket not passed, so assuming dynamic-mount"
#   fi

#   echo "Mounting bucket="${bucket}" at "${mountpath}" using commandline-args: ${options} ..."
#   cd ~/work/cloud/storage/client/gcsfuse/src/gcsfuse && CGO_ENABLED=0 go run . ${options} ${bucket} ${mountpath}
#   echo "... Mounted bucket="${bucket}" at "${mountpath} ."
# }

function gcsfuseTestAliases() {
  gcsfuseSrcAliases
  testbucketmountdir=~/work/cloud/storage/client/gcsfuse/test_buckets

  testbucket1=gargnitin-fuse-test-bucket1
  testbucket1mountpath=$testbucketmountdir/$testbucket1-mount
  testbucket1configfile=${gcsfuse_src_dir}/config-trace-gargnitin-fuse-test-bucket1.yaml
  alias loadfusetestbucket1='bucket=$testbucket1 && mountdir=$testbucketmountdir && mountpath=$testbucket1mountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/${bucket}-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --config-file=${testbucket1configfile} $bucket $mountpath'
  # --implicit-dirs
  alias unloadfusetestbucket1='unmountGcsfuse $testbucket1mountpath'
  alias loaddebugfusetestbucket1='bucket=$testbucket1 && mountdir=$testbucketmountdir && mountpath=$testbucket1mountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir} && CGO_ENABLED=0 go build -gcflags="all=-N -l" -o gcsfuse && ./gcsfuse --config-file=${testbucket1configfile} --implicit-dirs --log-format=text $bucket $mountpath && echo '"'"'gcsfuse pid='"'"'$!'

  testbucket2=gargnitin-fuse-test-bucket2
  testbucket2mountpath=$testbucketmountdir/$testbucket2-mount
  alias loadfusetestbucket2='bucket=$testbucket2 && mountdir=$testbucketmountdir && mountpath=$testbucket2mountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --implicit-dirs --debug_fuse --debug_fuse_errors --debug_gcs --log-file=$logpath --log-format=text $bucket $mountpath'
  alias unloadfusetestbucket2='unmountGcsfuse $testbucket2mountpath'

  testbucket3=gargnitin-memory-testing-bucket-20230809
  testbucket3mountpath=$testbucketmountdir/$testbucket3-mount
  alias loadfusetestbucket3='bucket=$testbucket3 && mountdir=$testbucketmountdir && mountpath=$testbucket3mountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --implicit-dirs --debug_fuse --debug_fuse_errors --debug_gcs --log-file=$logpath --log-format=text $bucket $mountpath'
  alias unloadfusetestbucket3='unmountGcsfuse $testbucket2mountpath'

  integrationTestsBucket=gargnitin-gcsfuse-integration-tests-playground
  integrationTestsBucketMountpath=$testbucketmountdir/${integrationTestsBucket}-mount
  alias loadIntegrationTestsBucket='bucket=$integrationTestsBucket && mountdir=$testbucketmountdir && mountpath=$integrationTestsBucketMountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --implicit-dirs --debug_fuse --debug_gcs --log-file=$logpath --log-format=text $bucket $mountpath'
  alias unloadIntegrationTestsBucket='unmountGcsfuse $integrationTestsBucketMountpath'

  dynamicmountpath=$testbucketmountdir/dynamic-mount
  alias loadfusedynamic='mountdir=$testbucketmountdir && mountpath=$dynamicmountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/dynamic-mount-log.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --config-file="/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/src/gcsfuse/config-debug-gargnitin-fuse-dynamic-mount.yaml" --implicit-dirs --log-format=text $mountpath'
  alias unloadfusedynamic='unmountGcsfuse  $dynamicmountpath'

  alias gcsdescribe='gcloud storage objects describe'
}

gcsfuseSrcAliases
gcsfuseTestAliases
