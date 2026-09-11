#!/bin/bash

module load sratools

sra_list=("SRR23955290" "SRR23955291" "SRR23955292" "SRR23955293" "SRR23955294" "SRR23955295" "SRR23955296" "SRR23955297" "SRR23955298" "SRR23955299" "SRR23955300" "SRR23955301")

for item in "${sra_list[@]}"; do
    echo "Processing: $item"
    prefetch $item
    fatserq-dump $item -S -e 2 -p
    gzip $item_*
done
