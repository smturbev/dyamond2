""" util.py
    Sami Turbeville
    11/7/2019
    
    module for useful functions to keep code in python notebooks clean
"""
from datetime import datetime
import numpy as np
import xarray as xr
from scipy import stats
import time
import sys
import matplotlib.pyplot as plt
import matplotlib.patches as mpat
import matplotlib.transforms as trans
from matplotlib import cm
sys.path.append("/home/disk/p/smturbev/SCREAM-analysis/python_scripts/")
import utility.analysis_parameters as ap
np.warnings.filterwarnings("ignore")

########################################
#             Calculations             #
########################################

def q_to_wc(q,t,p,qv):
    """Returns an xarray of shape and dims q with units of kg/m3.
    
       Parameters:
       - q  [xarray or ndarray]  
                      : (kg/kg) cloud hydrometeor mixing ratio
       - t  [ndarray] : (K)     temperature
       - p  [ndarray] : (Pa)    pressure
       - qv [ndarray] : (kg/kg) water vapor mixing ratio
       
       Returns:
       - wc  : (kg/m3) cloud hydrometeor water content
    """
    rho = p / 287*((1 + 0.61*qv)*t)
    del p, qv, t
    iwc = q * rho
    if type(iwc) is type(xr.DataArray()):
        print("returned iwc with units kg/m3")
        iwc.attrs["units"] = "kg/m3"
    return iwc

def wc_to_wp(wc, p):
    """ Returns the (ice) water path in kg/m2 for given water content (kg/m3).
    
    Parameters
    - wc [xarray or ndarray] : (kg/m3) (ice) water content
    - p  [ndarray]           : (Pa) pressure (of same shape as wc)
    
    Returns:
    - wp [xarray or ndarray] : (kg/m2)
    """
    vint = np.zeros((wc.shape[0],wc.shape[-2],wc.shape[-1]))
    for i in range(wc.shape[1]-1):
        vint = vint + np.nansum((wc[:,i]+wc[:,i+1])*(p[:,i]+p[:,i+1])/9.80665)
    vint = xr.DataArray(vint, dims=["time","lat","lon"], 
                        coords={"time":wc.time,"lat":wc.lat,"lon":wc.lon}, attrs=wc.attrs)
    vint.attrs["units"] = "kg/m2"
    vint.attrs["name"] = "integrated water path"
    return vint