#!/bin/bash  
#SBATCH --job-name=rm
#SBATCH --mem=64G  
#SBATCH --cpus-per-task=8  
#SBATCH --time=12:00:00  
#SBATCH --output=logs/grm_%j.out  
#SBATCH --error=logs/grm_%j.err

module load EB5
module load EB5Modules
module load EBModules 
module load plink2/2.0.0

OUT_DIR="/grid/chambwe/home/founta/code_athon/data/plink"

mkdir -p ${OUT_DIR}/grm

# Step 3: Build GRM
source /grid/it/data/elzar/easybuild/software/Anaconda3/2022.05/etc/profile.d/conda.sh 
conda activate gcta_env # Activate gcta conda environment

echo "[$(date)] Building GRM..."
gcta64 \
    --bfile ${OUT_DIR}/chr1 \
    --make-grm \
    --out ${OUT_DIR}/grm/chr1_all_samples \
    --thread-num 8

echo "[$(date)] COMPLETED SUCCESSFULLY"

conda deactivate