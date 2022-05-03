#!/bin/bash
#SBATCH --job-name=subtwp_scream_winter
#SBATCH --partition=prepost
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=output_scream2dtwp.eo%j
#SBATCH --error=err_scream2dtwp.eo%j

set -evx # verbose messages and crash message

IN_PATH=/work/bk1040/DYAMOND/data/winter_data/DYAMOND_WINTER
MODEL_PATH=LLNL/SCREAM-3km
OUT_PATH=/scratch/b/b380883/dyamond2/SCREAM
GRID_FILE=${OUT_PATH}/gridmap
echo $GRID_FILE

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP"

declare -a VarArray15min=(clivi)

# 15 min vars
#for v in "${VarArray15min[@]}"; do
#    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#        fname=$(basename $f)
#        out_file=$OUT_PATH/$LOC"_"$fname
#        echo "15 min variable "$v":"
#        cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file
#    done
#done

###### test #######
out=$OUT_PATH/test_scream_native_reducegrid.nc
lat_mask=/scratch/b/b380883/scream_lat_mask.nc
cdo reducegrid,$lat_mask $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/clivi_15min_SCREAM-3km_DW-ATM_r1i1p1f1_2d_gn_20200223000000-20200223234500.nc $out
