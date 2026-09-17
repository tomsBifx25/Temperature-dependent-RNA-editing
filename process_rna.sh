#!/bin/bash

# run this in the main project directory with the `samples.txt` corresponding to the sample you want to run
# for example, to run ERR458494, that should be the only sampe in the file

# ./scripts/process_rna.sh

# Get an array of all samples to be processed
mapfile -t all_samples < "samples.txt"

for SAMPLE in "${all_samples[@]}"; do

      echo "Processing sample: ${SAMPLE}"

      # Define input and output paths based on directory structure
      IN="/mnt/cluster_storage/data/ref/Birk2023/${SAMPLE}.fastq.gz"

      TRIMMED="$HOME/BIFX_572/temp2-Noah/intermediate/${SAMPLE}_trimmed.fastq.gz"

      SALMON_OUT="$HOME/BIFX_572/temp2-Noah/results/${SAMPLE}_quant"
      INDEX="/mnt/cluster_storage/data/nwc1/Octopus_bimaculoides_CDS.fasta"

      # Run fastp for QC and trimming
      echo "Running fastp..."
      fastp -i ${IN} \
            -o ${TRIMMED} \
            --html results/${SAMPLE}_fastp.html \
            --json results/${SAMPLE}_fastp.json \
            --thread 2

      # Run salmon quant on the trimmed reads
      echo "Running salmon quant..."
      salmon quant -i ${INDEX} -l A \
                   -r ${TRIMMED} \
                   -p 2 --validateMappings -o ${SALMON_OUT}

      echo "Sample ${SAMPLE} complete!"
done