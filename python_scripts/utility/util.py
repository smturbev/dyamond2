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
from matplotlib import cm, ticker, colors
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


################################
##         PLOTS              ##
################################

def dennisplot(stat, olr, alb, var=None, xbins=None, ybins=None, 
               levels=None, model="model", region="TWP", var_name="var_name",units="units", 
               cmap=cm.ocean_r, ax=None, save=False, colorbar_on=True, fs=20):
    ''' Returns axis with contourf of olr and albedo.
    
    Parameters:
        - stat (str)   : - 'difference' returns contourf of the difference between the first minus the second in the tuple
                         - 'density' returns density plot of olr-alb joint histogram (pdf), or
                         - statistic for scipy.stats.binned_statistic_2d
        - olr (array)  : 1-D array of OLR values (from 85-310 W/m2), 
        - alb (array)  : 1-D array of Albedo values (from 0-1),
        - var (array)  : 1-D array (var is optional if stat=density or difference)
        - colorbar_on (bool)
                       : returns a tuple of ax, mappable_countour if False
                       
    Returns: 
        - ax (plt.axis): axis with plot 
        - cs (mappable): returned value from plt.contourf, if colorbar_on = False
        
    Note: Values for mean sw downward flux at toa from 
              http://www.atmos.albany.edu/facstaff/brose/classes/ATM623_Spring2015/Notes/Lectures/Lecture11%20--%20Insolation.html. 
    '''
    if xbins is None:
        xbins = np.linspace(70,320,26)
    if ybins is None:
        ybins = np.linspace(0,0.8,33)
    if levels is None:
        if stat=="difference":
            levels = np.linspace(-1,1,100)
        else:
            levels = np.arange(-3,-1.2,0.1)
    if stat=="difference":
        print("difference")
        olr0, olr1 = olr
        alb0, alb1 = alb
        olr0 = olr0[~np.isnan(alb0)]
        alb0 = alb0[~np.isnan(alb0)]
        alb0 = alb0[~np.isnan(olr0)]
        olr0 = olr0[~np.isnan(olr0)]
        olr1 = olr1[~np.isnan(alb1)]
        alb1 = alb1[~np.isnan(alb1)]
        alb1 = alb1[~np.isnan(olr1)]
        olr1 = olr1[~np.isnan(olr1)]
        hist0, xedges, yedges = np.histogram2d(olr0,alb0,bins=(xbins,ybins))
        nan_len = np.sum(~np.isnan(alb0))
        hist0 = hist0/nan_len
        print(nan_len)
        hist1, xedges, yedges = np.histogram2d(olr1,alb1,bins=(xbins,ybins))
        nan_len = np.sum(~np.isnan(alb1))
        hist1 = hist1/nan_len
        print(nan_len)
        binned_stat = hist0-hist1
    else:
        if (olr.shape!=alb.shape) and (var is not None):
            raise Exception("shapes don't match: olr %s, alb %s, %s %s."%(olr.shape, alb.shape, var_name, var.shape))
        elif var is not None:
            if (olr.shape!=var.shape) or (alb.shape!=var.shape):
                raise Exception("shapes don't match: olr %s, alb %s, %s %s."%(olr.shape, alb.shape, var_name, var.shape))
        elif (olr.shape!=alb.shape):
            raise Exception("shapes of alb and olr don't match: %s != %s"%(alb.shape, olr.shape))
        olr = olr[~np.isnan(alb)]
        if stat!='density':
            var = var[~np.isnan(alb)]
        alb = alb[~np.isnan(alb)]
        alb = alb[~np.isnan(olr)]
        if stat!='density':
            var = var[~np.isnan(olr)]
        olr = olr[~np.isnan(olr)]
        if stat!='density':
            alb = alb[~np.isnan(var)]
            olr = olr[~np.isnan(var)]
            var = var[~np.isnan(var)]
        if stat=='density':
            # check for nans
            binned_stat, xedges, yedges = np.histogram2d(olr,alb,bins=(xbins,ybins))
            nan_len = xr.DataArray(alb).count().values
            binned_stat = binned_stat/(nan_len)
            print(nan_len)
        else: 
            var = var[~np.isnan(olr)]
            binned_stat, xedges, yedges, nbins = stats.binned_statistic_2d(olr, alb, var, 
                                                                          bins=(xbins,ybins), statistic=stat)
    xbins2, ybins2 = (xedges[:-1]+xedges[1:])/2, (yedges[:-1]+yedges[1:])/2
    if ax is None:
        ax = plt.gca()
    if stat=="difference":
        csn = ax.contourf(xbins2, ybins2, binned_stat.T*100, levels, cmap=cmap, extend='both')
    else:
        csn = ax.contourf(xbins2, ybins2, np.log10(binned_stat.T), levels, cmap=cmap, extend='both')
        co = ax.contour(csn, colors='k', linestyles='solid', linewidths=1)
    if region=="NAU":
        ax.plot([80,317],[0.57,0.],label="Neutral CRE", color='black') # calculated in line_neutral_cre.ipynb
    elif region=="TWP":
        ax.plot([80,309],[0.55,0.],label="Neutral CRE", color='black') # calculated in line_neutral_cre.ipynb
    else:
        ax.plot([80,320],[0.75,0.2],label="Neutral CRE", color='black') # calculated in line_neutral_cre.ipynb
    ax.grid()
    ax.set_xticks([100,150,200,250,300])
    ax.set_ylim([0.05,0.8])
    ax.set_xlim([80,310])
    ax.set_xlabel('OLR(W m$^{-2}$)', size=fs)
    ax.set_ylabel('Albedo', size=fs)
    if var!=None:
        ax.set_title('{m} {v} {n}'.format(m=model, v=var_name, n=region), size=fs)
    else:
        ax.set_title('{m} {n}\n'.format(m=model, n=region), size=fs)
    ax.tick_params(axis='both',labelsize=fs)
    ax.text(300,0.75,"{l} Profiles".format(l=len(olr)), fontsize=fs, color="0.3", ha="right")

    # plot the colorbar
    if colorbar_on:
        cb = plt.colorbar(csn, ax=ax, orientation='vertical')#, ticks=levtick)
        cb.ax.tick_params(labelsize=fs)
        if stat=="density":
            cb.set_label('log10(pdf)', fontsize=fs)
        elif stat=="difference":
            cb.set_label('pdf % difference', fontsize=fs)
        else:
            cb.set_label('log10(%s) (%s)'%(stat, units), fontsize=fs)
    if save:
        plt.savefig('../plots/olr_alb/native_%s_%s_%s_%s.png'%(var_name.lower().replace(" ","_"), 
                                                               stat, model, region[:3]), bbox_inches="tight")
        print('    saved as ../plots/olr_alb/native_%s_%s_%s_%s.png'%(var_name.lower().replace(" ","_"), 
                                                                   stat, model, region[:3]))
    if colorbar_on:
        ret = ax
    else:
        ret = ax, csn
    return ret

def convert_to_mmhr(model, pr):
    if model.lower()[:6]=="scream":
        pr = 3600000*pr
    elif model.lower()=="nicam" or model.lower()=="um":
        pr = 3600*pr
    elif model.lower()=="sam":
        pr = pr.where(pr>0.05)
    return pr

