#!/bin/bash
#SBATCH --job-name=sub_gu
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=06:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_gu%j.eo
#SBATCH --error=err_gu%j.eo

set -evx # verbose messages and crash message

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"

# IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/NASA/GEOS-3km/DW-ATM/atmos
IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/MetOffice/UM-5km/DW-ATM/atmos
OUT_PATH=/scratch/b/b380883/

declare -a VarArray15min=(pr)

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/15min/$v/r1i1p1f1/2d/gn/*2020013*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/${LOC}_$fname
        cdo sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file 
    done
done