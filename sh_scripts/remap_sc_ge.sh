#!/bin/bash
#SBATCH --job-name=remapa
#SBATCH --partition=compute
#SBATCH --time=04:00:00
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
module load cdo
cdo -V

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="r0.25deg_GT"

IN_PATH=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883
TWP=/work/bb1153/b380883/TWP

# MODEL_PATH=LLNL/SCREAM-3km
# MODEL_PATH=NASA/GEOS-3km
# MODEL_PATH=METEOFR/ARPEGE-NH-2km
MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km
GRID_ARP=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_ARPEGE-NH-2km_DW-CPL_r1i1p1f1_2d_gn_fx.nc
GRID_SCR=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
GRID_ICO=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc

echo $GRID_ARP

declare -a VarArray15min=(rltacc) # done scream: clivi rlt rst; done geos: rlut rst rsut clivi 
declare -a DateArray=(13 20 21 22)

## 15 min vars
for v in "${VarArray15min[@]}"; do
    for d in "${DateArray[@]}"; do
        for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$OUT_PATH/$LOC/$LOC"_"$fname
            echo "15 min variable "$v":"
            ## SCREAM
            # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_SCR -selgrid,1 $f $out_file
            # ## GEOS
            # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 $f $out_file
            ## ARP
            # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_ARP $f $out_file
            ## ICON
            cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_ICO $f $out_file
        done
    done
done

## 3D vars - SCREAM
# v="hus"
# for d in "${DateArray[@]}"; do
#     for f in $IN_PATH/LLNL/SCREAM-3km/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_14-18km_"$fname
#         echo "15 min variable "$v":"
#         cdo -f nc -P 8 -s -w -select,levidx=29/47 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_SCR -selgrid,1 $f $out_file
#     done
# done

# # 3D vars - GEOS
# v="cli"
# for d in "${DateArray[@]}"; do
#     for f in $IN_PATH/NASA/GEOS-3km/DW-ATM/atmos/1hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_14-18km_"$fname
#         echo "3D variable "$v":"
#         cdo -f nc -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -select,levidx=86/103 -seltimestep,0/24/3 $f $out_file
#     done
# done

### SOLIN ### from ben hillman
# cdo -remapdis,global_0.25 -setgrid,$GRID_FILE -selgrid,1 /scratch/b/b380883/gn_SCREAM_rsdt_20200130-20200228.nc /scratch/b/b380883/gn_SCREAM0.25deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,143,153,-5,5 /scratch/b/b380883/gn_SCREAM0.25deg_rsdt_20200130-20200228.nc /scratch/b/b380883/TWP_SCREAMr0.25deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,0,360,-30,30 /scratch/b/b380883/gn_SCREAM0.25deg_rsdt_20200130-20200228.nc /scratch/b/b380883/GT_SCREAMr0.25deg_rsdt_20200130-20200228.nc

## ARP needs to be divided by 900 in rad vars
# cdo -divc,900 $TWP/TWP_ARPr0.25deg_rlt900_20200130-20200228.nc TWP_ARPr0.25deg_rlt_20200130-20200228.nc
# cdo -divc,900 $TWP/TWP_ARPr0.25deg_rst900_20200130-20200228.nc TWP_ARPr0.25deg_rst_20200130-20200228.nc

echo "done"
