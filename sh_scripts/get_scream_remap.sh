#!/bin/bash
#SBATCH --job-name=remap_scream
#SBATCH --partition=shared
#SBATCH --time=04:00:00
#SBATCH --mem=20GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_screamr_%j.eo
#SBATCH --output=out_screamr_%j.eo

set -evx # verbose messages and crash message

############################################
## to regrid use the following code:      ##
############################################

# module rm cdo
module load cdo
cdo -V

LON0=143
LON1=153
LAT0=-5
LAT1=5

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/
MODEL_PATH=LLNL/SCREAM-3km
OUT_PATH=/scratch/b/b380883/
GRID_FILE=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/$MODEL_PATH/grid.nc
echo $GRID_FILE
LOC="regridded30km_TWP"

declare -a VarArray15min=(rlt rst) # done: clivi rlt rst

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$LOC"_"$fname
        echo "15 min variable "$v":"
        cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.3 -setgrid,$GRID_FILE -selgrid,1 $f $out_file
    done
done

##############################################
## use regridded code to do regional subset ##
##############################################

# PATH=/scratch/b/b380883/dyamond2/SCREAM/global

# LON0=0
# LON1=360
# LAT0=-30
# LAT1=30

# declare -a VarArray=(clivi rst rlt rltcs)

# for var in "${VarArray[@]}"; do
#     f="regridded_global_"$var"_SCREAM-3km_0.25deg_20200120-20200301.nc"
#     out_file=$PATH/"GT_"$f
#     echo $f
#     cdo sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $PATH/$f $out_file
# done
