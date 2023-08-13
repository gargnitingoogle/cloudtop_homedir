function genericAliases() {
	alias ........='cd ../../../../../../..'
	alias .......='cd ../../../../../..'
	alias ......='cd ../../../../..'
	alias .....='cd ../../../..'
	alias ....='cd ../../..'
	alias ...='cd ../..'
	alias ..='cd ..'
	alias aliases='vi ~/.bash_aliases'
	alias cls='clear'
	alias gi='git'
	alias gitconfig='vi ~/.gitconfig'
	alias gt='git'
	alias gti='git'
	alias gtl='git l'
	alias htop='htop -u $USER -t'
	alias install='sudo apt-get -y install'
	alias l='ls -lah'
	alias tailf='tail -f'
        alias lint='golangci-lint run'
}

genericAliases

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

  vmconnect "$vmname" "$zone" "$projectname"
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
	alias src='cd ~/work/cloud/storage/client/gcsfuse/src/gcsfuse'
	alias lsfusemnts='cat /etc/mtab | grep gcsfuse | cut -d '"'"' '"'"' -f1-2'
	alias dlv='~/go/bin/dlv'
	alias localwork='cd ~/work/cloud/storage/client/gcsfuse/tasks'
	alias work='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks'
	alias golang='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-golang1.20.5'
	alias encoding='cd ~/DriveFileStream/My\ Drive/docs/work/cloud/storage/gcsfuse/tasks/202307-08-gzip-support'
}

function gcsfuseTestAliases() {
	testbucket=gargnitin-fuse-test-bucket1
        testbucketmountdir=~/work/cloud/storage/client/gcsfuse/test_buckets
        testbucketmountpath=$testbucketmountdir/$testbucket-mount
	alias loadfusetest='bucket=$testbucket && mountdir=$testbucketmountdir && mountpath=$testbucketmountpath && mkdir -pv $mountpath && (fusermount -u $mountpath || true) && logpath=$mountdir/$bucket-logfile.log && rm -rfv $logpath && cd ~/work/cloud/storage/client/gcsfuse/src/gcsfuse  && CGO_ENABLED=0 go run . --implicit-dirs --debug_fuse --debug_fuse_errors --debug_gcs --debug_http --debug_fs --log-file=$logpath --debug_mutex $bucket $mountpath'
	alias unloadfusetest='bucket=$testbucket && (fusermount -u $testbucketmountpath || true)'
        alias gcsdescribe='gcloud storage objects describe'
	alias gcscp='gcloud storage cp'
}

gcsfuseSrcAliases
gcsfuseTestAliases
