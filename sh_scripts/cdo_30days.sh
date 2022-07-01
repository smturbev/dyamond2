#!/bin/bash
#SBATCH --job-name=seldate
#SBATCH --partition=compute
#SBATCH --account=bb1153
#SBATCH --time=00:30:00
#SBATCH --error=err_30days.eo
#SBATCH --output=out_30days.eo
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu

set -evx # verbose messages and crash message
wrk=/work/bb1153/b380883/TWP

declare -a fileArray=(TWP_3D_UM_hus_20200130-20200228.nc
TWP_3D_UM_ta_20200130-20200228.nc
TWP_3D_UM_Tv_20200130-20200228.nc
TWP_3D_NICAM_ta_20200130-20200228.nc
TWP_3D_NICAM_hus_20200130-20200228.nc
TWP_3D_SCREAM_hus_20200130-20200228.nc
TWP_3D_SCREAM_ta_20200130-20200228.nc
TWP_3D_UM_hus_20200130-20200228.nc
)

# (SAM/TWP/TWP_clivi_SAM_20200120-20200229.nc
# SAM/TWP/TWP_rltacc_SAM_20200120-20200229.nc
# SAM/TWP/TWP_rstacc_SAM_20200120-20200229.nc
# SAM/TWP/TWP_SAM_rlt_20200120-20200229.nc
# SAM/TWP/TWP_SAM_rst_20200120-20200229.nc)

# (NICAM/GT/clivi_GT_NICAM-3km_20200120-20200228.nc
# NICAM/GT/rlut_GT_NICAM-3km_20200120-20200228.nc
# NICAM/GT/rsdt_GT_NICAM-3km_20200120-20200228.nc
# NICAM/GT/rsut_GT_NICAM-3km_20200120-20200228.nc
# SAM/GT/GT_SAM_clivi_20200120-20200229.nc
# SAM/GT/GT_SAM_rlt_20200120-20200229.nc
# SAM/GT/GT_SAM_rltacc_20200120-20200229.nc
# SCREAM/GT/GT_regridded_clivi_20200120-20200301.nc
# SCREAM/GT/GT_regridded_rlt_20200120-20200301.nc
# SCREAM/GT/GT_regridded_rltcs_20200120-20200301.nc
# SCREAM/GT/GT_regridded_rst_20200120-20200301.nc
# SCREAM/GT/GT_SCREAM_clivi_20200120-20200229.nc
# SCREAM/GT/GT_SCREAM_rlt_20200120-20200229.nc
# GEOS/GT/GT_GEOS_rlut_20200120-20200229.nc
# GEOS/GT/GT_GEOS_clivi_20200120-20200229.nc)

for file in "${fileArray[@]}"; do
    in_file=$wrk/$file
    out_file=$wrk/${file%_*}"_30days.nc"
    echo $in_file
    echo $out_file
    # cdo -seldate,2020-01-30T00:00:00,2020-03-01T23:59:00 $in_file $wrk/$out_file
    cdo -seltimestep,1/240 $in_file $out_file
done

echo "done"