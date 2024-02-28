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

# cdo -cat $scr/r1deg_GT_pr_15min_MPAS*.nc $gt/GT_MPAS_pr_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_pracc_1hr_IFS*.nc $gt/GT_IFS_pracc_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_rltacc_1hr_IFS*.nc $gt/GT_IFS_rltacc_20200130-20200228.nc

# cdo -fldmean $gt/GT_MPAS_pr_20200130-20200228.nc $gt/fldmean/fldmean_GT_MPAS_pr_20200130-20200228.nc
cdo -fldmean $gt/GT_IFS_pracc_20200130-20200228.nc $gt/fldmean/fldmean_GT_IFS_pracc_20200130-20200228.nc

# cdo cat $scr/TWP_rstacc_15min_MPAS*.nc $twp/TWP_MPAS_rstacc_20200120-20200228.nc
# cdo -setname,rst -setunit,W/m2 -divc,900 -deltat $twp/TWP_MPAS_rstacc_20200120-20200228.nc $twp/TWP_MPAS_rst_20200120-20200228.nc
# cdo -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $twp/TWP_MPAS_rst_20200120-20200228.nc $twp/TWP_MPAS_rst_20200130-20200228.nc
# cdo cat $scr/TWP_rltacc_15min_MPAS*.nc $twp/TWP_MPAS_rltacc_20200120-20200228.nc
# cdo -setname,rlt -setunit,W/m2 -divc,-900 -deltat $twp/TWP_MPAS_rltacc_20200120-20200228.nc $twp/TWP_MPAS_rlt_20200120-20200228.nc
# cdo -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $twp/TWP_MPAS_rlt_20200120-20200228.nc $twp/TWP_MPAS_rlt_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_rltacc_15min_MPAS*.nc $scr/GT_MPASr1deg_rltacc_20200120-20200228.nc
# cdo -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 -setname,rlt -setunit,W/m2 -divc,900 -deltat $scr/GT_MPASr1deg_rltacc_20200120-20200228.nc $gt/GT_MPASr1deg_rlt_20200130-20200228.nc

#cdo -cat $scr/r1deg_GT_qgvi_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_qgvi_20200130-20200228.nc
#cdo -cat $scr/r1deg_GT_qsvi_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_qsvi_20200130-20200228.nc
#cdo -setname,iwp -add -add $gt/GT_SHiELDr1deg_qgvi_20200130-20200228.nc $gt/GT_SHiELDr1deg_qsvi_20200130-20200228.nc $gt/GT_SHiELDr1deg_clivi_20200130-20200228.nc $gt/GT_SHiELDr1deg_iwp_20200130-20200228.nc

# cdo -cat $scr/r1deg_GT_qgvi_15min_ICON*.nc $gt/GT_ICONr1deg_qgvi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_qsvi_15min_ICON*.nc $gt/GT_ICONr1deg_qsvi_20200130-20200228.nc
# cdo -setname,iwp -add -add $gt/GT_ICONr1deg_qgvi_20200130-20200228.nc $gt/GT_ICONr1deg_qsvi_20200130-20200228.nc $gt/GT_ICONr1deg_clivi_20200130-20200228.nc $gt/GT_ICONr1deg_iwp_20200130-20200228.nc

# cdo -cat $scr/r1deg_GT_qgvi_15min_gSAM*.nc $gt/GT_gSAMr1deg_qgvi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_qsvi_15min_gSAM*.nc $gt/GT_gSAMr1deg_qsvi_20200130-20200228.nc
#cdo -setname,iwp -add -add $gt/GT_SAMr1deg_qgvi_20200130-20200228.nc $gt/GT_SAMr1deg_qsvi_20200130-20200228.nc $gt/GT_SAMr1deg_clivi_20200130-20200228.nc $gt/GT_gSAMr1deg_iwp_20200130-20200228.nc

#cdo -cat $scr/r1deg_GT_qgvi_15min_GEOS*.nc $gt/GT_GEOSr1deg_qgvi_20200130-20200228.nc
#cdo -cat $scr/r1deg_GT_qsvi_15min_GEOS*.nc $gt/GT_GEOSr1deg_qsvi_20200130-20200228.nc
#cdo -setname,iwp -add -add $gt/GT_GEOSr1deg_qgvi_20200130-20200228.nc $gt/GT_GEOSr1deg_qsvi_20200130-20200228.nc $gt/GT_GEOSr1deg_clivi_20200130-20200228.nc $gt/GT_GEOSr1deg_iwp_20200130-20200228.nc

# cdo -cat $scr/r1deg_GT_clivi_15min_ICON*.nc $gt/GT_ICONr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clivi_15min_SHiELD*.nc $gt/GT_SHiELDr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clivi_15min_UM*.nc $gt/GT_UMr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_clivi_15min_gSAM*.nc $gt/GT_SAMr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/TWP_wap_3hr_SCREAM-3km*.nc $twp/TWP_3D_SCREAM_wap_20200130-20200228.nc
# cdo -cat $scr/TWP_wa_3hr_gSAM*.nc $twp/TWP_3D_SAM_wa_20200130-20200228.nc
# cdo -cat $scr/TWP_ps_15min_GEOS*.nc $twp/TWP_GEOS_ps_20200130-20200228.nc
# cdo -cat $scr/TWP_pthick_1hr_GEOS*.nc $twp/TWP_3D_GEOS_pthick_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_fldmean_clivi_15min_SCREAM*.nc $gt/GT_SCREAMr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_fldmean_clivi_15min_GEOS* $gt/GT_GEOSr1deg_clivi_20200130-20200228.nc
# cdo -cat $scr/r1deg_GT_fldmean_clivi_15min_SCREAM*.nc $gt/GT_SCREAM1deg_clivi_20200130-20200228.nc
#cdo -cat $scr/TWP_qsvi_15min_SHiELD*.nc $twp/TWP_SHiELD_qsvi_20200130-20200228.nc
#cdo -cat $scr/TWP_qgvi_15min_SHiELD*.nc $twp/TWP_SHiELD_qgvi_20200130-20200228.nc
#cdo -cat $scr/TWP_qrvi_15min_SHiELD*.nc $twp/TWP_SHiELD_qrvi_20200130-20200228.nc
#cdo -cat $scr/TWP_clwvi_15min_SHiELD*.nc $twp/TWP_SHiELD_clwvi_20200130-20200228.nc
#cdo -setname,iwp -setattribute,long_name="total ice water path = clivi + qsvi + qgvi" -add -add $twp/TWP_SHiELD_qsvi_20200130-20200228.nc $twp/TWP_SHiELD_qgvi_20200130-20200228.nc $twp/TWP_SHiELD_clivi_20200130-20200228.nc $twp/TWP_SHiELD_iwp_20200130-20200228.nc

echo "done" 
