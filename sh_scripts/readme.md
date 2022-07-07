# README

## Directory set up

The files are organized as such. File names of the form ```get_{}.sh``` are used to get the model output from DYAMOND2 (```/work/dicad/from_Mistral/dicad/cmip6-dev/data4freva/model/global/dyamond/DYAMOND_WINTER/```) to my personal scratch directory. From the scratch directory, the files are processed by bash files of the form ```cdo_{}.sh``` and saved in their final form in my personal work directory (```/work/bb1153/b380883/```) in either the ```TWP/``` or ```GT/``` folders. 

The basics of each is to grab the lat-lon box that I want from the global data. I chose to focus on two regions: global tropics (GT; 30N-30S) and the tropical western pacific (TWP; 143E-153E, 5N-5S). 
