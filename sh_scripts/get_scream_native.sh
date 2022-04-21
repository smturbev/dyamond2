#!/bin/bash
#SBATCH --job-name=subtwp_scream_winter
#SBATCH --partition=prepost
#SBATCH --ntasks=8
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_scream_%j.eo
#SBATCH --error=err_scream_%j.eo

set -evx # verbose messages and crash message

############################################
## to regrid use the following code:      ##
############################################

module rm cdo
module load cdo/2.0.2-magicsxx-gcc64
cdo -V

# IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/
# MODEL_PATH=LLNL/SCREAM-3km
# OUT_PATH=/scratch/b/b380883/dyamond2/SCREAM
# GRID_FILE=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
# echo $GRID_FILE
# LOC="regridded_global"

# declare -a VarArray15min=(rltcs) # done: clivi rlt rst
# declare -a Count=(0)

# # 15 min vars
# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_"$fname
#         echo "15 min variable "$v":"
#         cdo -f nc4 -P 8 -s -w -remapdis,global_0.25 -setgrid,$GRID_FILE -selgrid,1 $f $out_file
#     done
# done

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
