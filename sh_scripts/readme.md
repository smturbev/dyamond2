# README

## Directory set up

The files are organized as such. File names of the form ```get_{}.sh``` are used to get the model output from DYAMOND2 (```/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/```) to my personal scratch directory. From the scratch directory, the files are processed by bash files of the form ```cdo_{}.sh``` and saved in their final form in my personal work directory (```/work/bb1153/b380883/```) in either the ```TWP/``` or ```GT/``` folders. 

The basics of each is to grab the lat-lon box that I want from the global data. I chose to focus on two regions: global tropics (GT; 30N-30S) and the tropical western pacific (TWP; 143E-153E, 5N-5S). 

## How to use these files

You'll need to get access to the dkrz levante server first, where the DYAMOND output is stored.

1. subset from the global files and concatenate to a single file with one variable over the 30 or 40 days as desired.
   ```
   ! for native grid (TWP)
   get_twp_native.sh
   ! for remapping TWP to 1 deg
   remap_twp.sh
   ! for remapping to 1 deg (GT)
   remap_gt.sh
   ! update cdo_cat.sh to concatenate your files from scratch to permanent storage
   cdo_cat.sh
   ```
3. For manipulating the data to calculate IWC, etc. ```cdo_mul.sh```
4. For calculating the horizontal (field) mean:    ```fldmean.sh```
5. For calculating the time mean:   ```timmean.sh```
6. For calculating the iwp histograms used in figure 4: ```simple_iwp_hist.sh```

