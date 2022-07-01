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
OUT_PATH=/scratch/b/b380883

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP"

# declare -a VarArray15min=(qvi) #pracc clivi rltacc rstacc

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*202002*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$LOC"_"$fname
        echo "15 min variable "$v":"
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done

declare -a VarArray3D=(hus) # cli clw hus ta
declare -a DateArray=(225 226 227 228 229 301)

# 15 min vars
for v in "${VarArray3D[@]}"; do
   for d in "${DateArray[@]}"; do
        for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$OUT_PATH/$LOC"_"$fname
            echo "3hr variable "$v":"
            cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
       done
    done
done
