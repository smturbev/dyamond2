#!/bin/bash
#SBATCH --job-name=fldmean
#SBATCH --partition=shared
#SBATCH --mem=10GB
#SBATCH --time=02:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_fldmean%j.eo
#SBATCH --error=err_fldmean%j.eo

set -evx # verbose messages and crash message
twp=/work/bb1153/b380883/TWP
gt=/work/bb1153/b380883/GT

cdo -fldmean $gt/GT_ARPr1deg_pr_20200120-20200228.nc $gt/fldmean/fldmean_GT_ARP_pr_20200130-20200301.nc
cdo -fldmean $gt/GT_GEOSr1deg_pr_20200120-20200228.nc $gt/fldmean/fldmean_GT_GEOS_pr_20200130-20200301.nc
cdo -fldmean $gt/GT_ICONr1deg_pracc_20200120-20200228.nc $gt/fldmean/fldmean_GT_ICON_pracc_20200130-20200301.nc
cdo -fldmean $gt/GT_SHiELDr1deg_pr_20200120-20200228.nc $gt/fldmean/fldmean_GT_SHiELD_pr_20200130-20200301.nc
# cdo -mermean $gt/GT_ARPr1deg_rlt_20200130-20200228.nc $gt/fldmean/mermean_GT_ARPr1deg_rlt_20200130-20200228.nc
# cdo -mermean $gt/GT_GEOSr1deg_rlut_20200130-20200228.nc $gt/fldmean/mermean_GT_GEOSr1deg_rlut_20200130-20200228.nc
# cdo -mermean $gt/GT_ICONr1deg_rlt_20200130-20200228.nc $gt/fldmean/mermean_GT_ICONr1deg_rlt_20200130-20200228.nc
# cdo -mermean $gt/GT_SAMr1deg_rlt_20200130-20200228.nc $gt/fldmean/mermean_GT_SAMr1deg_rlt_20200130-20200228.nc
# cdo -mermean $gt/GT_SCREAMr1deg_rlt_20200130-20200228.nc $gt/fldmean/mermean_GT_SCREAMr1deg_rlt_20200130-20200228.nc
# cdo -mermean $gt/GT_SHiELDr1deg_rlut_20200130-20200228.nc $gt/fldmean/mermean_GT_SHiELDr1deg_rlut_20200130-20200228.nc
# cdo -mermean $gt/GT_UM_rlut_20200130-20200228.nc $gt/fldmean/mermean_GT_UM_rlut_20200130-20200228.nc
# cdo -mermean $gt/GT_CERES_rad_toa_1hm_JFM.nc $gt/fldmean/mermean_GT_CERES_rad_toa_1hm_JFM.nc

# declare -a DateArray=(15 16 17 18 19 2)
## SAM global mean temperature
# for d in "${DateArray[@]}"; do 
# for f in /work/ka1081/DYAMOND_WINTER/SBU/gSAM-4km/DW-ATM/atmos/3hr/ta/r1i1p1f1/ml/gn/*202002$d*; do
#     fname=$(basename $f)
#     out_file=/scratch/b/b380883/fldmean_global_ta_$fname
#     cdo -f nc -fldmean $f $out_file
# done
# done

echo "done"
