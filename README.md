# Dyamond 2 analysis

## Intro

This is where to find all analysis for DYAMOND 2 simulations. This includes all DYAMOND models including SCREAM - we are using this intercomparison to put SCREAM in context with the other DYAMOND models. Once we have established how SCREAM simulates clouds in DYAMOND, we will use SCREAM to test other hypothesis and work in a Variable-Resolution General-Circulation Model. 

## Installation

The following external libraries are needed: - xarray - netcdf4 - numpy - scipy - dask -matplotlib - jupyter - cartopy

The easiest way to install is to create a conda environment:

```
conda create --name=dyamond -c conda-forge python=3 xarray netcdf4 numpy scipy dask matplotlib cartopy jupyter
conda activate dyamond
```


## Key Points

1. The dyamond models produce a wide array of behaviors with respect to cirrus, convection, and TTL properties.
2. SCREAM performs adequately well in all aspects - we identify its biases compared to other models and to climatology
3. The complexity of the model microphysics does (not) correlate with accuracy of cirrus representation in the models

## How to use this repository

Start with the ```python_scripts/plot_figures.ipynb``` to see how the figures for the paper were generated (Turbeville et al., 2024).
This files lists the necessary preprocessing of the data and references the python notebooks used. 

You'll need access to DKRZ's server, levante, and the dyamond data to truly make the most of these files. Otherwise you'll have to update the code a lot to adapt it to your own model output.

## Collaborators

All code is written by me, Sami Turbeville, with an assist from Jacqueline Nugent for some analysis. 
