#!/bin/bash
#SBATCH --job-name=subtwp
#SBATCH --partition=prepost
#SBATCH --ntasks=8
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_twp_%j.eo
#SBATCH --error=err_twp_%j.eo

set -evx # verbose messages and crash message

LON0=143.0
LON1=153.0
LAT0=-5.0
LAT1=5.0
LOC="TWP"

IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER

##### GEOS #####
# OUT_PATH=/scratch/b/b380883/dyamond2/GEOS/$LOC
# MODEL_PATH=NASA/GEOS-6km # AORI/NICAM-3km SBU/SAM2-4km/
# declare -a VarArray15min=(rsdt rsut clivi rlut rlutcs)

# for f in /scratch/b/b380883/dyamond2/GEOS/GT/*.nc; do
#     fname=$(basename $f)
#     out_file=$OUT_PATH/$fname
#     echo "GEOS from GT to TWP:"
#     cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
# done

##### SAM2 #####
OUT_PATH=/scratch/b/b380883/dyamond2/SAM/$LOC
MODEL_PATH=SBU/SAM2-4km/
declare -a VarArray15min=(rltacc rstacc clivi)

for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$fname
        echo "SAM2 15 min variable "$v":"
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done

##### NICAM #####
OUT_PATH=/scratch/b/b380883/dyamond2/NICAM/$LOC
MODEL_PATH=AORI/NICAM-3km
declare -a VarArray15min=(clivi rlut rsut rsdt)

for v in "${VarArray15min[@]}"; do
    for f in $IN_PATH/$MODEL_PATH/DW-CPL/atmos/15mn/$v/r1i1p1f1/2d/gn/*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/$fname
        echo "NICAM 15 min variable "$v":"
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
    done
done


