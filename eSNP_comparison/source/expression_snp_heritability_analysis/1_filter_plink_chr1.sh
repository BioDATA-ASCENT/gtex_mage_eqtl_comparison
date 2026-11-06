#!/bin/bash  
#SBATCH --job-name=filter_1kgp_vcf   
#SBATCH --mem=32G  
#SBATCH --cpus-per-task=4  
#SBATCH --time=12:00:00  
#SBATCH --output=logs/filter_norm_%a_%j.out  
#SBATCH --error=logs/filter_norm_%a_%j.err

set -euo pipefail

module load EB5
module load EB5Modules
module load EBModules
module load BCFtools/1.23.1-GCC-15.2.0
module load plink2/2.0.0

cd /grid/chambwe/home/founta/code_athon/data/vcf
mkdir -p /grid/chambwe/home/founta/code_athon/data/plink

plink2 \
    --vcf CCDG_14151_B01_GRM_WGS_2020-08-05_chr1.filtered.shapeit2-duohmm-phased.vcf.gz \
    --keep /grid/chambwe/home/founta/code_athon/metadata/expr_samples.txt \
    --make-bed \
    --out /grid/chambwe/home/founta/code_athon/data/plink/chr1 \
    --snps-only \
    --max-alleles 2 \
    --rm-dup exclude-all \
    --maf 0.01 \
    --geno 0.05 \
    --set-all-var-ids '@:#:$r:$a' \
    --threads 4 
