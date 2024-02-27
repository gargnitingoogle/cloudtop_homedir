function genericAliases() {
	alias ........='cd ../../../../../../..'
	alias .......='cd ../../../../../..'
	alias ......='cd ../../../../..'
	alias .....='cd ../../../..'
	alias ....='cd ../../..'
	alias ...='cd ../..'
	alias ..='cd ..'
	alias aliases='vi ~/.bash_aliases'
	alias bashrc='vi ~/.bashrc'
	alias cls='clear'
	alias dlv='~/go/bin/dlv --check-go-version=false'
	alias goctl='/google/bin/releases/golinks/goctl/goctl.par'
	alias htop='htop -u $USER -t'
	alias install='sudo apt-get -y install'
	alias l='ls -lah'
	alias lint='golangci-lint run'
	alias pstree='pstree -ps'
	alias tailf='tail -f'
	alias vimrc='vi ~/.vimrc'
	alias history='vi ~/.bash_history +:$'
}

genericAliases

function gitAliases() {
	alias gi='git'
	alias gitconfig='vi ~/.gitconfig'
	alias gitl='git l'
	alias gt='git'
	alias gti='git'
	alias gtl='git l'
}

gitAliases

function cloudtopAliases() {
  alias restartCRD='sudo systemctl restart chrome-remote-desktop@${USER}'
}

cloudtopAliases

