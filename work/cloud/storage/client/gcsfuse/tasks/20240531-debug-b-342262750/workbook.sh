#!/bin/bash
set -x
set -e

export bucket=gargnitin-bucket-asia-se1-1
export mountpath=/usr/local/google/home/gargnitin/work/cloud/storage/client/gcsfuse/test_buckets/gargnitin-bucket-asia-se1-1-mount

mkdir -pv $mountpath

sudo fusermount -uz $mountpath ; sudo gcsfuse --implicit-dirs=true --file-mode 775 --dir-mode 775 --uid 0 --gid 0 -o rw -o allow_other $mountpath $mountpath && (ls $mountpath | wc -l) && (df -h | grep $mountpath )

sudo fusermount -uz $mountpath ; sudo mount -t gcsfuse -o rw,allow_other,implicit_dirs,file_mode=775,dir_mode=775,uid=0,gid=0 $bucket $mountpath && (ls $mountpath | wc -l) && (df -h | grep $mountpath)

sudo fusermount -uz $mountpath || true
#
# rm -rfv $mountpath


