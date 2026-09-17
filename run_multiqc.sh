#!/bin/bash
#SBATCH --job-name=run_multiqc
#SBATCH --time=00:10:00
#SBATCH --mem=2G
#SBATCH --output=../logs/multiqc_%j.out
#SBATCH --error=../logs/multiqc_%j.err

echo "Aggregating reports with MultiQC..."

# Run multiqc on the results directory and output the HTML report into results/
multiqc $HOME/BIFX_572/temp2-Noah/results/ -o $HOME/BIFX_572/temp2-Noah/results/

echo "MultiQC complete!"
