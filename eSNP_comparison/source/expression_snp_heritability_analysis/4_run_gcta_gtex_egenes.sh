#!/bin/bash  
#SBATCH --job-name=gcta_greml_rev  
#SBATCH --mem=16G  
#SBATCH --cpus-per-task=4  
#SBATCH --time=6:00:00  
#SBATCH --output=logs/rev/greml_%a_%j.out  
#SBATCH --error=logs/rev/greml_%a_%j.err

set -euo pipefail

OUT_DIR="/grid/chambwe/home/founta/code_athon/data/plink"
PHENO_DIR="/grid/chambwe/home/founta/code_athon/metadata"

mkdir -p ${OUT_DIR}/results/gtex

OFFSET=${OFFSET:-0}
INDEX=$((SLURM_ARRAY_TASK_ID + OFFSET))

GENE_LINE=$(sed -n "$((INDEX + 1))p" ${PHENO_DIR}/gtex_gene_mpheno_index_chr1.csv)
GENE=$(echo "$GENE_LINE" | awk -F',' '{print $2}' | tr -d '"')

if [[ -z "${GENE}" ]]; then
    echo "[$(date)] ERROR: No GENE found at INDEX=${INDEX} (line $((INDEX + 1)) of index file). Exiting."
    exit 1
fi

echo "[$(date)] Running GREML for ${GENE} (SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID}, OFFSET=${OFFSET}, INDEX=${INDEX})..."

source /grid/it/data/elzar/easybuild/software/Anaconda3/2022.05/etc/profile.d/conda.sh
conda activate gcta_env # Activate gcta conda environment

gcta64 \
    --grm ${OUT_DIR}/grm/chr1_all_samples \
    --pheno ${PHENO_DIR}/gtex_phenotype_chr1.txt \
    --mpheno ${INDEX} \
    --covar ${PHENO_DIR}/sex_covar.txt \
    --qcovar ${OUT_DIR}/covariates/genotype_pcs.txt \
    --reml \
    --out ${OUT_DIR}/results/gtex/${GENE} \
    --thread-num 4

echo "[$(date)] Done: ${GENE}"