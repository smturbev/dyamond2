#!/bin/bash
#SBATCH --job-name=ttl_cli
#SBATCH --partition=compute
#SBATCH --mem=80GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_TTL%j.eo
#SBATCH --error=err_TTL%j.eo

set -evx # verbose messages and crash message

DY=/work/ka1081/DYAMOND_WINTER/
IN2D=DW-ATM/atmos/15min
IN3D=DW-ATM/atmos/3hr

GRID_SC=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc

IN_GE=NASA/GEOS-3km
IN_UM=MetOffice/UM-5km
IN_AR=METEOFR/ARPEGE-NH-2km
IN_IC=MPIM-DWD-DKRZ/ICON-NWP-2km
IN_NI=AORI/NICAM-3km
IN_SA=SBU/gSAM-4km
IN_SC=LLNL/SCREAM-3km
IN_SH=NOAA/SHiELD-3km
IN_IF=ECMWF/IFS-4km
OUT_PATH=/scratch/b/b380883

### lat lon ###
LOC="GT"
if [ $LOC = 'TWP' ] ; then
    LON0=143
    LON1=153
    LAT0=-5
    LAT1=5
elif [ $LOC = 'GT' ] ; then
    LON0=0
    LON1=360
    LAT0=-30
    LAT1=30
fi

#### select 14-18km levels ######
##### variable 
v="cli"
declare -a DateArray=(13 20 21 22)

## bottom up
# m=$IN_UM
# for d in "${DateArray[@]}"; do
#    for f in $DY/$m/$IN3D/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#        fname=$(basename $f)
#       # out_file=$OUT_PATH/${LOC}_"14-18km"_$fname
#        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=42/49 $f $out_file 
#    done
# done

## bottom up
# m=$IN_NI
# for d in "${DateArray[@]}"; do
#    for f in $DY/$m/$IN3D/$v/r1i1p1f1/zl/gn/*_20200$d*; do
#        fname=$(basename $f)
#        out_file=$OUT_PATH/${LOC}_"14-18km"_$fname
#        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=44/56 $f $out_file 
#    done
# done

## bottom up
# m=$IN_SA
# for d in "${DateArray[@]}"; do
#     for f in $DY/$m/$IN3D/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/${LOC}_"14-18km"_$fname
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=49/57 $f $out_file 
#     done
# done

## top down
m=$IN_SC
for d in "${DateArray[@]}"; do
    for f in $DY/$m/$IN3D/$v/r1i1p1f1/ml/gn/*_20200$d*; do
        fname=$(basename $f)
        out_file=$OUT_PATH/${LOC}_"TTL"_$fname
        cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=29/47 -setgrid,$GRID_SC $f $out_file 
    done
done

## top down
# m=$IN_GE
# for d in "${DateArray[@]}"; do
#     for f in $DY/$m/DW-ATM/atmos/1hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/${LOC}_"14-18km"_$fname
#         cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=86/103 $f $out_file 
#     done
# done

# cdo -cat /scratch/b/b380883/GT_14-18km_cli_3hr_NICAM* /work/bb1153/b380883/GT/GT_14-18km_NICAM_cli_20200130-20200228.nc

#############################
##      get 150-70hPa      ##
#############################
## some models do not have height output or constant pressure levels

## ARP
# m=$IN_AR
# for d in "${DateArray[@]}"; do
#     for f in $DY/$m/$IN3D/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/${LOC}_"14-18km"_$fname
#         pres=${f//$v/"pa"}
#         out_temp=$OUT_PATH/"temp_"${LOC}_"14-18km"_$fname
#         cdo -timmin -fldmin $pres /scratch/b/b380883/min_pa_ARP_TWP.nc
#         # cdo -timmax -fldmax $pres /scratch/b/b380883/max_pa_ARP_TWP.nc
#         # cdo -f nc4 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=29/47 -setgrid,$GRID_SC $f $out_file 
#     done
# done

#############################
##### Calculate TTL IWC #####
#############################
## First we calculate the density of air, rho
##     rho = p / 287*((1 + 0.61*qv)*t)
## And, we do cli * rho to get iwc in kg/m3
##     iwc = cli * rho

# m=GEOS
# gt=/work/bb1153/b380883/GT
# cli_file=$gt/GT_14-18km_${m}_cltotal_20200130-20200228.nc
# clg_file=$gt/GT_14-18km_${m}_grplmxrat_20200130-20200228.nc
# cls_file=$gt/GT_14-18km_${m}_snowmxrat_20200130-20200228.nc
# clf_file=$gt/GT_14-18km_${m}_clf_20200130-20200228.nc

# cdo -setunit,"frac" -divc,720 -timsum -ifthenc,1 -gtc,1e-5 $cli_file $gt/timmean/timmean_GT_14-18km_${m}_cldfrac_20200130-20200228.nc 
# cdo -add -add $cli_file $clg_file $cls_file $clf_file
# cdo -setunit,"frac" -divc,240 -timsum -ifthenc,1 -gtc,1e-5 $clf_file $gt/timmean/timmean_GT_14-18km_${m}_cldfrac_20200130-20200228.nc 

echo "done"
