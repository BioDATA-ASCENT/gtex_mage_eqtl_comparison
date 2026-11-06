#!/bin/bash  
OFFSET=0
N=905
SUBMIT_LIMIT=1000
SAFETY_MARGIN=20

mkdir -p logs

while true; do
    CURRENT=$(squeue -u founta -h | wc -l)
    AVAILABLE=$((SUBMIT_LIMIT - SAFETY_MARGIN - CURRENT))
    if [[ ${AVAILABLE} -ge ${N} ]]; then
        break
    fi
    echo "$(date): Waiting for headroom (current=${CURRENT}, need=${N}, available=${AVAILABLE})..."
    sleep 30
done

echo "Submitting chunk 1: OFFSET=${OFFSET}, tasks 1-${N}"
sbatch --qos=cpu_snice --array=1-${N}%50 --export=ALL,OFFSET=${OFFSET} ~/code_athon/source/clair3_vcfs/4_run_gcta_gtex_egenes.sh