#!/bin/bash
#SBATCH --job-name=gt_sa_cldfrac
#SBATCH --partition=shared
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
# module load cdo
# cdo -V

LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"

IN_PATH=/work/ka1081/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883
TWP=/work/bb1153/b380883/TWP

# MODEL_PATH=LLNL/SCREAM-3km
# MODEL_PATH=NASA/GEOS-3km
# MODEL_PATH=METEOFR/ARPEGE-NH-2km
# MODEL_PATH=MPIM-DWD-DKRZ/ICON-NWP-2km
# MODEL_PATH=NOAA/SHiELD-3km
# MODEL_PATH=SBU/gSAM-4km
# MODEL_PATH=AORI/NICAM-3km
# MODEL_PATH=MetOffice/UM-5km
# MODEL_PATH=NCAR/MPAS-3km
MODEL_PATH=/ECMWF/IFS-4km

GRID_AR=/work/ka1081/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/fx/gn/grid.nc
GRID_SC=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
GRID_IC=/work/ka1081/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc
GRID_SH=/work/ka1081/DYAMOND_WINTER/NOAA/SHiELD-3km/DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_SHiELD-3km_DW-CPL_r1i1p1f1_2d_gn_fx.nc
GRID_IF=/work/ka1081/DYAMOND_WINTER/ECMWF/IFS-4km/DW-CPL/atmos/fx/gn/ifs-4km-grid.nc
GRID_MP=/work/ka1081/DYAMOND_WINTER/NCAR/MPAS-3km/DW-ATM/atmos/fx/gn/grid.nc
CON_SH=/home/b/b380883/dyamond2/sh_scripts/REMAP_SHiELD.txt

echo $GRID_AR

## clear sky TOA radiation
## SCREAM (rltcs, rstcs); GEOS (rlutcs, rlutcsna, rsutcs, rstcs); IFS (rltcsacc, rstcsacc);
## NICAM (N/A); ARP (N/A); UM (N/A); ICON (N/A); MPAS (N/A); SHiELD (N/A); SAM (N/A); GEMS (N/A); GRIST (N/A)

declare -a VarArray15min=(qsvi) # clivi
declare -a DateArray=(13 20 21 22)

# cdo -sellonlatbox,143,153,-5,5 -remapcon,r360x180 -setgrid,$GRID_SHi -selgrid,1 /work/ka1081/DYAMOND_WINTER/NOAA/SHiELD-3km/DW-ATM/atmos/15min/rlut/r1i1p1f1/pl/gn/rlut_15min_SHiELD-3km_DW-ATM_r1i1p1f1_pl_gn_20200222001500-20200223000000.nc /work/bb1153/b380883/TWP/SHiELD_remapcon_testr1deg.nc


# ## 15 min vars
# for v in "${VarArray15min[@]}"; do
#     for d in "${DateArray[@]}"; do
#         # for f in $IN_PATH/$MODEL_PATH/DW-CPL/atmos/1hr/$v/r1i1p1f1/2d/gn/*_20200$d*; do #for SHiELD 2d -> pl
#         for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do # for 3D
#             fname=$(basename $f)
#             out_file=$OUT_PATH/${LOC}_$fname
#             echo "15 min variable "$v":"
#             ## SCREAM: rst rlt (rsdt separately)
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_SC -selgrid,1 $f $out_file
#             ## GEOS, NICAM, SAM, UM
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 $f $out_file
#             # cdo -f nc4 -P 8 -s -w -fldmean -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_SH -selgrid,1 $f $out_file
#             # # ARP -divc,-900 for rad variables
#             # cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_AR $f $out_file
#             # # ICON
#             # cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_IC -selgrid,1 $f $out_file
#             # # IFS
            cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_IF $f $out_file
#             # # SHiELDs
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_SH -selgrid,1 $f $out_file
#             # # MPAS
#             # cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_MP $f $out_file
#         done
#     done
# done

# M="UM"
# GRID=$GRID_UM

