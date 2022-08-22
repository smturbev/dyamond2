"""
analysis_parameters.py
author: sami turbeville @smturbev

file names saved as variables and easier to call in methods
especially if file names change
"""

import numpy as np
import xarray as xr
import json

# Color scheme from dyamond
COLOR_JSON = "/home/b/b380883/dyamond2/dyamond_colors.json"
def js_r(filename):
    with open(filename) as f_in:
        return(json.load(f_in))
COLORS = js_r(COLOR_JSON)

# processed output #
WRK = "/work/bb1153/b380883/"

## Regions ##
GT  = WRK+"GT/"
TWP = WRK+"TWP/"

# data #
CERES_SYN1_1H = "/work/bb1153/b380883/TWP/CERES_SYN1deg-1H_Terra-Aqua-MODIS_Ed4.1_Subset_20200101-20200331.nc"
CCCM_JAS = TWP+"CERES_CCCM_JAS_2007-2011.nc"
CCCM_JFM = TWP+"CERES_CCCM_JFM_2007-2011.nc"
ERA5_TWP = "/work/bb1153/b380887/10x10/TWP/"
ERA5_TWP_zg = ERA5_TWP + "ERA5_geopotential_50-200mb_winter_TWP.nc"
ERA5_TWP_ta = ERA5_TWP + "ERA5_temp_50-200mb_winter_TWP.nc"

## time mean ##
TIMMEAN_GT = GT+"timmean/"
UM_PFULL_MEAN = TWP+"mean/fldmean_TWP_3D_UM_pfull_20200130-20200228.nc"
UM_PHALF_MEAN = TWP+"mean/fldmean_TWP_3D_UM_phalf_20200130-20200228.nc"
UM_PFULL = TWP+"TWP_3D_pfull_3hr_UM_20200130-20200228.nc"
UM_PHALF = TWP+"TWP_3D_phalf_3hr_UM_20200130-20200228.nc"


def get_file(model, region="twp", var="rlut"):
    """ returns file path for given variable, region and model
    
        Input:
            - model  (str) : model name - case sensitive
            - var    (str) : variable name - case sensitive
            - region (str) : region (accepts 'TWP' and 'GT' or 'tropics') - not case sensitive
                             default is TWP region (143-153E,5N-5S)
                             Tropics or GT is equitorial belt from 30N to 30S
        Output:
            - filename(str): returns a string of the file name for given input
    """
    if model.lower()=="data" or model.lower()=="ceres":
        if var.lower()=="olr" or var.lower()=="rlut" or var.lower()=="rad" or var.lower()=="sw":
            if region.lower()[:3]=="twp":
                return CERES_SYN1_1H
            elif region.lower()=="gt" or region.lower()=="tropics":
                return
            else:
                raise Exception("region not valid, try TWP or GT")
    elif region.lower()[:3]=="twp":
        return TWP+region+"_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()[:2]=="gt":
        return GT+region+"_"+model+"_"+var+"_20200130-20200228.nc"
    else:
        raise Exception("region {} or model {} or var {} not valid".format(region, model, var))
    

def get_timmean_file(model, region="twp", var="clt"):
    if model=="CERES":
        return WRK+region.upper()+"/"+region+"_"+model+"_"+var+".nc"
    if region.lower()=="twp":
        return TWP+"mean/timmean_TWP_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()=="gt" or region.lower()=="tropics":
        return GT+"timmean/timmean_GT_"+model+"_"+var+"_20200130-20200228.nc"
    elif region.lower()=="gt_14-18km":
        return GT+"timmean/timmean_GT_14-18km_"+model+"_"+var+"_20200130-20200228.nc"
    else:
        raise Exception("region {} not valid".format(region))
    return
    
def get_fldmean_file(model, region="twp", var="pr"):
    if var=="zg":
        if model.lower()=="um" or model.lower()=="scream":
            return TWP+"mean/xytmean_"+region+"_3D_"+model+"_zg_20200130-20200228.nc"
        else:
            return TWP+"mean/fldmean_"+region+"_3D_"+model+"_zg_20200130-20200228.nc"
    if region.lower()=="gt" or region.lower()=="tropics":
        if (model.lower()=="geos") or (model.lower()=="nicam") or model.lower()=="scream" or model.lower()=="icon" or (model.lower()=="screamr"):
            return GT+"fldmean/fldmean_GT_{m}_{v}_20200130-20200301.nc".format(m=model, v=var)
        elif model.lower()=="um":
            return GT+"fldmean/fldmean_GT_{m}_{v}_20200130-20200301.nc".format(m=model, v=var)
        elif (model.lower()=="sam"):
            return GT+"fldmean/fldmean_GT_{m}_{v}_20200130-20200301.nc".format(m=model, v=var)
        else:
            raise Exception("fldmean for "+model+" & "+var+" for GT not accepted.")
        return
    elif region.lower()=="twp":
        return TWP+"mean/fldmean_TWP_3D_"+model.upper()+"_"+var.lower()+"_20200130-20200228.nc"
    return

def get_fldmedian_file(model, region="twp", var="pr"):
    return TWP+"mean/fldmedian_TWP_3D_"+model.upper()+"_"+var.lower()+"_20200130-20200228.nc"

def open_file(model, region="twp", var="rlut", timmean=False, fldmean=False, fldmedian=False):
    if timmean:
        return xr.open_dataset(get_timmean_file(model, region, var))
    elif fldmean:
        return xr.open_dataset(get_fldmean_file(model, region, var))
    elif fldmedian:
        return xr.open_dataset(get_fldmedian_file(model, region, var))
    else:
        return xr.open_dataset(get_file(model, region, var))

def open_dyamond1(model, region="TWP", var="rlut"):
    return xr.open_dataset(TWP+"dyamond1/{}_{}_{}_20160810-20160910.nc".format(region, model, var))
    

