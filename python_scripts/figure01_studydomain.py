""" figure1_studydomain.py
    author: sami turbeville
    updated: july 2024 (X)

    script to generate the plot for figure 1 in turbeville et al., 2024;
    adapted from plot_map.ipynb

"""


import matplotlib.pyplot as plt
import xarray as xr
import numpy as np
import cartopy.crs as ccrs
from cartopy.mpl.gridliner import LongitudeFormatter
import pandas as pd
from utility import analysis_parameters as ap


def plot_map(twp=True):
    # open file with initial ssts for dyamond set up
    var= xr.open_dataset(ap.GT + 'initial_sst.nc').sst.isel(time=0)
    
    # set up figure
    fig = plt.figure(figsize=(14,3))
    proj = ccrs.PlateCarree(central_longitude=180)
    ax = plt.axes(projection=proj)
    ax.stock_img()
    ax.coastlines()
    cs = var.where(var>290).plot.contourf(levels=np.arange(290,305,1), extend='both',cmap='Blues_r', add_colorbar=False, transform=ccrs.PlateCarree())
    
    # plot twp box
    if twp:
        ax.plot(np.array([143,153,153,143,143])-180,[5,5,-5,-5,5], 'r', lw=2)
    fs=16
    
    # fix longitude marks for plot
    lon_formatter = LongitudeFormatter(zero_direction_label=True)
    ax.xaxis.set_major_formatter(lon_formatter)
    
    # axis settings
    ax.set_extent((-180, 180, -30, 30), crs=proj)
    ax.set_xticks(ticks=np.arange(-180,181,60), minor=False)
    ax.set_yticks(ticks=np.arange(-30,31,10), minor=False)
    ax.set_xlabel('Longitude', fontsize=fs-2)
    ax.set_ylabel('Latitude', fontsize=fs-2)
    cbar = plt.colorbar(cs, shrink=0.8, ax=ax, pad=0.01)
    cbar.set_label('Temperature (K)', fontsize=fs-2)
    cbar.ax.tick_params(labelsize=fs-2)
    plt.tick_params(labelsize=fs-2)
    ax.set_title("")
    
    # save figure
    plt.savefig('../plots/figure01_map.pdf', bbox_inches="tight")
    print("saved as ../plots/figure01_map.pdf")
    plt.show()

if __name__=="__main__":
    plot_map()
