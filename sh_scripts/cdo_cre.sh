#!/bin/bash
#SBATCH --job-name=cdo_cre
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=08:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cre%j.eo
#SBATCH --error=err_cre%j.eo

LWCRE=true
SWCRE=true
MODEL='SC'

set -evx # verbose messages and crash message
scr="/scratch/b/b380883/"
twp="/work/bb1153/b380883/TWP"
sol_in=413.2335274324269 # for TWP and NAU (from python: from climlab.solar.insolation import daily_insolation)


########################################
#    calculate cloud rad. effect       #
########################################
GRID_AR=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/METEOFR/ARPEGE-NH-2km/DW-ATM/atmos/fx/grid/r1i1p1f1/2d/gn/grid_fx_ARPEGE-NH-2km_DW-CPL_r1i1p1f1_2d_gn_fx.nc
GRID_SC=/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/LLNL/SCREAM-3km/grid.nc

declare -a DateArray=(13 20 21 22)
echo "2D running..."

if $MODEL = 'GE' ] ; then
    echo "GEOS"
    if $LWCRE ; then
        olr_cs=$twp/TWP_GEOS_rlutcs_20200130-20200228.nc
        olr=$twp/TWP_GEOS_rlut_20200130-20200228.nc
        out=$twp/TWP_GEOS_lwcre_20200130-20200228.nc
        cdo -sub $olr_cs $olr $out
    fi
    if $SWCRE ; then
        swu_cs=$twp/TWP_GEOS_rsutcs_20200130-20200228.nc
        swu=$twp/TWP_GEOS_rsut_20200130-20200228.nc
        swd=$twp/TWP_GEOS_rsdt_20200130-20200228.nc
        out=$twp/TWP_GEOS_swcre_20200130-20200228.nc
        cdo -mulc,$sol_in -div -sub $swu_cs $swu $swd $out
    fi
elif [ $MODEL = 'SC' ]; then
    echo "SCREAM"
    if $LWCRE ; then
        olr_cs=$twp/TWP_SCREAM_rltcs_20200130-20200228.nc
        olr=$twp/TWP_SCREAM_rlt_20200130-20200228.nc
        out=$twp/TWP_SCREAM_lwcre_20200130-20200228.nc
        cdo -sub $olr_cs $olr $out
    fi
    if $SWCRE ; then
        swn_cs=$twp/TWP_SCREAM_rstcs_20200130-20200228.nc
        swn=$twp/TWP_SCREAM_rst_20200130-20200228.nc
        swd=$twp/TWP_SCREAM_rsdt_20200130-20200228.nc
        out=$twp/TWP_SCREAM_swcre_20200130-20200228.nc
        cdo -mulc,$sol_in -div -sub $swn $swn_cs $swd $out
    fi
elif [ $MODEL = 'IF' ]; then
    echo "IF"
    if $LWCRE ; then
        olr_cs=$twp/TWP_ARP_rltcs_20200130-20200228.nc
        olr=$twp/TWP_ARP_rlt_20200130-20200228.nc
        out=$twp/TWP_ARP_lwcre_20200130-20200228.nc
        cdo -sub $olr_cs $olr $out
    fi
    if $SWCRE ; then
        swn_cs=$twp/TWP_ARP_rstcs_20200130-20200228.nc
        swn=$twp/TWP_ARP_rst_20200130-20200228.nc
        swd=$twp/TWP_ARP_rsdt_20200130-20200228.nc
        out=$twp/TWP_ARP_swcre_20200130-20200228.nc
        cdo -mulc,$sol_in -div -sub $swn $swn_cs $swd $out
    fi
else
    echo "model not defined "$MODEL
fi
