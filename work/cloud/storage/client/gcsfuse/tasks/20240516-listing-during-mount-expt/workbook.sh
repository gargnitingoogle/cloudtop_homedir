#!/bin/bash
set -x

cd $gcsfuse_src_dir
echo 'export gcsfuse_src_dir='$gcsfuse_src_dir

# command to test
# ./creationSituation.sh 2 run gargnitin-bucket-asia-se1-1 100000_objects --metadata-prefetch-on-mount=async --implicit-dirs --foreground
./creationSituation.sh 2 run gargnitin-bucket-asia-se1-1 100000_objects --metadata-prefetch-on-mount=sync --implicit-dirs --foreground
./creationSituation.sh 2 run gargnitin-bucket-asia-se1-1 100000_objects --metadata-prefetch-on-mount=async --implicit-dirs  ; reset
# ./creationSituation.sh 2 run gargnitin-bucket-asia-se1-1 100000_objects --metadata-prefetch-on-mount=sync --implicit-dirs  ; reset

# log-filtering
tail -f $logfile | egrep 'message.*'
tail -f $logfile | egrep -o 'message.*' | grep 'ListObjects\|SIGINT\|mounted\|metadata-prefetch\|ReadDir\|Start '
tail -f $logfile | grep 'ListObjects\|SIGINT\|mounted\|metadata-prefetch\|ReadDir\|Start \|ERROR'

# run integration tests
cd tools/integration_tests/operations
GODEBUG=asyncpreemptoff=1 go test .  -p 1 --integrationTest -v --mountedDirectory=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-gcsfuse-integration-tests-playground-mount2 --testbucket=gargnitin-gcsfuse-integration-tests-playground -run TestListDirectoryRecursively
#
# debug integration tests
cd tools/integration_tests/operations
GODEBUG=asyncpreemptoff=1 dlv test . --  -test.parallel 1 --integrationTest -test.v --mountedDirectory=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-gcsfuse-integration-tests-playground-mount2 --testbucket=gargnitin-gcsfuse-integration-tests-playground -test.run TestListDirectoryRecursively
GODEBUG=asyncpreemptoff=1 dlv test . --  -test.parallel 1 --integrationTest -test.v --mountedDirectory=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-gcsfuse-integration-tests-playground-mount2 --testbucket=gargnitin-gcsfuse-integration-tests-playground -test.run TestWriteAtEndOfFile


