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
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib import cm, ticker, colors
sys.path.append("/home/disk/p/smturbev/SCREAM-analysis/python_scripts/")
import utility.analysis_parameters as ap
np.warnings.filterwarnings("ignore")

########################################
#             Calculations             #
########################################

# functions
def get_esi(t):
    return (611.21 * np.exp(22.587*t/(t+273.86)))

def get_es(t):
    return (610.94 * np.exp(17.625*t/(t+243.04)))

def get_qs(es, p):
    return 0.622*es/p

def q2rhi(t, p, q, **kwargs):
    """
    Returns xarray of relative humidity wrt ice
    rhi = q/qs*100
    qsi = 0.622*es/P
    esi = 611.21 exp(22.587*T/(T+273.86)) for T <  0C
    """
    t = t - 273.15 # convert to deg C
    esi = get_esi(t)
    qsi = get_qs(esi, p)
    rh = q/qsi * 100
    return rh

def q2rh(t, p, q, **kwargs):
    """
    Returns xarray of relative humidity wrt liquid
    rh = q/qs*100
    qs = 0.622*es/P
    es = 610.94 exp(17.625*T/(T+243.04)) for T >= 0C
    """
    t = t - 273.15 # convert to deg C
    es = get_es(t)
    qs = get_qs(es, p)
    rh = q/qs * 100
    return rh

def q2wc(t, p, q, qi, **kwargs):
    """
    Returns xarray of ice or liquid water content
    iwc = qi * rho
    """
    rho = calc_rho(t, p, q)
    return (qi*rho)
    
def pot_temp(t, p):
    """ Returns potential temperature (theta in K)
        Input t (K) and p (Pa)
    """
    Rd = 287 # J/K/kg
    cp = 1004 # J/K/kg
    theta = t * np.power(100000/p, Rd/cp)
    return theta

def eq_pot_temp(t, p, q):
    """ Returns equivalent potential temperature (thetae in K)
        Input t (K), p (Pa) and q (kg/kg)
    """
    theta = pot_temp(t,p)
    Lv = 2.25e6 # J/kg
    cp = 1004 # J/K/kg
    qsi = get_qsi(get_esi(t), p)
    thetae = theta * np.exp(Lv * qsi / (cp * t) )
    return thetae
    
def crh_percentiles(t, p, q, lev="lev", bins = np.arange(0,101,4), return_crh=False):
    """
    Integreate column realitive humidity then bin by percentiles.
    Bins are 0-100 by 1s. Returns bin edges and crh_percentiles as
    mid_bin values. 
    
    Returns: bins, crh_percs
        if return_crh is True, returns (crh, (bins, crh_percs))
        
    TODO: crh = column integrated wv to saturatation wv
    """
    qs = get_qs(get_es(t), p)
    q_int = q.integrate("lev")
    qs_int = qs.integrate("lev")
    crh = q_int/qs_int
    print("shape of crh:", crh.shape)
    crh_percs = np.zeros(crh.shape)
    
    for i in range(len(bins)-1):
        perc_thres_lower = np.nanpercentile(crh, bins[i])
        perc_thres_upper = np.nanpercentile(crh, bins[i+1])
        crh_percs = np.where((crh>=perc_thres_lower)&(crh<perc_thres_upper), 
                             (bins[i]+bins[i+1])/2, crh_percs)
    crh_percs = xr.DataArray(crh_percs, dims=crh.dims, coords=crh.coords, 
                             attrs={"long_name":"column relative humidity binned percentiles","units":"%"})
    if return_crh:
        return crh, (bins, crh_percs)
    else:
        return bins, crh_percs
    return bins, crh_percs

