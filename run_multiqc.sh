#!/bin/bash

echo "Aggregating reports with MultiQC..."

# Run multiqc on the results directory and output the HTML report into results/
multiqc $HOME/BIFX_572/temp2-Noah/results/ -o $HOME/BIFX_572/temp2-Noah/results/

echo "MultiQC complete!"
