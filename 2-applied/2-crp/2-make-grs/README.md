

## Generate GRS from SNP dosages

```bash
Rscript crp-grs.R
```

This creates a data file that includes the SNP dosages, plus the GRS.

## Add participant (project 16729 specific) IDs

```bash
Rscript addPhenoID.R
```

## Exclusions

We exclude relateds, non-white British, and those who have withdrawn from UKB.

```bash
Rscript exclusions.R
```