function vmconnect() {
  if [ $# -lt 3 ]
  then
    echo "${FUNCNAME[0]} needs exactly 3 arguments: <vm-name> <gcp-zone> <gcp-project-id>"
    return 1
  fi

  projectname=$3
  zone=$2
  vmname=$1

  gcloud compute --project "$projectname" ssh --zone "$zone" "$vmname" -- -o ProxyCommand='corp-ssh-helper %h %p' "${@:4}"
}

function gcsfusetestvmconnect() {
  projectname=gcs-fuse-test

  if [ $# -lt 2 ]
  then
    echo "${FUNCNAME[0]} needs exactly 2 arguments: <vm-name> <gcp-zone>. It sets project name as $projectname" "${@:3}"
    return 1
  fi

  zone=$2
  vmname=$1

  vmconnect "$vmname" "$zone" "$projectname" "${@:3}"
}

function installGoVersion ()
{
    if [[ $# -lt 1 ]]; then
        echo "No arguments passed. Pass a go-lang version number e.g. 1.20.4";
        return 1
    fi;

    version=$1;
    echo "Installing go version "$version" ..."
    wget -O go_tar.tar.gz https://go.dev/dl/go${version}.linux-amd64.tar.gz && sudo rm -rf /usr/local/go && tar -xzf go_tar.tar.gz && sudo mv go /usr/local && export PATH=$PATH:/usr/local/go/bin && go version
}

function transferApplianceAliases() {
	# appliance OS
	alias buildimaedgeForVm='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --b_cld=true --env=dev --os=imaedge --bucket=$USER-bucket'
	alias buildimaedgeForHw='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --env=dev --os=imaedge --bucket=$USER-bucket'
	alias buildzimbrageForVm='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --b_cld=true --env=dev --bucket=$USER-bucket'
	alias buildzimbrageForHw='blaze run //cloud/transfer/appliance/offline/zimbrage:zim_build -- --b_liv=false --b_zim=false --env=dev --bucket=$USER-bucket'
	# appliance binaries
	alias buildOnboardBinary='blaze build //cloud/transfer/appliance/offline/external/assembly/appliance_onboard:zimbru_appliance_onboard'
	alias uploadOnboardBinary='gsutil cp blaze-bin/cloud/transfer/appliance/offline/external/assembly/appliance_onboard/zimbru_appliance_onboard gs://$USER-bucket/appliance_binaries/latest'
	alias downloadOnboardBinary='mkdir -p /tmp && gsutil cp gs://$USER-bucket/appliance_binaries/latest/zimbru_appliance_onboard /tmp/ && chmod +x /tmp/zimbru_appliance_onboard'
	alias buildTaBinary='blaze build //cloud/transfer/appliance/offline/external/capture:ta'
	alias uploadTaBinary='gsutil cp blaze-bin/cloud/transfer/appliance/offline/external/capture/ta gs://$USER-bucket/appliance_binaries/latest'
	alias downloadTaBinary='gsutil cp gs://$USER-bucket/appliance_binaries/latest/ta /tmp && chmod +x /tmp/ta'

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

function gcsfuseSrcAliases() {
	export gcsfuse_src_dir=~/work/cloud/storage/client/gcsfuse/src/gcsfuse
	export gcsfuse_src2_dir=~/work/cloud/storage/client/gcsfuse/src2/googlecloudplatform/gcsfuse
	alias src='cd ${gcsfuse_src_dir}'
	alias src2='cd ${gcsfuse_src2_dir}'
	alias lsfusemnts='cat /etc/mtab | grep gcsfuse | cut -d '"'"' '"'"' -f1-2'
#        alias lsfusemnts='echo From df command: ; df -h --output=source,fstype,target | grep '"'"'gcsfuse\|Mounted'"'"' ; echo . ; echo From /etc/mtab:  ;  cat /etc/mtab | grep gcsfuse | cut -d '"'"' '"'"' -f1-2 '
	alias localwork='cd ~/work/cloud/storage/client/gcsfuse/tasks'
	alias work='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks'
	#alias golang='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-golang1.20.5'
	#alias encoding='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-08-gzip-support'
}

function unmountGcsfuse() {
#	set -e
	if [[ $# -ne 1 ]]; then
		echo "unmountGcsfuse: expected 1 input: <gcsfuse-mount-path-to-be-unmounted>"
		return 1
	fi
	mntpath=$1
	if [ ! -d "$mntpath" ] ; then
		echo "unmountGcsfuse: passed argument \'"${mntpath}"\' is not a directory"
		return 1
	fi
	echo "Unmounting gcsfuse mount "${mntpath}" ..."
	fusermount -uz $mntpath
	echo "... Unmounted "${mntpath}
}

# function mountGcsfuse() {
# 	set -e

# 	if [[ $# -lt 1]]; then
# 		echo "mountGcsfuse: at least one argument is required: <gcsfuse-mount-path> <bucket-name-to-be-mounted> <options>"
# 		return 1
# 	fi

# 	bucket=
# 	options=

# 	mountpath=$1

# 	if [[ $# -gt 1 ]]; then
# 		bucket=$2

# 		if [[ $# -gt 1 ]]; then
# 			options="${@:3}"
# 		fi
# 	else
# 		echo "mountGcsfuse: bucket not passed, so assuming dynamic-mount"
# 	fi

# 	echo "Mounting bucket="${bucket}" at "${mountpath}" using commandline-args: ${options} ..."
# 	cd ~/work/cloud/storage/client/gcsfuse/src/gcsfuse && CGO_ENABLED=0 go run . ${options} ${bucket} ${mountpath}
# 	echo "... Mounted bucket="${bucket}" at "${mountpath} ."
# }

function gcsfuseTestAliases() {
	gcsfuseSrcAliases
	testbucketmountdir=~/work/cloud/storage/client/gcsfuse/test_buckets

	testbucket1=gargnitin-fuse-test-bucket1
	testbucket1mountpath=$testbucketmountdir/$testbucket1-mount
	testbucket1configfile=${gcsfuse_src_dir}/config-trace-gargnitin-fuse-test-bucket1.yaml
	alias loadfusetestbucket1='bucket=$testbucket1 && mountdir=$testbucketmountdir && mountpath=$testbucket1mountpath && mkdir -pv $mountpath && (unmountGcsfuse $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ${gcsfuse_src_dir}  && CGO_ENABLED=0 go run . --foreground --config-file=${testbucket1configfile} --log-format=text --stat-cache-capacity=100000000 $bucket $mountpath'
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
	#alias gcscp='gcloud storage cp'
}

gcsfuseSrcAliases
gcsfuseTestAliases
