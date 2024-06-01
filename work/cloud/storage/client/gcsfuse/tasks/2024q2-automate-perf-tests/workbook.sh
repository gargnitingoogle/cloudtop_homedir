#!/bin/bash

#fio test machine
vm_name=gargnitin-test-n2std32-us-west1
zone=sudo glinux-information
gcsfusetestvmconnect $vm_name $zone

#dlio test machine
gcsfusetestvmconnect gcs-fuse-cloud-demo-n2-standard-96-2 us-central1-a

#parse dlio outputs
mkdir -pv thread_outputs && n=12 && for (( i=0 ; i < n ; i++ )) ; do fn=${i}_output.json ; echo fn=${fn} ;  gcsfusetestvmconnect gcs-fuse-cloud-demo-n2-standard-96-2 us-central1-a "cat ~/dlio_benchmark/hydra_log/unet3d/2024-04-26-04-30-35/${fn}" > thread_outputs/${fn} && ls -lh thread_outputs/${fn} && head -n 1 thread_outputs/${fn} ; done
for fn in summary.json per_epoch_stats.json ; do echo fn=$fn;  gcsfusetestvmconnect gcs-fuse-cloud-demo-n2-standard-96-2 us-central1-a "cat ~/dlio_benchmark/hydra_log/unet3d/2024-04-26-04-30-35/${fn}" > ${fn} && ls -lh ${fn} && head -n 1 ${fn} ; donefn=summary.json
cd ../005_20240426-0108IST_Small_500KB-1100GB_Load_8_threads/

