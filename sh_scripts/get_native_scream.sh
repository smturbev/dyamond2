#!/bin/bash
#SBATCH --job-name=subtwp_scream_winter
#SBATCH --partition=prepost
#SBATCH --mem=20GB
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=output_screamnative.eo
#SBATCH --error=err_screamnative.eo

set -evx # verbose messages and crash message

IN_PATH=/work/bk1040/DYAMOND/data/winter_data/DYAMOND_WINTER
MODEL_PATH=LLNL/SCREAM-3km
GRID_FILE=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
echo $GRID_FILE

# LON0=0
# LON1=360
# LAT0=-30
# LAT1=30
LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP"

OUT_PATH=/scratch/b/b380883/dyamond2/SCREAM/$LOC

declare -a VarArray15min=(rlt) #rst clivi)

# 15 min vars
# for v in "${VarArray15min[@]}"; do
#    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#        fname=$(basename $f)
#        out_file=$OUT_PATH/$LOC"_"$fname
#        echo "15 min variable "$v":"
#        cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file
#    done
# done

###### test #######
# out=$OUT_PATH/test_scream_native_reducegrid.nc
# lat_mask=/scratch/b/b380883/scream_lat_mask.nc
# cdo reducegrid,$lat_mask $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/clivi_15min_SCREAM-3km_DW-ATM_r1i1p1f1_2d_gn_20200223000000-20200223234500.nc $out

### solar insolation from Ben Hillman ###
cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE -seldate,2020-01-30T00:00:00,2020-03-01T23:59:00 /work/bb1153/b380883/SCREAM_global_SOLIN_20200120-20200301.nc /work/bb1153/b380883/TWP/TWP_SCREAM_rsdt_20200130-20200301.nc