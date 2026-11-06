#!/bin/bash
#SBATCH --job-name=ld_pca
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --output=logs/ld_pca_%j.out
#SBATCH --error=logs/ld_pca_%j.err

set -euo pipefail

module load EB5
module load EB5Modules
module load EBModules 
module load plink2/2.0.0

OUT_DIR="/grid/chambwe/home/founta/code_athon/data/plink"

mkdir -p ${OUT_DIR}/pca ${OUT_DIR}/covariates

# Step 1: LD pruning  
echo "[$(date)] LD pruning..."
plink2 \
    --bfile ${OUT_DIR}/chr1 \
    --indep-pairwise 1000 100 0.2 \
    --out ${OUT_DIR}/ld_prune \
    --threads 8

echo "SNPs before pruning: $(wc -l < ${OUT_DIR}/chr1.bim)"
echo "SNPs after pruning:  $(wc -l < ${OUT_DIR}/ld_prune.prune.in)"

# Step 2: PCA on pruned SNPs
echo "[$(date)] Running PCA..."
plink2 \
    --bfile ${OUT_DIR}/chr1 \
    --extract ${OUT_DIR}/ld_prune.prune.in \
    --pca 10 \
    --out ${OUT_DIR}/pca/genotype_pca \
    --threads 8 \
    --memory 60000

echo "[$(date)] PCA done!"

# Step 3: Format for GCTA (--qcovar needs FID IID PC1 PC2 ..., no header)  
if head -1 ${OUT_DIR}/pca/genotype_pca.eigenvec | grep -q '^#FID'; then
    sed '1d' ${OUT_DIR}/pca/genotype_pca.eigenvec \
        > ${OUT_DIR}/covariates/genotype_pcs.txt
else
    # only IID column present, so add FID = 0 to match the .fam  
    awk 'NR>1 {print "0", $0}' ${OUT_DIR}/pca/genotype_pca.eigenvec \
        > ${OUT_DIR}/covariates/genotype_pcs.txt
fi

head -3 ${OUT_DIR}/covariates/genotype_pcs.txt