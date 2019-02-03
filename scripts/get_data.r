################################################################################
##
## [ PROJ ] Bulk report with Bash + Knitr
## [ FILE ] get_data.r
## [ AUTH ] Benjamin Skinner (@btskinner)
## [ INIT ] 3 February 2019
##
################################################################################

## libraries
library(tidyverse)

## directories
data_dir <- file.path('..','data')
gith_url <- 'https://raw.githubusercontent.com/btskinner'

## ---------------
## State crosswalk
## ---------------

fn <- 'stcrosswalk.csv'
url <- paste(gith_url, 'spatial/master/data', fn, sep = '/')
download.file(url = url,
              destfile = file.path(data_dir, fn),
              mode = 'w')

## ---------------
## County unemploy
## ---------------

fn <- 'county_unemploy.csv'
url <- paste(gith_url, 'county_unemploy/master', fn, sep = '/')
download.file(url = url,
              destfile = file.path(data_dir, fn),
              mode = 'w')

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
