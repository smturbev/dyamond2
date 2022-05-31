#!/bin/bash
#SBATCH --job-name=seldate
#SBATCH --partition=prepost
#SBATCH --mem=20GB
#SBATCH --ntasks=1
#SBATCH --time=09:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --output=out_seltime%j.eo
#SBATCH --error=err_seltime%j.eo

set -evx # verbose messages and crash message
scr2=/work/bb1153/b380883/GT

declare -a fileArray=(GT_SCREAM_clivi_20200120-20200229.nc
GT_SCREAM_rlt_20200120-20200229.nc)

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
    in_file=$scr2/$file
    out_file=${file%_*}"_20200130-20200301.nc"
    echo $out_file
    cdo -seldate,2020-01-30T00:00:00,2020-03-01T23:59:00 $in_file $scr2/$out_file
done

echo "done"