def stream_function(omega, crh_perc, bins, return_omega=False):
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
    w_rp   = np.zeros((len(bins)-1, omega.shape[1])) # shape of crh mid_bins and pres levels
    phi_rp = np.zeros((len(bins)-1, omega.shape[1])) # shape of crh mid_bins and pres levels
    for i in range(20, len(bins)-1):
        w_rp[i,:] = omega.where((crh_perc>= bins[i])&(crh_perc<bins[i+1])).mean(skipna=True, dim=["time","ncol"])
        alpha = 1 # 0.01
        if (i==20):
            phi_rp[i,:] = alpha/9.8*w_rp[i,:]
        else:
            phi_rp[i,:] = phi_rp[i-1]+ alpha/9.8*w_rp[i,:] 
    if return_omega:
        return phi_rp, w_rp
    return phi_rp

def binned_by_crh(var, crh_perc, bins):
    """
    Calculate the mean profiles for given variable
    for each CRH percentile bin.
    
    Input:  variable (e.g., qi, unit: kg/kg),  
            column relative humidity percentiles (crh_perc, unit: %),
            bin edges (bins, unit: %) same as from crh_percentiles.
            
    Output: binned_var (var_r) in coordinates of CRH and pressure.
                should be of shape (100, nlevs)
            
    """
    var_r = np.zeros((len(bins)-1, var.shape[1])) # shape of crh mid_bins and pres levels
    for i in range(len(bins)-1):
        var_r[i,:] = var.where((crh_perc>= bins[i])&(crh_perc<bins[i+1])).mean(skipna=True, dim=["time","ncol"])
    return var_r

def calc_rho(t, p, q):
    Tv = (1 + 0.61*q)*t
    rho = p / (287*Tv)
    return rho

def w2omega(t, p, q, w):
    rho = calc_rho(t, p, q)
    g=9.8 #m/s2
    omega = -rho*g*w # (kg/m/s2)/s = Pa/s
    return omega

def omega2w(t, p, q, omega):
    rho = calc_rho(t, p, q)
    g=9.8
    w = -omega/(rho*g) # m/s
    return w

def get_lwcre(olr, olrcs):
    lwcre = olrcs.values - olr
    return lwcre

def get_swcre(alb, albcs):
    swcre = -(alb-albcs)*413.2335274324269 #twp
    return swcre

def calc_Tb(OLR):
    """ Calculate brightness temp from OLR
     *from J. Nugent to be consistent with decimals used etc. 
    """
    sigma = 5.670374419e-8
    Tb = (OLR/sigma)**0.25
    
    return Tb

def calc_rh_ice(qv, t, p):
    """ Calculates the relative humidity with respect to ice.
        Uses equation 7 from Murphy and Koop (2005) to get the
        saturation pressure wrt ice:
            e_si = exp(9.550426 - 5723.265/T + 3.53068*ln(T) - 0.00728332*T)
        where T is temperature. Works best for T>110K. e_si is in Pa.
        The saturation mixing ratio is:
            w_si = (0.622 * e_si) / (p - e_si)
        And RHice is the ratio of mixing ratio of water vapor to saturation vapor pressure.
            RH_ice = w_i / w_si
        where w_i is the mixing ratio:
            w_i = qv / (1-qv)
        To get RH_ice to a percent, we multiply by 100.
        
        Input:
            - qv (narray) : specific humidity or mixing ratio of water vapor (kg/kg)
            - t  (narray) : temperature (K)
            - p  (narray) : pressure (Pa)
    
        Output:
            - rh_ice (narray) : relative humidity wrt ice (%)
    """
    e_si = np.exp(9.550426 - 5723.265/T + 3.53068*np.log(T) - 0.00728332*T)
    w_si = (0.622 * e_si) / (p - e_si)
    w_i  = qv / (1 - qv)
    rh_ice = w_i/w_si * 100
    return rh_ice

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
            levels = np.arange(-0.9,1,0.2)
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
    elif stat=="density":
        csn = ax.contourf(xbins2, ybins2, np.log10(binned_stat.T), levels, cmap=cmap, extend='both')
        co = ax.contour(csn, colors='k', linestyles='solid', linewidths=1)
    else:
        csn = ax.contourf(xbins2, ybins2, (binned_stat.T), levels, cmap=cmap, extend='both')
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
    if var is not None:
        ax.set_title('{m} {v} {n}'.format(m=model, v=var_name, n=region), size=fs)
    else:
        ax.set_title('{m} {n}\n'.format(m=model, n=region), size=fs)
    ax.tick_params(axis='both',labelsize=fs)
    if len(olr)>10:
        ax.text(300,0.75,"{l} Profiles".format(l=len(olr)), fontsize=fs, color="0.3", ha="right")

    # plot the colorbar
    if colorbar_on:
        # divider = make_axes_locatable(ax)
        # cax = divider.append_axes("right", size="5%", pad=0.05)

        cb = plt.colorbar(csn, ax=ax, shrink=0.8)
        cb.ax.tick_params(labelsize=fs-4)
        if stat=="density":
            cb.set_label('log10(pdf)', fontsize=fs)
        elif stat=="difference":
            cb.set_label('pdf % difference', fontsize=fs)
            cb.set_ticks((levels[1:]+levels[:-1])/2)
        else:
            cb.set_label('{} ({})'.format(stat, units), fontsize=fs)
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

