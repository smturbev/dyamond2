#!/bin/bash
#SBATCH --job-name=mp_rlt
#SBATCH --partition=shared
#SBATCH --time=08:00:00
#SBATCH --mem=100GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_twp%j.eo
#SBATCH --output=out_twp%j.eo

set -evx # verbose messages and crash message

LON0=143
LON1=153
LAT0=-5
LAT1=5
LOC="TWP"
MODEL="MP"
dim_2D=true
dim_3D=false

IN_PATH=/work/ka1081/DYAMOND_WINTER
OUT_PATH=/scratch/b/b380883

IN_GE=NASA/GEOS-3km
IN_AR=METEOFR/ARPEGE-NH-2km
IN_UM=MetOffice/UM-5km
IN_SC=LLNL/SCREAM-3km
IN_SH=NOAA/SHiELD-3km
IN_IC=MPIM-DWD-DKRZ/ICON-NWP-2km
IN_SA=SBU/gSAM-4km
IN_NI=AORI/NICAM-3km
IN_IF=ECMWF/IFS-4km
IN_MP=NCAR/MPAS-3km
IN_EC=NextGEMS/ECMWF-AWI
IN_GR=CAMS/GRIST-5km
IN_GM=CMC/GEM

GRID_IC=/work/ka1081/DYAMOND_WINTER/MPIM-DWD-DKRZ/ICON-NWP-2km/DW-ATM/atmos/fx/gn/grid.nc
GRID_SC=/work/ka1081/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc
GRID_AR=/work/ka1081/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/fx/gn/grid.nc
GRID_SH=/work/ka1081/DYAMOND_WINTER/NOAA/SHiELD-3km/DW-ATM/atmos/fx/gn/grid.nc
GRID_GM=/work/ka1081/DYAMOND_WINTER/CMC/GEM/DW-ATM/atmos/fx/gn/grid.nc
GRID_IF=/work/ka1081/DYAMOND_WINTER/ECMWF/IFS-4km/DW-CPL/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_IFS-4km_DW-CPL_r1i1p1f1_2d_gn_fx.nc
GRID_MP=/work/ka1081/DYAMOND_WINTER/NCAR/MPAS-3km/DW-ATM/atmos/fx/gn/grid.nc

declare -a VarArray15min=(rltacc) #qsvi qrvi clwvi #rlt rst
declare -a DateArray=(13 20 21 22)
if $dim_2D ; then
    # 2D vars
    echo "2D running..."
    for v in "${VarArray15min[@]}"; do
        for d in "${DateArray[@]}"; do
            if [ $MODEL = 'SA' ] ; then
                echo "no grid file needed"
                for f in $IN_PATH/$IN_SA/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'NI' ] ; then
                echo "no grid file needed"
                for f in $IN_PATH/$IN_NI/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'GE' ] ; then
                echo "no grid file needed"
                for f in $IN_PATH/$IN_GE/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'UM' ]; then
                echo "no grid file needed"
                for f in $IN_PATH/$IN_UM/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'IC' ]; then
                echo "ICON"
                for f in $IN_PATH/$IN_IC/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IC $f $out_file
                done
            elif [ $MODEL = 'SC' ]; then
                echo "SCREAM"
                for f in $IN_PATH/$IN_SC/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_SC $f $out_file
                done
            elif [ $MODEL = 'AR' ]; then
                echo "ARP"
                for f in $IN_PATH/$IN_AR/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_AR $f $out_file
                done
            elif [ $MODEL = 'SH' ]; then
                echo "SHiELD"
                for f in $IN_PATH/$IN_SH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do # ml/2d
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgridtype,unstructured -setgrid,$GRID_SH $f $out_file
                done
            elif [ $MODEL = 'GR' ]; then
                echo "GRIST"
                for f in $IN_PATH/$IN_GR/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'GM' ]; then
                echo "CMC/GEM"
                for f in $IN_PATH/$IN_GM/DW-ATM/atmos/1hr/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_GM $f $out_file
                done
            elif [ $MODEL = 'IF' ]; then
                echo "IFS"
                for f in $IN_PATH/$IN_IF/DW-CPL/atmos/1hr/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IF $f $out_file
                done
            elif [ $MODEL = 'MP' ]; then
                echo "MPAS"
                for f in $IN_PATH/$IN_MP/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_MP $f $out_file
                done
            else
                echo "model not defined "$MODEL
            fi
        done
    done
fi

declare -a VarArray3D=(pthick)
declare -a DateArray=(219)

# 3D vars
if $dim_3D ; then
    echo "3D running..."
    for v in "${VarArray3D[@]}"; do
        for d in "${DateArray[@]}"; do
            if [ $MODEL = 'SA' ] ; then
                # cli  clw  hus  ta  ua  va  wa #height=z
                echo "no grid file needed and 3 hourly"
                for f in $IN_PATH/$IN_SA/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'UM' ]; then
                # cli  clw  hus  ta  ua  va  wa #height=lev
                echo "no grid file needed and 3 hourly"
                for f in $IN_PATH/$IN_UM/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'NI' ]; then
                echo "NICAM"
                #cli  clw  grplmxrat  hus  pfull  rainmxrat  snowmxrat  ta  ua  va  wa
                for f in $IN_PATH/$IN_NI/DW-ATM/atmos/3hr/$v/r1i1p1f1/zl/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'GE' ]; then
                echo "GEOS 1 hourly"
                # cl, clw, hus,  rainmxrat, reffclw, ta, va, wap, cli, grplmxrat, pthick, reffcli, snowmxrat, ua, wa, zg
                for f in $IN_PATH/$IN_GE/DW-ATM/atmos/1hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
                done
            elif [ $MODEL = 'IC' ]; then
                echo "ICON"
                # cli  clw  hus  pa  ta  ua  va  wa
                for f in $IN_PATH/$IN_IC/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IC $f $out_file
                done
            elif [ $MODEL = 'SC' ]; then
                echo "SCREAM"
                # area, cl, cli, cl-mod, clw, co2vmr, datesec, dtau, f12vmr, icenvi, lon, ndcur, nsteph, psl, ta, va
                # ch4vmr, cldnvi, clifrac, clt, clwfrac, date, dem, f11vmr,  hus, lat, n2ovmr, nscur, ps, rainnvi, ua, wap
                for f in $IN_PATH/$IN_SC/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_SC $f $out_file
                done
            elif [ $MODEL = 'AR' ]; then
                echo "ARP"
                # cli  clw  hus  pa  ta  ua  va  wa
                for f in $IN_PATH/$IN_AR/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_AR $f $out_file
                done
            elif [ $MODEL = 'SH' ]; then
                echo "SHiELD"
                for f in $IN_PATH/$IN_SH/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                    fname=$(basename $f)
                    out_file=$OUT_PATH/${LOC}_$fname
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgridtype,unstructured -setgrid,$GRID_SH $f $out_file
                done
            else 
                echo "check model "$MODEL
            fi
        done
    done
fi

# f=/work/ka1081/DYAMOND_WINTER/NOAA/SHiELD-3km/DW-ATM/atmos/3hr/cli/r1i1p1f1/ml/gn/cli_3hr_SHiELD-3km_DW-ATM_r1i1p1f1_ml_gn_20200225030000-20200226000000.nc
# out_file=/scratch/b/b380883/cli_3hr_SHiELD-3km_DW-ATM_r1i1p1f1_ml_gn_20200225030000-20200226000000.nc
# cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgridtype,unstructured -setgrid,$GRID_SH $f $out_file
echo "done"
