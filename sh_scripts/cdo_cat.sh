#!/bin/bash
#SBATCH --job-name=cat
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=04:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_cat%j.eo
#SBATCH --error=err_cat%j.eo

set -evx # verbose messages and crash message

TWP="/work/bb1153/b380883/TWP"
GT="/work/bb1153/b380883/GT"
scr="/scratch/b/b380883"

# cdo -cat $scr/TWP_3D_cl_1hr_GEOS* $TWP/TWP_3D_GEOS_cl_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_cli_1hr_GEOS* $TWP/TWP_3D_GEOS_cli_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_clw_1hr_GEOS* $TWP/TWP_3D_GEOS_clw_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_hus_1hr_GEOS* $TWP/TWP_3D_GEOS_hus_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_rainmxrat_1hr_GEOS* $TWP/TWP_3D_GEOS_rainmxrat_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_snowmxrat_1hr_GEOS* $TWP/TWP_3D_GEOS_snowmxrat_20200130-20200228.nc
# cdo -cat $scr/TWP_3D_ta_1hr_GEOS* $TWP/TWP_3D_GEOS_ta_20200130-20200228.nc

# cdo -cat $scr/TWP_3D_zg_1hr_GEOS-3km_DW-ATM_r1i1p1f1_ml_gn_* $TWP/TWP_3D_GEOS_zg_20200130-20200228.nc
# cdo -cat $scr/GT_rlut_15min_NICAM-3km_DW-ATM_r1i1p1f1_2d_gn_* $GT/GT_NICAM_rlut_20200130-20200228.nc

# cdo -cat $scr/snowmxrat_3hr_NICAM-3km* $TWP/TWP_3D_NICAM_snowmxrat_20200130-20200228.nc
# cdo -cat $scr/grplmxrat_3hr_NICAM-3km* $TWP/TWP_3D_NICAM_grplmxrat_20200130-20200228.nc

# cdo -cat $scr/ne30pg2_ne1024pg2/TWP/TWP_* $TWP/TWP_SCREAM_rsdt_20200130-20200228.nc
# cdo -cat $scr/ne30pg2_ne1024pg2/GT/GT_* $TWP/GT_SCREAM_rsdt_20200130-20200228.nc
# cdo -cat $scr/ne30pg2_ne1024pg2/*.nc $scr/gn_SCREAM_rsdt_20200130-20200228.nc

cdo -cat $scr/TWP_clh_15min_ARPEGE* $TWP/TWP_ARP_clh_20200130-20200228.nc
cdo -cat $scr/TWP_clivi_15min_ARPEGE* $TWP/TWP_ARP_clivi_20200130-20200228.nc
cdo -cat $scr/TWP_clt_15min_ARPEGE* $TWP/TWP_ARP_clt_20200130-20200228.nc
cdo -cat $scr/TWP_clwvi_15min_ARPEGE* $TWP/TWP_ARP_clwvi_20200130-20200228.nc
cdo -cat $scr/TWP_prw_15min_ARPEGE* $TWP/TWP_ARP_prw_20200130-20200228.nc
cdo -cat $scr/GT_clh_15min_ARPEGE $GT/GT_ARP_clh_20200130-20200228.nc
cdo -cat $scr/GT_clt_15min_ARPEGE $GT/GT_ARP_clt_20200130-20200228.nc
cdo -cat $scr/GT_rlt_15min_ARPEGE $GT/GT_ARP_rlt_20200130-20200228.nc





echo "done"
