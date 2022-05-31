#!/bin/bash
#SBATCH --job-name=icon_gt
#SBATCH --partition=prepost
#SBATCH --mem=100GB
#SBATCH --ntasks=1
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_i.eo
#SBATCH --error=err_i.eo

set -evx # verbose messages and crash message

IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos
OUT_PATH=/scratch/b/b380883/dyamond2/ICON/GT
GRID_FILE=/work/bk1040/DYAMOND/data/winter_data/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc

LON0=0
LON1=360
LAT0=-30
LAT1=10

declare -a VarArray15min=(rstacc) # rltacc) #pracc clivi)
export GRIB_DEFINITION_PATH=/sw/rhel6-x64/eccodes/definitions

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$fname
        cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file  
    done
done