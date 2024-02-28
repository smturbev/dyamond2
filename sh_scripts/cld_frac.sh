#!/bin/bash
#SBATCH --job-name=cld_frac
#SBATCH --partition=compute
#SBATCH --mem=20GB
#SBATCH --time=06:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out.eo
#SBATCH --error=err_cldfrac%j.eo

set -evx # verbose messages and crash message
twp="/work/bb1153/b380883/TWP"
gt="/work/bb1153/b380883/GT"
scr="/scratch/b/b380883"

declare -a ModelArray=(
SHiELD
)

# cdo -vertsum $gt/GT_TTL_SAM_cli_20200130-20200228.nc $gt/GT_TTL_SAM_ttliwp_20200130-20200228.nc

# cloud fraction is 1 where CLI is greater than or equal to 1e-5 kg/kg
for m in "${ModelArray[@]}"; do
    cdo -gec,1e-4 $gt/GT_${m}r1deg_iwp_20200130-20200228.nc $scr/temp/${m}_iwp_gt_1e-4.nc
    # cdo -lec,2e-4 $gt/GT_${m}r1deg_pr_20200130-20200228.nc $scr/temp/${m}_nonprecip_lt_2e-4.nc
    cdo -lec,1e-1 $gt/GT_${m}r1deg_iwp_20200130-20200228.nc $scr/temp/${m}_iwp_lt_1e-1.nc
    # cdo -gtc,2 -add -add $scr/temp/${m}_iwp_lt_1e-1.nc $scr/temp/${m}_iwp_gt_1e-4.nc $scr/temp/${m}_nonprecip_lt_2e-4.nc $scr/temp/${m}_iwp_thin_ci_nonprecip.nc
    cdo -gtc,1 -add $scr/temp/${m}_iwp_lt_1e-1.nc $scr/temp/${m}_iwp_gt_1e-4.nc $scr/temp/${m}_iwp_thin_ci_lt_thick.nc    
    cdo -setname,'thin_ci' -setunit,'frac' -timmean $scr/temp/${m}_iwp_thin_ci_lt_thick.nc $gt/timmean/timmean_GT_${m}r1deg_thin_ci_frac_thick_20200130-20200228.nc
    # cdo -gec,0.75 $gt/GT_${m}r1deg_iwp_20200130-20200228.nc $scr/temp/${m}_iwp_gt_5e-5.nc
    # cdo -setname,'deep_conv' -setunit,'frac' -timmean $scr/temp/${m}_iwp_gt_5e-5.nc $gt/timmean/timmean_GT_${m}r1deg_deep_conv_frac_20200130-20200228.nc
    # cdo -setunit,"frac" -setname,cl -fldmean -gec,1e-5 -add $twp/TWP_3D_${m}_cli_20200130-20200228.nc $twp/TWP_3D_${m}_clw_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_${m}_cl_20200130-20200228.nc
    # cdo -setunit,"frac" -setname,cl -fldmean -gec,5e-7 $twp/TWP_3D_${m}_cltotal_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_${m}_cl_5e-7kgkg-1_20200130-20200228.nc
    # cdo -setunit,"frac" -setname,cl -gec,5e-7 $twp/TWP_3D_${m}_totalwater_20200130-20200228.nc $twp/TWP_3D_${m}_cl_5e-7kgm-3_20200130-20200228.nc
    # cdo -setname,cltotal -add $twp/TWP_3D_${m}_cli_20200130-20200228.nc $twp/TWP_3D_${m}_clw_20200130-20200228.nc $twp/TWP_3D_${m}_cltotal_20200130-20200228.nc
    # cdo -setname,cltotal -fldmean $twp/TWP_3D_${m}_cltotal_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_${m}_cltotal_20200130-20200228.nc
done


#### NICAM ####
# cli=$twp/TWP_3D_NICAM_cli_20200130-20200228.nc
# clw=$twp/TWP_3D_NICAM_clw_20200130-20200228.nc
# clg=$twp/TWP_3D_NICAM_grplmxrat_20200130-20200228.nc
# cls=$twp/TWP_3D_NICAM_snowmxrat_20200130-20200228.nc
# # cloud fraction is 1 where Qi is greater than or equal to 1e-5 kg/kg
# cdo -setname,cltotal -add -add -add $cli $clw $clg $cls $twp/TWP_3D_NICAM_cltotal_20200130-20200228.nc
# cdo -setunit,"frac" -setname,cl -fldmean -gec,1e-5 $twp/TWP_3D_NICAM_cltotal_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_NICAM_cl_20200130-20200228.nc

#### Calculate cloud fraction for SCREAM and GEOS to double check our method vs model output
# SCREAM
# cdo -setunit,"frac" -setname,cl -fldmean -gec,1e-5 -add $twp/TWP_3D_SCREAM_cli_20200130-20200228.nc $twp/TWP_3D_SCREAM_clw_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_SCREAM_cl_calculated1e-5_20200130-20200228.nc
# GEOS
# cli=$twp/TWP_3D_GEOS_cli_20200130-20200228.nc
# clw=$twp/TWP_3D_GEOS_clw_20200130-20200228.nc
# clg=$twp/TWP_3D_GEOS_grplmxrat_20200130-20200228.nc
# cls=$twp/TWP_3D_GEOS_snowmxrat_20200130-20200228.nc
# cdo -setname,cltotal -add -add -add $cli $clw $clg $cls $twp/TWP_3D_GEOS_cltotal_20200130-20200228.nc
# cdo -setunit,"frac" -setname,cl -fldmean -gec,1e-5 $twp/TWP_3D_GEOS_cltotal_20200130-20200228.nc $twp/mean/fldmean_TWP_3D_GEOS_cl_calculated1e-5_20200130-20200228.nc

echo "done"