# ## cld fraction of thin vs deep convective cirrus
# for d in "${DateArray[@]}"; do
#     for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/*_20200$d*; do #for SHiELD 2d -> pl
#         fname=$(basename $f)
#         out_ci=$OUT_PATH/${LOC}_lt1e-1gt1e-4_cldfrac_$fname
#         out_dc=$OUT_PATH/${LOC}_geq1_cldfrac_$fname
#         tmp_clivi=$OUT_PATH/temp/tmp_clivi_${M}.nc
#         echo "thin ci vs dc cld frac "$v":"
#         ## SCREAM: rst rlt (rsdt separately)
#         cdo -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $tmp_clivi # -setgrid,$GRID -selgrid,1 
#         cdo -f nc4 -P 8 -s -w -remapcon,r360x180 -timmean -gec,2 -add -gec,1e-4 $tmp_clivi -ltc,1e-1 $tmp_clivi $out_ci
#         rm $tmp_clivi
#         cdo -f nc4 -P 8 -s -w -remapcon,r360x180 -timmean -gec,1 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_dc # -setgrid,$GRID -selgrid,1
#     done
# done

# cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 /work/ka1081/DYAMOND-WINTER/NASA/GEOS-3km/DW-ATM/atmos/fx/sftlf/r1i1p1f1/ml/gn/sftlf_fx_GEOS-3km_DW-ATM_r1i1p1f1_ml_gn_fx.nc /scratch/b/b380883/GEOS_land-fraction_map.nc

## SHiELD 2D
# for v in "${VarArray15min[@]}"; do
#     for d in "${DateArray[@]}"; do
#         for f in $IN_PATH/$MODEL_PATH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do #for SHiELD 2d -> pl
#             fname=$(basename $f)
#             out_file=$OUT_PATH/$LOC"_"$fname
#             echo "SHiELD 15 min variable "$v": "$out_file
#             ## SHiELD
#             # 1deg
#             cdo -f nc4 -P 8 -s -w -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_SH -selgrid,1 $f $out_file
#         done
#     done
# done

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

## 3D vars - ARP
# v="cli"
# for d in "${DateArray[@]}"; do
#     for f in $IN_PATH/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
#         fname=$(basename $f)
#         out_file=$OUT_PATH/$LOC"_14-18km_"$fname
#         echo "3D variable "$v":"
#         cdo -f nc -P 8 -s -w -select,levidx=29/47 -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapdis,global_0.25 -setgrid,$GRID_ARP -selgrid,1 $f $out_file
#     done
# done

### SOLIN ### from ben hillman
# cdo -remapdis,r3600x1800 -setgrid,$GRID_SCR -selgrid,1 /work/bb1153/b380883/gn_SCREAM_SOLIN_20200130-20200228.nc /work/bb1153/b380883/gn_SCREAMr0.1deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,143,153,-5,5 /work/bb1153/b380883/gn_SCREAMr0.1deg_rsdt_20200130-20200228.nc /work/bb1153/b380883/TWP/TWP_SCREAMr0.1deg_rsdt_20200130-20200228.nc
# cdo -sellonlatbox,0,360,-30,30 /scratch/b/b380883/gn_SCREAM0.25deg_rsdt_20200130-20200228.nc /scratch/b/b380883/GT_SCREAMr0.25deg_rsdt_20200130-20200228.nc

## ARP needs to be divided by 900 in rad vars
# cdo -divc,-900 $TWP/TWP_ARPr0.1deg_rlt900_20200130-20200228.nc TWP_ARPr0.1deg_rlt_20200130-20200228.nc
# cdo -divc,900 $TWP/TWP_ARPr0.1deg_rst900_20200130-20200228.nc TWP_ARPr0.1deg_rst_20200130-20200228.nc

## SCREAM 0.1 to 1 deg GT
# new_grid="GRID_GT_SCREAM.txt"
# cdo -remapcon,$new_grid -setgrid,$GRID_SCR /work/bb1153/b380883/GT/GT_SCREAMr0.1deg_clh_20200130-20200228.nc /work/bb1153/b380883/GT/GT_SCREAMr1deg_clh_20200130-20200228.nc
# cdo -remapcon,$new_grid -setgrid,$GRID_SCR /work/bb1153/b380883/GT/GT_SCREAMr0.1deg_clt_20200130-20200228.nc /work/bb1153/b380883/GT/GT_SCREAMr1deg_clt_20200130-20200228.nc

## GEOS native to 1 deg GT
# new_grid="REMAP_GEOS_GT.txt"
# cdo -remapcon,$new_grid /work/bb1153/b380883/GT/GT_GEOS_rsut_20200130-20200228.nc /work/bb1153/b380883/GT/GT_GEOSr1deg_rsut_20200130-20200228.nc

# cdo -remapcon,GRID_GT_SCREAM.txt $GT/GT_UM_rlut_20200130-20200228.nc $GT/GT_UMr1deg_rlut_20200130-20200228.nc

echo "done"
