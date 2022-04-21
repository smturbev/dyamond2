#!/bin/bash
#SBATCH --job-name=subtwp_geos
#SBATCH --partition=prepost
#SBATCH --ntasks=8
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_g2dtwp_%j.eo
#SBATCH --error=err_g2dtwp_%j.eo

set -evx # verbose messages and crash message

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"

IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
MODEL_PATH=NASA/GEOS-6km
OUT_PATH=/scratch/b/b380883/dyamond2/GEOS/$LOC

# /work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/NASA/GEOS-6km/DW-CPL/atmos/15mn/rsdt/r1i1p1f1/2d/gn
declare -a VarArray15min=(rsdt rsut) #clivi rlut rlutcs 

# 15 min vars
for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-CPL/atmos/15mn/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$v/$fname
        echo "15 min variable "$v":"
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done