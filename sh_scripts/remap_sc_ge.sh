#!/bin/bash
#SBATCH --job-name=remap
#SBATCH --partition=compute
#SBATCH --time=04:00:00
#SBATCH --mem=20GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_remap.eo
#SBATCH --output=out_remap.eo

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

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883

# MODEL_PATH=LLNL/SCREAM-3km
MODEL_PATH=NASA/GEOS-3km
GRID_FILE=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/$MODEL_PATH/grid.nc

echo $GRID_FILE
LOC="r0.25deg_TWP"

declare -a VarArray15min=(rsut) # done scream: clivi rlt rst; done geos: rlut rst rsut

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$LOC"_"$fname
        echo "15 min variable "$v":"
        # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_FILE -selgrid,1 $f $out_file
        cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 $f $out_file
    done
done
