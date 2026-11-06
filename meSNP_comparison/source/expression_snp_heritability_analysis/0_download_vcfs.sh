#!/bin/bash
#SBATCH --mem=64G  
#SBATCH --cpus-per-task=16  
#SBATCH --job-name=download_files  

OUTDIR=/grid/chambwe/home/founta/code_athon/data/vcf/  # <-- change this

BASE=https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage  
DIR=$BASE/working/20201028_3202_phased

mkdir -p $OUTDIR
cd $OUTDIR

for chr in {1..22}; do 
  wget -c $DIR/CCDG_14151_B01_GRM_WGS_2020-08-05_chr${chr}.filtered.shapeit2-duohmm-phased.vcf.gz
done

wget -c $BASE/20130606_g1k_3202_samples_ped_population.txt  