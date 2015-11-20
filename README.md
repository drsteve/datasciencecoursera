# Cleaning the UCI HAR data

##Repository contents
This repository contains:

 - `README.md` : This file
 - `CodeBook.md` : A full description of the data set and analysis method
 - `run_analysis.R` : R script to clean the data set
 - `UCI_HAR_reduced.txt` : ASCII data file produced by `run_analysis.R`

##Required R packages
All functionality used is in either `base` or `utils`, both of which come with
most standard installations of R.

Note that the data download uses curl, so this must be installed on the system 
so that R can use it.

##Instructions
To run the code, simply start R and enter:
```
source('run_analysis.R')
```
If the data are not in the working directory they will be downloaded and
unzipped before proceeding.

The output should be an ASCII file named `UCI_HAR_reduced.txt`

### For further information
The code (`run_analysis.R`) is heavily commented, and a description of its
contents and purpose can be found in the code book (`CodeBook.md`).
