#!/bin/bash
#SBATCH --job-name=sub_nicam
#SBATCH --partition=compute
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_n%j.eo
#SBATCH --error=err_n%j.eo

set -evx # verbose messages and crash message

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=AORI/NICAM-3km
OUT_PATH=/scratch/b/b380883/

LON0=0
LON1=360
LAT0=-30
LAT1=30
# LON0=143
# LON1=153
# LAT0=-5
# LAT1=5
LOC="GT"

declare -a VarArray15min=() # pr clivi rlut clt #rsut rsdt #clivi rlut

# # 15 min vars
# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/${LOC}_$fname
#         echo "15 min variable "$v":"
#        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
#     done
# done

declare -a VarArray3D=(grplmxrat snowmxrat) # cli clw hus ta grplmxrat snowmxrat rainmxrat
declare -a DateArray=(13 20 21 22)

# # 3D 3 hr vars
for v in "${VarArray3D[@]}"; do
    for d in "${DateArray[@]}"; do
        for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/3hr/$v/r1i1p1f1/zl/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$OUT_PATH/$fname
            echo "3D 3hr variable "$v":"
            cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
        done
    done
done
