#!/bin/bash
#SBATCH --job-name=icon
#SBATCH --partition=compute
#SBATCH --mem=50GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_i.eo
#SBATCH --error=err_i%j.eo

set -evx # verbose messages and crash message

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos
OUT_PATH=/scratch/b/b380883
GRID_FILE=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc

LON0=143
LON1=153
LAT0=-5
LAT1=5
REGION="TWP"

# declare -a VarArray15min=(rsutacc) # rltacc) #pracc clivi)
# declare -a DateArray=(219 22)
# export GRIB_DEFINITION_PATH=/sw/rhel6-x64/eccodes/definitions

# 15 min vars
# for v in "${VarArray15min[@]}"; do
#     for d in "${DateArray[@]}"; do
#         for f in $IN_PATH/$MODEL_PATH/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
#             fname=$(basename $f)
#             out_file=$OUT_PATH/$fname
#             # cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file  
#         done
#     done
# done

# 3D vars
declare -a VarArray3D=(ta) # rltacc) #pracc clivi)
declare -a DateArray=(13 20 21 22)

for v in "${VarArray3D[@]}"; do
    for d in "${DateArray[@]}"; do
        for f in $IN_PATH/$MODEL_PATH/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$OUT_PATH/$REGION"_"$fname
            cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file  
        done
    done
done

echo "done"
