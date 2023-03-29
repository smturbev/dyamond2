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

twp="/work/bb1153/b380883/TWP"
gt="/work/bb1153/b380883/GT"
scr="/scratch/b/b380883"

#cdo -cat $scr/TWP_ts_15min_SCREAM*.nc $twp/TWP_SCREAM_ts_20200130-202002287.nc
#cdo -cat $scr/TWP_ts_15min_ICON*.nc $twp/TWP_ICON_ts_20200130-202002287.nc
#cdo -cat $scr/TWP_ts_15min_ARP*.nc $twp/TWP_ARP_ts_20200130-202002287.nc
#cdo -cat $scr/TWP_ts_15min_SHiELD*.nc $twp/TWP_SHiELD_ts_20200130-202002287.nc
#cdo -setname,ts -cat $scr/TWP_tsl_15min_UM*.nc $twp/TWP_UM_ts_20200130-202002287.nc
#cdo -cat $scr/TWP_ts_15min_GEOS*.nc $twp/TWP_GEOS_ts_20200130-202002287.nc
# cdo -cat $scr/TWP_ts_15min_gSAM*.nc $twp/TWP_SAM_ts_20200130-20200228.nc
cdo -cat $scr/TWP_rlt_15min_ARP*.nc $twp/TWP_ARP_rlt_20200130-20200228.nc
cdo -cat $scr/TWP_rst_15min_ARP*.nc $twp/TWP_ARP_rst_20200130-20200228.nc

# cdo -cat $scr/r1deg_GT_pracc_15min_ICON*.nc $gt/GT_ICONr1deg_pracc_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pracc_15min_gSAM*.nc $gt/GT_SAMr1deg_pracc_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pr_15min_SCREAM*.nc $gt/GT_SCREAMr1deg_pr_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pr_15min_GEOS*.nc $gt/GT_GEOSr1deg_pr_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_prc_15min_GEOS*.nc $gt/GT_GEOSr1deg_prc_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pr_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_pr_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pr_15min_ARP*.nc $gt/GT_ARPr1deg_pr_20200120-20200228.nc
# cdo -cat $scr/r1deg_GT_pr_15min_UM*.nc $gt/GT_UMr1deg_pr_20200120-20200228.nc

# cdo -cat $scr/r1deg_GT_clt_15min_ARP*.nc $gt/GT_ARPr1deg_clt_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clh_15min_ARP*.nc $gt/GT_ARPr1deg_clh_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clt_15min_gSAM*.nc $gt/GT_SAMr1deg_clt_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clt_15min_ICON*.nc $gt/GT_ICONr1deg_clt_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clt_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_clt_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clh_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_clh_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clt_15min_UM*.nc $gt/GT_UMr1deg_clt_20200130-20200228.nc

# cdo -cat $scr/TWP_clivi_15min_SHiELD*.nc $twp/TWP_SHiELD_clivi_20200130-20200228.nc
# cdo -cat $scr/TWP_area_15min_SCREAM*.nc $twp/TWP_SCREAM_area_20200130-20200228.nc
# cdo -cat $scr/fldmean_global_ta*.nc /work/bb1153/b380883/fldmean_global_ta_20200120-20200229.nc
# cdo -timmean /work/bb1153/b380883/fldmean_global_ta_20200120-20200229.nc /work/bb1153/b380883/timmean_fldmean_global_ta_20200120-20200229.nc

echo "done" 
