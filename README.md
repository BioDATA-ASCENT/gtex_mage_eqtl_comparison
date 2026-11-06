# GTEx vs. MAGE eQTL comparison

Comparison of expression quantitative trait loci (eQTLs) from  
[GTEx](https://www.gtexportal.org/home/downloads/adult-gtex/qtl) with eQTLs from the  
[MAGE study](https://github.com/mccoy-lab/MAGE) (Multi-ancestry Analysis of Gene Expression),  
to identify eQTLs shared across populations and eQTLs that are population-differentiated.

## Study Motivation

GTEx is the main reference resource for eQTLs, but its donors are predominantly of  
European ancestry. eQTLs discovered in one ancestry group may not  
transfer to others, for several reasons inlcuding:

- **Allele frequency differences:** a variant that is common in one population and rare  
  in another gives different statistical power to detect an eQTL, so an eQTL can appear  
  population-specific only because of frequency, not biology.  
- **LD differences:** the tag variant for a causal eQTL varies with local  
  linkage disequilibrium structure, so lead variants can differ between populations.  

MAGE profiles gene expression in a globally diverse cohort (731 individuals from the 1000 Genomes Project). Comparing it with the European-enriched GTEx  
cohort lets us:

1. Identify **shared eQTLs** that replicate across ancestries, which are likely robust  
   regulatory variants.  
2. Identify **population-differentiated eQTLs**
3. Detect **eQTLs with opposite effects across populations**
4. Estimate transferability of **eQTL-based expression prediction across population groups**
5. Determine which differentiated eQTLs are **driven by SNPs with different allele  
   frequencies** between populations (using gnomAD, 1000 Genomes and HGDP frequencies),  
   versus differences that frequency alone does not explain.

This helps assess how well eQTL resources generalize beyond European ancestry, which  
matters for interpreting GWAS signals and for equitable use of functional genomics data.

## Data sources

| Dataset | Source | Version |  
|---|---|---|  
| GTEx eQTLs (fine-mapped variant-gene pairs) | https://www.gtexportal.org/home/downloads/adult-gtex/qtl v11|   
| MAGE eQTLs and expression | https://github.com/mccoy-lab/MAGE |   
| Allele frequencies | gnomAD genomes v4.1.0, 1000 Genomes (1KGP), HGDP | 

## Repository layout

TBD
