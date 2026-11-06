# Load basic modules
import os
import pandas as pd
import hail as hl
hl.init(default_reference='GRCh38') #,min_block_size=128

## Load eSNP location file and preprocess it
data = pd.read_csv("~/code_athon/results/variant_key_coordinates.csv", sep="\t")

ht = hl.Table.from_pandas(data)

ht = ht.annotate(locus=hl.parse_locus(ht.locus))
ht = ht.key_by('locus')

sorted_table = ht.order_by(ht.locus)
sorted_table = sorted_table.key_by('locus')

## Load gnomad VAT table
vat_table =hl.read_table("/grid/chambwe/data/reference/gnomad/v4.1.0/gnomad.genomes.v4.1.sites.ht") #joint

# Change VAT table key
vat2 = vat_table.key_by("locus")

## Keep only variants that exist in both table
vat_annotations = vat2.semi_join(sorted_table)
vat_annotations = vat_annotations.key_by('locus','alleles')

# Save global frequency, grpmax freq and grpmac ancetsry as seperate arrays
global_freq=vat_annotations.freq.AF
grpmax_freq=vat_annotations.grpmax.AF
grpmax_ancestry=vat_annotations.grpmax.gen_anc

## Now save results
global_freq.export("/grid/chambwe/home/founta/code_athon/results/global_freq_gnomad.tsv")
grpmax_freq.export("/grid/chambwe/home/founta/code_athon/results/grpmax_freq_gnomad.tsv")
grpmax_ancestry.export("/grid/chambwe/home/fountacode_athon/results/grpmax_ancestry_gnomad.tsv")