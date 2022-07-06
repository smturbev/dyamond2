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

# data #
CERES_SYN1_1H = "/work/bb1153/b380883/TWP/CERES_SYN1deg-1H_Terra-Aqua-MODIS_Ed4.1_Subset_20200101-20200331.nc"

# processed output #
SCR2 = "/work/bb1153/b380883/"

## Regions ##
GT=SCR2+"GT/"
TWP = SCR2+"TWP/"

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
    else:
        return TWP+region.upper()+"_"+model+"_"+var+"_20200130-20200228.nc"

def get_timmean_file(model, region="twp", var="clt"):
    if var=="clt":
        if region.lower()=="gt":
            if (model.lower()=="geos") or (model.lower()=="nicam") or model.lower()=="scream" or model.lower()=="icon" or (model.lower()=="screamr") or (model.lower()[-3:]=="deg"):
                return TIMMEAN_GT+"timmean_GT_{m}_{v}_20200130-20200301.nc".format(m=model, v=var)
            elif model.lower()=="um":
                return TIMMEAN_GT+"timmean_GT_{m}_{v}_20200130-20200228.nc".format(m=model, v=var)
            elif (model.lower()=="sam"):
                return TIMMEAN_GT+"timmean_GT_{m}_{v}_20200130-20200229.nc".format(m=model, v=var)
            else:
                raise Exception("timemean for "+model+" & "+var+" for GT not accepted.")
                return
        else:
            if (model.lower()=="nicam"):
                raise Exception("timemean for "+model+" & "+var+" for TWP not accepted.")
                return 
            else:
                raise Exception("timemean for "+model+" & "+var+" for TWP not accepted.")
                return
    else:
        raise Exception("timemean for "+var+" not accepted.")
        return
    return
    
def get_fldmean_file(model, region="twp", var="pr"):
    if var=="zg":
        return TWP+"mean/xytmean_"+region+"_3D_"+model+"_zg_20200130-20200228.nc"
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
    

