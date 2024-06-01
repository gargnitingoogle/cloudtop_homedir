#!/bin/bash

# run/debug
fusermount -uz $mountpath; ./creationSituation.sh 1 && ls $mountpath
fusermount -uz $mountpath; ./creationSituation.sh 1

#useful constants
bucket=gargnitin-test-empty-dirname-asia-se1
export bucket=gargnitin-test-empty-dirname-asia-se1
mountpath=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-test-empty-dirname-asia-se1-mount
logfile=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-test-empty-dirname-asia-se1.log

export | grep 'bucket\|mountpath\|logfile'

#filter logs
tail -f $logfile | egrep -io 'message.*' | grep -vi 'BDMV\|autorun.inf\|xdg-volume-info\|Trash\|gcsfuse_tmp\|StatFS'
cat $logfile | tail -n 100 | egrep -io 'message.*' | grep -vi 'BDMV\|autorun.inf\|xdg-volume-info\|Trash\|gcsfuse_tmp\|StatFS' | less

# re-create objects for testing
fusermount -uz $mountpath ; gsutil rm -r gs://$bucket/* && gsutil cp hello.txt gs://$bucket//hello.txt && gsutil cp hello.txt gs://$bucket/hello.txt && gsutil cp hello.txt gs://$bucket/./hello.txt && gsutil cp hello.txt gs://$bucket/../hello.txt

# run unit tests
runFsTest
go test -v -test.v -timeout 30s -run ^TestFS$ github.com/googlecloudplatform/gcsfuse/v2/internal/fs

# run integration tests
GODEBUG=asyncpreemptoff=1 go test ./tools/integration_tests/implicit_dir/... -p 1 --integrationTest -v --mountedDirectory=$mountpath --testbucket=$bucket  -run TestListImplicitObjectsFromBucket

# test walk-dir on GCS
fusermount -uz $mountpath ; gsutil -m rm -r gs://$bucket/* ; (for f in foo/./f foo/c/d foo/../e foo//g  ; do gsutil cp ../../hello.txt gs://$bucket/$f ; done) && cd ../../fix-branch && ./creationSituation.sh 1 && cd - && go run . && ls $mountpath
fusermount -uz $mountpath ; gsutil -m rm -r gs://$bucket/* ; (for f in a/b foo/a/b foo//bar foo/./bar foo/../bar /bar ./bar ../bar  ; do gsutil cp ../../hello.txt gs://$bucket/$f ; done) && cd ../../fix-branch && ./creationSituation.sh 1 && cd - && go run .

