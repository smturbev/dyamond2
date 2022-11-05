#!/bin/bash
#SBATCH --job-name=cldtop_N
#SBATCH --partition=compute
#SBATCH --time=08:00:00
#SBATCH --mem=100GB
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --mail-user=smturbev@uw.edu
#SBATCH --account=bb1153
#SBATCH --error=err_cldtop%j.eo
#SBATCH --output=out_cldtop%j.eo

set -evx # verbose messages and crash message

#################################################
## loop through each level                      #
##     mask where > threshold                   #
##     if mask is true and array is 0:          #
##         assign level and lev index to array  #
#################################################

thres=1e-6
in_file=/work/bb1153/b380883/TWP/TWP_3D_NICAM_cltotal_20200130-20200228.nc
zero_file=/work/bb1153/b380883/TWP/TWP_NICAM_zeros.nc
out_file=/scratch/b/b380883/TWP_NICAM_cldtop_20200130-20200228.nc

# cdo -ifthenc,77 -gec,$thres -select,levidx=77 $in_file $out_file"77"

for lev in {1..77}; do
    echo $lev"  "$((78-lev))
    cdo -ifthenc,$lev -add -gec,$thres -select,level=$((78-lev)) $in_file $out_file"$((79-lev))" $out_file"$((78-lev))"
done
