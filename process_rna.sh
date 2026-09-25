#!/bin/bash

# run this in the main project directory with the `samples.txt` corresponding to the sample you want to run
# for example, to run ERR458494, that should be the only sampe in the file

# to run; bash process_rna.sh
# also, think about running in background w/nohup so you can walk away/do something else.
# use this cmd: nohup bash scripts/process-rna.sh > process.log 2>&1 &
#     this will run it with (no hangups) and give a progress log file you can check.

# Check if it's still running: ps aux | grep process-rna.sh
# View real-time progress: tail -f process.log
# (Press Ctrl + C to exit the live view without stopping the script).
# Safely kill the job if something goes wrong:
#      Find the Process ID (PID) from the ps command above and run kill <PID>.

########### Change paths from hardcoded to symbolic links to the right locations

# Make sure this is your index directory
INDEX="/mnt/cluster_storage/data/ref/Octopus_bimaculoides_2_ASM119413v2_index"


# Get an array of all samples to be processed
mapfile -t all_samples < "samples.txt"

for SAMPLE in "${all_samples[@]}"; do

      echo "Processing sample: ${SAMPLE}"

      # Define input paths for BOTH paired-end files
      IN1="/mnt/cluster_storage/data/ref/Birk2023/${SAMPLE}_1.fastq.gz"
      IN2="/mnt/cluster_storage/data/ref/Birk2023/${SAMPLE}_2.fastq.gz"
      
      TRIMMED1="/mnt/cluster_storage/data/tjw8/572_project2/intermediate/${SAMPLE}_1_trimmed.fastq.gz"
      TRIMMED2="/mnt/cluster_storage/data/tjw8/572_project2/intermediate/${SAMPLE}_2_trimmed.fastq.gz"

      SALMON_OUT="/mnt/cluster_storage/data/tjw8/572_project2/results/${SAMPLE}_quant"

      # Run fastp with paired-end inputs (-i and -I) and outputs (-o and -O)
      echo "Running fastp..."
      fastp -i ${IN1} -I ${IN2} \
            -o ${TRIMMED1} -O ${TRIMMED2} \
            --html /mnt/cluster_storage/data/tjw8/572_project2/results/${SAMPLE}_fastp.html \
            --json /mnt/cluster_storage/data/tjw8/572_project2/results/${SAMPLE}_fastp.json \
            --thread 2

      # Run salmon quant with paired-end inputs (-1 and -2)
      echo "Running salmon quant..."
      salmon quant -i ${INDEX} -l A \
                   -1 ${TRIMMED1} \
                   -2 ${TRIMMED2} \
                   -p 2 --validateMappings -o ${SALMON_OUT}

      echo "Sample ${SAMPLE} complete!"
done