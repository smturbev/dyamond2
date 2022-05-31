#!/bin/bash
#SBATCH --job-name=subtwp
#SBATCH --partition=prepost
#SBATCH --ntasks=1
#SBATCH --mem=50GB
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_twp_%j.eo
#SBATCH --error=err_twp_%j.eo

set -evx # verbose messages and crash message

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP"

IN_PATH=/work/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883/dyamond2/GEOS/$LOC

##### GEOS #####
## something wrong with GEOS file
# OUT_PATH=/scratch/b/b380883/dyamond2/GEOS/$LOC
# MODEL_PATH=NASA/GEOS-3km
# declare -a VarArray15min=(rlut clivi clt) # rsdt rsut
# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_"$fname
#         echo "GEOS from native global to TWP:"
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
#     done
# done

##### UM #####
# OUT_PATH=/scratch/b/b380883/dyamond2/UM/$LOC
# MODEL_PATH=MetOffice/UM-5km 
# declare -a VarArray15min=(rsdt rsut rlut clivi)

# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_"$fname
#         echo "UM from native global to TWP:"
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
#     done
# done

##### SAM2 #####
## done
# OUT_PATH=/scratch/b/b380883/dyamond2/SAM/$LOC
# MODEL_PATH=SBU/SAM2-4km/
# declare -a VarArray15min=(rltacc rstacc clivi)

# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$fname
#         echo "SAM2 15 min variable "$v":"
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
#     done
# done

##### NICAM #####
# OUT_PATH=/scratch/b/b380883/dyamond2/NICAM/$LOC
# MODEL_PATH=AORI/NICAM-3km
# declare -a VarArray15min=(clivi rlut rsut rsdt)

# for v in "${VarArray15min[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$fname
#         echo "NICAM 15 min variable "$v":"
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file  
#     done
# done


###### ICON #####
export GRIB_DEFINITION_PATH=/sw/rhel6-x64/eccodes/definitions
OUT_PATH=/scratch/b/b380883/dyamond2/ICON/$LOC
MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km
GRID_FILE=/work/bk1040/DYAMOND/data/winter_data/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc

declare -a VarArray15min=(rltacc rstacc clt rsutacc qgvi qsvi) # clivi

for v in "${VarArray15min[@]}"; do
   for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*; do
       fname=$(basename $f)
       out_file=$OUT_PATH/$fname
       echo "ICON 15 min variable "$v":"
       cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_FILE $f $out_file  
   done
done

