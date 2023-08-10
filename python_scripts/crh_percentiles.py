#!/usr/bin/env python3

"""
Plot stream function in moisture space
1. Calculate CRH.
2. Bin all profiles by CRH (column relative humidity).
3. Stream function, 
    $$ \varphi_i(p) = \varphi_{i-1}(p) + \frac{\alpha}{g} \omega_i(p) $$
    where $i$ is the $i$th bin of CRH, $\alpha$ is the fraction of total grid boxes contained in the $i$th bin, $g$ is the gravitation     constant, $\omega_i(p)$ is the vertical velocity in pressure coordinates in the $i$th bin for each pressure level.
4. Plot stream function (CRH x axis and pressure y axis).
"""

import os.path
import matplotlib.pyplot as plt
import numpy as np
from utility import analysis_parameters as ap
import argparse
import xarray as xr


def rh_from_q(q,p,t, **kwargs):
    """
    Returns xarray of relative humidity
    rh = q/qs*100
    qs = 0.622*es/P
    es = 610.94 exp(17.625*T/(T+243.04)) for T >= 0C
       = 611.21 exp(22.587*T/(T+273.86)) for T <  0C
    """
    t = t - 273.15 # convert to deg C
    # units of es are Pa
    es_warm = 610.94 * np.exp(17.625*t.where(t>=0, other=0)/(t.where(t>=0, other=0)+243.04))
    es_cold = 611.21 * np.exp(22.587*t.where(t<0, other=0)/(t.where(t<0, other=0)+273.86))
    es = es_warm + es_cold
    qs = 0.622*es/p
    rh = q/qs * 100
    return rh

def crh_percentiles(rh, lev="lev", return_crh=False):
    """
    Integreate column realitive humidity then bin by percentiles.
    Bins are 0-100 by 1s. Returns bin edges and crh_percentiles as
    mid_bin values. 
    
    Returns: bins, crh_percs
        if return_crh is True, returns (crh, (bins, crh_percs))
    """
    crh = rh.integrate(lev)
    bins = np.arange(0,101)
    crh_percs = np.zeros(crh.shape)
    
    for i in range(len(bins)-1):
        perc_thres_lower = np.percentile(crh, bins[i])
        perc_thres_upper = np.percentile(crh, bins[i+1])
        crh_percs = np.where((crh>=perc_thres_lower)&(crh<perc_thres_upper), 
                             (bins[i]+bins[i+1])/2, crh_percs)
    if return_crh:
        return crh, (bins, crh_percs)
    else:
        return bins, crh_percs
    return bins, crh_percs

def stream_function(omega, crh_perc, bins):
    """
    Calculate the mean profiles for given omega (Pa/s)
    for each CRH percentile bin.
    
    Input:  vertical velocity (omega, unit: Pa/s),  
            column relative humidity percentiles (crh_perc, unit: %),
            bin edges (bins, unit: %) same as from crh_percentiles.
            
    Output: stream function (phi_rp) in coordinates of CRH and pressure.
                should be of shape (100, nlevs)
            if return_omega is True, returns (w_rp, phi_rp) as tuple
            
    """
    crhp   = crh_perc[:,np.newaxis,:]
    w_rp   = np.zeros((len(bins)-1, omega.shape[1])) # shape of crh mid_bins and pres levels
    phi_rp = np.zeros((len(bins)-1, omega.shape[1])) # shape of crh mid_bins and pres levels
    for i in range(len(bins)-1):
        w_rp[i,:] = np.nanmean(np.where((crhp>=bins[i])&(crhp<bins[i+1]), 
                                    omega, np.nan), axis=(0,2))
        if i==0:
            phi_rp[i,:] = 0.01/9.8*w_rp[i,:]
        else:
            phi_rp[i,:] = phi_rp[i-1]+ 0.01/9.8*w_rp[i,:]  
    return phi_rp   

def plot_stream_function(omega, q, p, t, **kwargs):
    """
    Saves plot for streamfunction derived from given 
    """
    rh = rh_from_q(q, p, t, **kwargs)
    bins, crh_percs = crh_percentiles(rh)
    phi_rp = stream_function(wap, crh_percs, bins)
    fig, ax = plt.subplots(1,1, figsize=(12,12))
    bin_mid = (bins[:-1]+bins[1:])/2
    pc = ax.pcolormesh(bin_mid, wap["lev"].values, phi_rp.T)
    # ax.set_ylim([1000,0])
    plt.colorbar(pc, ax=ax)
    plt.savefig("../plots/{}_streamfunction_twp.png".format(model))
    return ax
    plt.close()   
    
    
if __name__=="__main__":
    # m = str(sys.argv[1])
#     parser = argparse.ArgumentParser()
#     parser.add_argument("-m", "--model", type=str)
#     parser.add_argument("-l", "--lev", type=str)

#     args = parser.parse_args()
#     model = args.model
#     lev = args.lev
#     if args is None:
#         plot_stream_function()
#     else:
#         plot_stream_function(model, lev)
