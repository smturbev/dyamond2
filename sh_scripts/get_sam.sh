#!/bin/bash
#SBATCH --job-name=sam_sub
#SBATCH --partition=compute
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_s%j.eo
#SBATCH --error=err_s%j.eo

set -evx # verbose messages and crash message

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=SBU/SAM2-4km
OUT_PATH=/scratch/b/b380883/

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"

declare -a VarArray15min=(pracc) #clivi rltacc rstacc

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*2020013*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$LOC"_"$fname
        echo "15 min variable "$v":"
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done