def schematic(ax=None, arrow=True, fs=24):
    """Returns an axis with the plot showing the schematic of the
    cloud populations and idealized lifecycle (if arrow=True).
    
    Parameters:
        ax (plt.axis)   = axis for plotting
        arrow (boolean) = Draws an arrow from deep convection 
                to thin cirrus if true
    """
    c = ['#1D6295', '#75B6E5', '#27CED7', '#A3CEED', '#65757D', "#264457"]

    if ax is None:
        fig = plt.figure(figsize=(8,7.7))
        ax = fig.add_subplot(111, aspect='auto')
    dc = mpat.Ellipse((110,0.6),85,0.3, alpha=0.9, fc=c[0], ec=c[5])
    an = mpat.Ellipse((112,0.42),180,0.25,alpha=0.9, fc=c[1], ec=c[5])
    cu = mpat.Ellipse((240,0.5),90,0.42,alpha=0.9, fc=c[2], ec=c[5])
    ci = mpat.Ellipse((260,0.2),80,0.3, alpha=0.9, fc=c[3], ec=c[5])
    cs = mpat.Ellipse((280,0.1),30,0.1, alpha=0.9, fc=c[4], ec=c[5])

    dennisplot("density",np.array([0]),np.array([0]),ax=ax, colorbar_on=False, region="TWP")

    ax.annotate("    Deep\nConvection", xy=(82,0.57),xycoords='data', fontsize=fs-2, color='w')
    ax.annotate("   \n Anvil\n  Cirrus", xy=(145,0.17),xycoords='data', fontsize=fs, color='w')
    ax.annotate("Congestus", xy=(208,0.48),xycoords='data', fontsize=fs, color='w')
    ax.annotate(" Thin\nCirrus", xy=(242,0.16),xycoords='data',fontsize=fs, color='w')
    ax.annotate(" Clear\n   Sky", xy=(264,0.06),xycoords='data',fontsize=fs-6, color='w')

    # rotate anvil cirrus oval
    t_start = ax.transData
    t = trans.Affine2D().rotate_deg(-30)
    t_end = t_start + t
    an.set_transform(t_end)
    # create arrow from dc to cs
    arc = mpat.FancyArrowPatch((110, 0.56), (280, 0.1), connectionstyle="arc3,rad=.2", 
                               arrowstyle = '->', alpha=0.9, lw=6, linestyle='solid', color='k')#(0.9,(2,2)))
    arc.set_arrowstyle('->', head_length=15, head_width=12)
    # add elements to axis
    ax.add_patch(an)
    ax.add_patch(dc)
    ax.add_patch(cu)
    ax.add_patch(ci)
    ax.add_patch(cs)
    
    if arrow:
        ax.add_patch(arc)
    # axis properties
    ax.set_ylim([0,0.8])
    ax.set_yticks(np.arange(0,0.81,0.2))
    ax.set_title("Schematic of Cloud Types\n", fontsize=fs)
    ax.set_axisbelow(True)
    return 

