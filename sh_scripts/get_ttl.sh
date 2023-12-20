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

###### USER SETTINGS #####
LOC="GT"
MODEL="AR"
REMAP=true

##### DONT ADJUST BELOW #####

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

if [ $LOC = 'GT' ] ; then
   LON0 = 0
   LON1 = 360
   LAT0 = -30
   LAT1 = 30
elif [ $LOC = 'TWP' ] ; then
   LON0 = 143
   LON1 = 153
   LAT0 = -5
   LAT1 = 5
fi

#### select 14-18km levels ######
##### variable 
declare -a VarArray3D=(cli)
declare -a DateArray=(13 20 21 22)

# 3D vars
echo "3D TTL running..."
for v in "${VarArray3D[@]}"; do
    for d in "${DateArray[@]}"; do
        if [ $MODEL = 'SA' ] ; then
            # cli  clw  hus  ta  ua  va  wa #height=z
            echo "no grid file needed and 3 hourly"
            for f in $IN_PATH/$IN_SA/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=49/57 -remapcon,r360x180 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=49/57 $f $out_file
                fi
            done
        elif [ $MODEL = 'UM' ]; then
            # cli  clw  hus  ta  ua  va  wa #height=lev
            echo "no grid file needed and 3 hourly"
            for f in $IN_PATH/$IN_UM/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -select,levidx=42/49 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=42/49 $f $out_file
                fi
            done
        elif [ $MODEL = 'NI' ]; then
            echo "NICAM is gone-zo"
            #cli  clw  grplmxrat  hus  pfull  rainmxrat  snowmxrat  ta  ua  va  wa
            # for f in $IN_PATH/$IN_NI/DW-ATM/atmos/3hr/$v/r1i1p1f1/zl/gn/*_20200$d*; do
            #     fname=$(basename $f)
            #     out_file=$OUT_PATH/${LOC}_$fname
            #     cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=44/56 $f $out_file
            # done
        elif [ $MODEL = 'GE' ]; then
            echo "GEOS 1 hourly"
            # cl, clw, hus,  rainmxrat, reffclw, ta, va, wap, cli, grplmxrat, pthick, reffcli, snowmxrat, ua, wa, zg
            for f in $IN_PATH/$IN_GE/DW-ATM/atmos/1hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -select,levidx=86/103 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -select,levidx=86/103 $f $out_file
                fi
            done
        elif [ $MODEL = 'IC' ]; then
            echo "ICON"
            # cli  clw  hus  pa  ta  ua  va  wa
            for f in $IN_PATH/$IN_IC/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_IC $f $out_file                
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IC $f $out_file
                fi
            done
        elif [ $MODEL = 'SC' ]; then
            echo "SCREAM"
            # area, cl, cli, cl-mod, clw, co2vmr, datesec, dtau, f12vmr, icenvi, lon, ndcur, nsteph, psl, ta, va
            # ch4vmr, cldnvi, clifrac, clt, clwfrac, date, dem, f11vmr,  hus, lat, n2ovmr, nscur, ps, rainnvi, ua, wap
            for f in $IN_PATH/$IN_SC/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_SC -selgrid,1 -select,levidx=29/47 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_SC -select,levidx=29/47 $f $out_file
                fi
            done
        elif [ $MODEL = 'AR' ]; then
            echo "ARP"
            # cli  clw  hus  pa  ta  ua  va  wa
            for f in $IN_PATH/$IN_AR/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgrid,$GRID_AR -select,levidx=29/47 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_AR -select,levidx=3/11 $f $out_file
                fi
            done
        elif [ $MODEL = 'SH' ]; then
            echo "SHiELD"
            for f in $IN_PATH/$IN_SH/DW-ATM/atmos/3hr/$v/r1i1p1f1/ml/gn/*_20200$d*; do
                fname=$(basename $f)
                out_file=$OUT_PATH/${LOC}_$fname
                if $REMAP ; then
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -remapcon,r360x180 -setgridtype,unstructured -setgrid,$GRID_SH -selgrid,1 -select,levidx=14/22 $f $out_file
                else
                    cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgridtype,unstructured -setgrid,$GRID_SH -select,levidx=14/22 $f $out_file
                fi
            done
        else 
            echo "check model "$MODEL
        fi
    done
done

echo "done"
