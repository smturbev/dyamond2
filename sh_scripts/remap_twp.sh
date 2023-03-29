#!/bin/bash
#SBATCH --job-name=reTWP_GE
#SBATCH --partition=compute
#SBATCH --time=08:00:00
#SBATCH --mem=100GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_remap%j.eo
#SBATCH --output=out_remap%j.eo

set -evx # verbose messages and crash message

############################################
## to regrid use the following code:      ##
############################################

# module rm cdo
# module load cdo
# cdo -V

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="r0.1deg_TWP"

IN_PATH=/work/ka1081/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883
TWP=/work/bb1153/b380883/TWP

# MODEL_PATH=LLNL/SCREAM-3km
MODEL_PATH=NASA/GEOS-3km
# MODEL_PATH=METEOFR/ARPEGE-NH-2km
# MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km
# MODEL_PATH=NOAA/SHiELD-3km
# MODEL_PATH=SBU/gSAM-4km
# MODEL_PATH=AORI/NICAM-3km
# MODEL_PATH=MetOffice/UM-5km

GRID_AR=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_ARPEGE-NH-2km_DW-CPL_r1i1p1f1_2d_gn_fx.nc
GRID_SC=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
GRID_IC=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc
GRID_SH=/work/ka1081/DYAMOND_WINTER/NOAA/SHiELD-3km/DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_SHiELD-3km_DW-CPL_r1i1p1f1_2d_gn_fx.nc

CON_SH=/home/b/b380883/dyamond2/sh_scripts/REMAP_SHiELD.txt

echo $GRID_ARP

# declare -a VarArray15min=(rsdt) # done scream: clivi rlt rst; done geos: rlut rst rsut clivi 
# declare -a DateArray=(13 20 21 22)

## 15 min vars
# for v in "${VarArray15min[@]}"; do
#     for d in "${DateArray[@]}"; do
#         for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do #for SHiELD 2d -> pl
#             fname=$(basename $f)
#             out_file=$OUT_PATH/$LOC"_"$fname
#             echo "15 min variable "$v":"
#             ## SCREAM: rst rlt (rsdt separately)
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r3600x1800 -setgrid,$GRID_SC -selgrid,1 $f $out_file
#             ## GEOS, NICAM, SAM, UM
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r3600x1800 $f $out_file
#             ## ARP
#             # cdo -f nc4 -P 8 -s -w -divc,900 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r3600x1800 -setgrid,$GRID_AR $f $out_file
#             ## ICON
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r3600x1800 -setgrid,$GRID_IC $f $out_file
#         done
#     done
# done

## SHiELD 2D
# for v in "${VarArray15min[@]}"; do
#     for d in "${DateArray[@]}"; do
#         for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/pl/gn/*_20200$d*; do #for SHiELD 2d -> pl
#             fname=$(basename $f)
#             out_file=$OUT_PATH/$LOC"_"$fname
#             echo "SHiELD 15 min variable "$v":"
#             ## SHiELD
#             # 0.1deg
#             # cdo -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r3600x1800 -setgrid,$GRID_SH -selgrid,1 $f $out_file
#         done
#     done
# done

### SOLIN ### from ben hillman
# cdo -remapdis,r3600x1800 -setgrid,$GRID_SCR -selgrid,1 /work/bb1153/b380883/gn_SCREAM_SOLIN_20200130-20200228.nc /work/bb1153/b380883/gn_SCREAMr0.1deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,143,153,-5,5 /work/bb1153/b380883/gn_SCREAMr0.1deg_rsdt_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_SCREAMr0.1deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,0,360,-30,30 /scratch/b/b380883/gn_SCREAM0.25deg_rsdt_20200130-20200228.nc /scratch/b/b380883/GT_SCREAMr0.25deg_rsdt_20200130-20200228.nc

## ARP needs to be divided by 900 in rad vars
# cdo -divc,-900 $TWP/TWP_ARPr0.1deg_rlt900_20200130-20200228.nc TWP_ARPr0.1deg_rlt_20200130-20200228.nc
# cdo -divc,900 $TWP/TWP_ARPr0.1deg_rst900_20200130-20200228.nc TWP_ARPr0.1deg_rst_20200130-20200228.nc

# get total frozen mixing ratio for GEOS
# cdo -add -add $TWP/TWP_GEOS_qgvi_20200130-20200228.nc $TWP/TWP_GEOS_qsvi_20200130-20200228.nc $TWP/TWP_GEOS_clivi_20200130-20200228.nc $TWP/TWP_GEOS_qfvi_20200130-20200228.nc

# new_grid="REMAP_SHiELD.txt"
# cdo -remapcon,$new_grid -setgrid,$GRID_SH $TWP/TWP_SHiELD_rsdt_20200130-20200228.nc $TWP/TWP_SHiELDr0.1deg_rsdt_20200130-20200228.nc

cdo -remapcon,REMAP_GEOS.txt $TWP/TWP_GEOS_ts_20200130-20200228.nc $TWP/TWP_GEOSr0.1deg_ts_20200130-20200228.nc

echo "done"
