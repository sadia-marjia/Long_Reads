#!/bin/bash

# Name
#SBATCH --job-name=porechop

# Resources
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=05:00:00

# Account
#SBATCH --account=PDS0344

# Logs
#SBATCH --mail-user=sxf520@case.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Directories
PROJ_DIR=/fs/scratch/PDS0344
WORK_DIR=$PROJ_DIR/LongQC_result
OUTPUT_DIR=$PROJ_DIR/Porechop_result

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Load Conda module (if needed)
module load miniconda3

# Activate the Conda environment
conda activate /fs/scratch/PDS0344/porechop-env

# Define an array of barcode directories
barcode_dirs=("barcode15" "barcode16" "barcode17")

# Loop through each barcode directory
for barcode in "${barcode_dirs[@]}"; do
    INPUT_DIR="$WORK_DIR/$barcode"
    in_contigs="$INPUT_DIR/combined.fastq.gz"  # Path to input contig file
    out="$OUTPUT_DIR/${barcode}_combined_porechop.fastq.gz"  # Path to output file

    # Check if the input file exists
    if [ -f "$in_contigs" ]; then
        # Run Porechop on the combined file
        porechop -i "$in_contigs" -o "$out" 
        echo "Porechop completed for $in_contigs, output saved to $out"
    else
        echo "Input file not found: $in_contigs"
    fi
done
