#!/bin/bash
#SBATCH --job-name=iwphist
#SBATCH --partition=shared
#SBATCH --mem=40GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out.eo
#SBATCH --error=err_iwphist%j.eo

set -evx # verbose messages and crash message
twp=/work/bb1153/b380883/TWP
gt=/work/bb1153/b380883/GT
scr=/scratch/b/b380883

###### --- get native grid iwp histograms from GT --- 
LON0=0
LON1=360
LAT0=-30
LAT1=30
LOC="GT"
MODEL="GE"

IN_PATH=/work/ka1081/DYAMOND_WINTER
SCR=/scratch/b/b380883

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

declare -a DateArray=(130 131 201 202 203 204 205 206)
# declare -a DateArray=(207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228)
bins=0.0000001,0.000000188739182,0.000000356224789,0.000000672335754,0.00000126896100,0.00000239502662,0.00000452035366,0.0000085316785,0.0000161026203,0.0000303919538,0.0000573615251,0.000108263673,0.000204335972,0.000385662042,0.000727895384,0.00137382380,0.00259294380,0.00489390092,0.00923670857,0.0174332882,0.0329034456,0.0621016942,0.117210230,0.221221629,0.417531894,0.788046282,1.48735211,2.80721620,5.29831691,10
# 2D vars
echo "2D running..."
for d in "${DateArray[@]}"; do
    if [ $MODEL = 'SA' ] ; then
        echo "SAM - no grid file needed"
        declare -a VarArray=(clivi qgvi qsvi)
        for v in "${VarArray[@]}"; do
            for f in $IN_PATH/$IN_SA/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                fname=$(basename $f)
                echo "    $v $d"
                cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $SCR/${LOC}_${MODEL}_${v}_temp.nc
            done
        done
        out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
        echo "    ... add together and do histcount then fldsum $out_file"
        cdo -setname,iwp -fldsum -histcount,$bins -add -add $SCR/${LOC}_${MODEL}_clivi_temp.nc $SCR/${LOC}_${MODEL}_qgvi_temp.nc $SCR/${LOC}_${MODEL}_qsvi_temp.nc $out_file
    elif [ $MODEL = 'GE' ] ; then
        echo "GEOS - no grid file needed"
        for f in $IN_PATH/$IN_GE/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/*_20200$d*; do
            echo "    clivi $d"
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -setname,iwp -fldsum -histcount,$bins -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
        done
    elif [ $MODEL = 'UM' ]; then
        echo "UM - no grid file needed"
        for f in $IN_PATH/$IN_UM/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/*_20200$d*; do
            echo "    clivi $d"
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -setname,iwp -fldsum -histcount,$bins -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 $f $out_file
        done
    elif [ $MODEL = 'IC' ]; then
        echo "ICON"
        declare -a VarArray=(clivi qgvi qsvi)
        for v in "${VarArray[@]}"; do
            for f in $IN_PATH/$IN_IC/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                echo "    $v $d"
                cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IC $f $SCR/${LOC}_${v}_temp_${MODEL}.nc
            done
        done
        out_file=$SCR/${LOC}_iwp_hist_20200${d}.nc
        echo "    ... add together and do histcount $out_file"
        cdo -setname,iwp -histcount,$bins -add -add $SCR/${LOC}_clivi_temp_${MODEL}.nc $SCR/${LOC}_qgvi_temp${MODEL}.nc $SCR/${LOC}_qsvi_temp${MODEL}.nc $out_file
    elif [ $MODEL = 'SC' ]; then
        echo "SCREAM"
        for f in $IN_PATH/$IN_SC/DW-ATM/atmos/15min/clivi/r1i1p1f1/2d/gn/*_20200$d*; do
            echo "    clivi $d"
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -setname,iwp -histcount,$bins -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_SC $f $out_file
        done
    elif [ $MODEL = 'AR' ]; then
        echo "ARP"
        declare -a VarArray=(clivi qgvi qsvi)
        for v in "${VarArray[@]}"; do
            for f in $IN_PATH/$IN_AR/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
                echo "    $v $d"
                cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_AR $f $SCR/${LOC}_${MODEL}_${v}_temp.nc
            done
        done
        out_file=$SCR/${LOC}_iwp_hist_20200${d}.nc
        echo "   ...add together and do histcout $out_file"
        cdo -setname,iwp -histcount,$bins -add -add $SCR/${LOC}_${MODEL}_clivi_temp.nc $SCR/${LOC}_${MODEL}_qgvi_temp.nc $SCR/${LOC}_${MODEL}_qsvi_temp.nc $out_file
    elif [ $MODEL = 'SH' ]; then
        echo "SHiELD"
        for f in $IN_PATH/$IN_SH/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do # ml/2d
            fname=$(basename $f)
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgridtype,unstructured -setgrid,$GRID_SH $f $out_file
        done
    elif [ $MODEL = 'IF' ]; then
        echo "IFS"
        for f in $IN_PATH/$IN_IF/DW-CPL/atmos/1hr/$v/r1i1p1f1/2d/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_IF $f $out_file
        done
    elif [ $MODEL = 'MP' ]; then
        echo "MPAS"
        for f in $IN_PATH/$IN_MP/DW-ATM/atmos/15min/$v/r1i1p1f1/2d/gn/*_20200$d*; do
            fname=$(basename $f)
            out_file=$SCR/${LOC}_${MODEL}_iwp_hist_20200${d}.nc
            cdo -f nc -sellonlatbox,$LON0,$LON1,$LAT0,$LAT1 -setgrid,$GRID_MP $f $out_file
        done
    else
        echo "model not defined "$MODEL
    fi
done




echo "done"
