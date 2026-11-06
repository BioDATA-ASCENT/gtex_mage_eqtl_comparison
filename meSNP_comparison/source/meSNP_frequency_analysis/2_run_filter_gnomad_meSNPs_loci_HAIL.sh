#!/bin/bash
#SBATCH --partition=cpuq
#SBATCH --qos=cpu_snice  
#SBATCH --job-name=retrieve_gnomad_AFs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=5-00:00:00 
#SBATCH --output=gnomad_AFs_%A_%a.out

# Activate miniconda3
source ~/.bashrc
conda activate hail

export PYSPARK_SUBMIT_ARGS='--driver-memory 16g --executor-memory 16g pyspark-shell'

# Now run python script
python /grid/chambwe/home/founta/code_athon/source/filter_gnomad_HailTable_meSNPs_loci.py
