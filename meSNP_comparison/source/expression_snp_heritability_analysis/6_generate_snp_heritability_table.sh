#!/bin/bash
#SBATCH --job-name=heritability_table  
#SBATCH --output=heritability_table.out  
#SBATCH --error=heritability_table.err  
#SBATCH --partition=cpuq  
#SBATCH --qos=cpu_snice  
#SBATCH --cpus-per-task=2 
#SBATCH --mem=16G  
#SBATCH --time=2-00:00

RESULTS_DIR="/grid/chambwe/home/founta/code_athon/data/plink/results/mage"
OUTPUT="/grid/chambwe/home/founta/code_athon/results/mage_heritability_table.tsv"

cd "$RESULTS_DIR" || exit 1

echo -e "CpG_ID\th2\tSE\tPval\tN\tStatus" > "$OUTPUT"

for logfile in *.log; do
    id="${logfile%.log}"
    hsqfile="${id}.hsq"

    # Extract N from the log file (works regardless of convergence)  
    n=$(grep -oP 'Non-missing phenotypes of \K[0-9]+(?= individuals)' "$logfile")
    
    if [[ -s "$hsqfile" ]]; then
        # Parse the .hsq file for V(G)/Vp line (heritability), Pval, and N
        h2=$(awk -F'\t' '$1=="V(G)/Vp" {print $2}' "$hsqfile")
        se=$(awk -F'\t' '$1=="V(G)/Vp" {print $3}' "$hsqfile")
        pval=$(awk -F'\t' '$1=="Pval" {print $2}' "$hsqfile")

        echo -e "${id}\t${h2}\t${se}\t${pval}\t${n}\tCONVERGED" >> "$OUTPUT"
    else
        echo -e "${id}\tNA\tNA\tNA\t${n}\tFAILED" >> "$OUTPUT"
    fi
done

echo "Done. Summary written to $OUTPUT"