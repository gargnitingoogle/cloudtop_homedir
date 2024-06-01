#!/bin/bash

#important buckets
gargnitin-memory-testing-bucket-20230809
gargnitin-bucket-asia-se1-1
princer-read-cache-load-test-west

#to create big buckets for testing
~/work/cloud/storage/client/gcsfuse/tasks/oncall/20230807/memory-issue-285956302/objects_for_bucket

#vm name
gargnitin-test-n2std32-us-west1

#code branch
gargnitin/list-thru-metadata-cache-expt/v1

# run fix-branch
bucket=gargnitin-memory-testing-bucket-20230809
onlydir=1000_objects
cd ../fix-branch/ && ./creationSituation.sh 1 run $bucket $onlydir
for i in {1..5} ; do echo epoch#$((i)) ; time (ls -R $mountpath/128K | wc -l) ; done

#filter logs
tail -f $logfile | egrep -io 'message.*' | grep -vi 'BDMV\|autorun.inf\|xdg-volume-info\|Trash\|gcsfuse_tmp\|StatFS'
tail -f $logfile | egrep -io 'message.*' | grep -vi 'BDMV\|autorun.inf\|xdg-volume-info\|Trash\|gcsfuse_tmp\|StatFS' | grep 'gcs'

