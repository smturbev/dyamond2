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
scr=/scratch/b/b380883

declare ModelArray=("SAM") #"SCREAM" "UM" "SHiELD" "ARP" "ICON" "GEOS" "SAM"
for MODEL in "${ModelArray[@]}"; do
    echo $MODEL
    cdo -fldmean $twp/TWP_3D_${MODEL}_iwc_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_${MODEL}_iwc_20200130-20200228.nc
    cdo -setname,cl -setattribute,long_name="cld frac >= 5e-7kgm-3" -fldmean -gec,5e-7 $twp/TWP_3D_${MODEL}_iwc_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_${MODEL}_cl_iwc_5e-7kgm-3_20200130-20200228.nc
done


# cdo -fldmean $twp/TWP_3D_GEOS_cltotal_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_GEOS_clto_20200130-20200228.nc
# cdo -setname,cl -setattribute,long_name="cld frac >= 5e-7kgm-3" -fldmean -gec,5e-7 $twp/TWP_3D_GEOS_totalwater_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_GEOS_cl_5e-7kgm-3_20200130-20200228.nc
### cumulative accumulated precipitation over 40 days
# cdo -fldmean -selvar,precipitation $scr/GPM_3IMERG_precip_20200120-20200228.nc $gt/fldmean/fldmean_GT_GPM-IMERG_pr_20200120-20200228.nc
# cdo -timmean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $scr/GPM_3IMERG_precip_20200120-20200228.nc $gt/timmean/timmean_GT_GPM-IMERG_precipitation_20200130-20200228.nc

# cdo -setname,pracc -seldate,2020-02-28T23:45:00 -timcumsum $gt/GT_ARPr1deg_pr_20200120-20200228.nc $gt/timmean/timcumsum_GT_ARPr1deg_pracc_20200228T234500.nc
# cdo -setname,pracc -mulc,900 -seldate,2020-02-28T23:45:00 -timcumsum $gt/GT_GEOSr1deg_pr_20200120-20200228.nc $gt/timmean/timcumsum_GT_GEOSr1deg_pracc_20200228T234500.nc
# cdo -setname,pracc -mulc,900000 -seldate,2020-02-28T23:45:00 -timcumsum $gt/GT_SCREAMr1deg_pr_20200120-20200228.nc $gt/timmean/timcumsum_GT_SCREAMr1deg_pracc_20200228T234500.nc
# cdo -setname,pracc -mulc,900 -seldate,2020-02-28T23:45:00 -timcumsum $gt/GT_SHiELDr1deg_pr_20200120-20200228.nc $gt/timmean/timcumsum_GT_SHiELDr1deg_pracc_20200228T234500.nc
# cdo -setname,pracc -mulc,900 -seldate,2020-02-28T23:52:30 -timcumsum $gt/GT_UMr1deg_pr_20200120-20200228.nc $gt/timmean/timcumsum_GT_UMr1deg_pracc_20200228T234500.nc
# cdo -seldate,2020-02-28T23:45:00 $gt/GT_ICONr1deg_pracc_20200120-20200228.nc $gt/timmean/timcumsum_GT_ICONr1deg_pracc_20200228T234500.nc
# cdo -divc,3600 -seldate,2020-02-28T23:45:00 -timcumsum $gt/GT_SAMr1deg_pracc_20200120-20200228.nc $gt/timmean/timcumsum_GT_SAMr1deg_pracc_20200228T234500.nc

# cdo -setname,pr -setunit,"kg m-2 s-1" -divc,900 -deltat $gt/GT_ICONr1deg_pracc_20200120-20200228.nc $gt/GT_ICONr1deg_pr_20200120-20200228.nc
# cdo -setname,pr -setunit,"mm s-1" -divc,900 -deltat $gt/GT_SAMr1deg_pracc_20200120-20200228.nc $gt/GT_SAMr1deg_pr_20200120-20200228.nc

### timmean or daymean of precip rate over last 30 days 
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_ARPr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_ARPr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_GEOSr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_GEOSr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_ICONr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_ICONr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_SAMr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_SAMr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_SCREAMr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_SCREAMr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_SHiELDr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_SHiELDr1deg_pr_20200130-20200228.nc
# cdo -daymean -seldate,2020-01-30T00:00:00,2020-02-28T23:59:00 $gt/GT_UMr1deg_pr_20200120-20200228.nc $gt/timmean/daymean_GT_UMr1deg_pr_20200130-20200228.nc

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
