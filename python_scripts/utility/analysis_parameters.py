"""
analysis_parameters.py
author: sami turbeville @smturbev

file names saved as variables and easier to call in methods
especially if file names change
"""
import numpy as np
import xarray as xr
import json

# Color scheme from dyamond1
COLOR_JSON = "/pf/b/b380883/dyamond2/dyamond_colors.json"
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

def get_twp_file(model, var):
    if model.lower()=="data" or model.lower()=="ceres":
        if var.lower()=="olr" or var.lower()=="rlut" or var.lower()=="rad" or var.lower()=="sw":
            return CERES_SYN1_1H
    else:
        if model.lower()=="nicam" or model.lower()=="um":
            return TWP+"TWP_"+model.upper()+"_"+var.lower()+"_20200130-20200228.nc"
        elif model.lower()=="geos":
            return TWP+"TWP_"+model.upper()+"_"+var.lower()+"_20200130-20200303.nc"
        elif model.lower()=="scream" or model.lower()=="sam" or model.lower()=="icon":
            return TWP+"TWP_"+model.upper()+"_"+var.lower()+"_20200130-20200301.nc"
        else:
            raise Exception("model not valid")   
        return

def get_gt_file(model, var):
    if model.lower()=="data" or model.lower()=="ceres":
        if var.lower()=="olr" or var.lower()=="rlut" or var.lower()=="rad" or var.lower()=="sw":
            return 
    else:
        if model.lower()=="nicam" or model.lower()=="um":
            return GT+"GT_"+model.upper()+"_"+var.lower()+"_20200130-20200228.nc"
        elif model.lower()=="scream" or model.lower()=="sam" or model.lower()=="icon" or model.lower()=="geos":
            return GT+"GT_"+model.upper()+"_"+var.lower()+"_20200130-20200301.nc"
        else:
            raise Exception("model not valid")   
        return

def get_timmean_file(model, var, gt=True):
    if var=="clt":
        if gt:
            if (model.lower()=="geos") or model.lower()=="scream" or model.lower()=="icon":
                return TIMMEAN_GT+"timmean_GT_{m}_{v}_20200130-20200301.nc".format(m=model, v=var)
            elif (model.lower()=="nicam")or (model.lower()=="sam") or model.lower()=="um":
                return TIMMEAN_GT+"timmean_GT_{m}_{v}_20200130-20200228.nc".format(m=model, v=var)
            elif (model.lower()=="screamr"):
                return TIMMEAN_GT+"timmean_GT_{m}r_{v}_20200130-20200301.nc".format(m=model, v=var)
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