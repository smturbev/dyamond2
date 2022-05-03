#!/bin/bash
#SBATCH --job-name=subtwp_nicam
#SBATCH --partition=prepost
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_n%j.eo
#SBATCH --error=err_n%j.eo

set -evx # verbose messages and crash message

IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=AORI/NICAM-3km
OUT_PATH=/scratch/b/b380883/dyamond2/NICAM

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"

declare -a VarArray15min=(clivi rlut) #rsut rsdt #clivi rlut

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$v/$fname
        echo "15 min variable "$v":"
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done