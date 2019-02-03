################################################################################
##
## [ PROJ ] Bulk report with Bash + Knitr
## [ FILE ] munge_data.r
## [ AUTH ] Benjamin Skinner (@btskinner)
## [ INIT ] 13 January 2019
##
################################################################################

## libraries
library(tidyverse)

## directories
data_dir <- file.path('..','data')

## ---------------------------
## Read data
## ---------------------------

## state crosswalk
cw <- read_csv(file.path(data_dir, 'stcrosswalk.csv')) %>%
    mutate(region_name = case_when(
               region == 1 ~ 'Northeast',
               region == 2 ~ 'Midwest',
               region == 3 ~ 'South',
               region == 4 ~ 'West'))

## county-level unemployment
df <- read_csv(file.path(data_dir, 'county_unemploy.csv')) %>%
    mutate(stfips = substr(fips, 1, 2)) %>%
    left_join(cw, by = 'stfips') %>%
    mutate(stfips = as.numeric(stfips)) %>%
    filter(!is.na(unem_rate), !is.na(region))

## ---------------------------
## County --> State
## ---------------------------

df_st <- df %>%
    select(stfips, year, unem_rate, labor_force) %>%
    group_by(stfips, year) %>%
    summarise(unem_rate = weighted.mean(unem_rate, labor_force),
              labor_force = sum(labor_force)) %>%
    ungroup() %>%
    mutate(level = 'state') %>%
    select(level, id = stfips, year, unem_rate)

## ---------------------------
## State --> Region
## ---------------------------

df_rg <- df %>%
    filter(!is.na(region)) %>%
    group_by(region, year) %>%
    summarise(unem_rate = weighted.mean(unem_rate, labor_force),
              labor_force = sum(labor_force)) %>%
    ungroup() %>%
    mutate(level = 'region') %>%
    select(level, id = region, year, unem_rate)

## ---------------------------
## Region --> Country
## ---------------------------

df_us <- df %>%
    group_by(year) %>%
    summarise(unem_rate = weighted.mean(unem_rate, labor_force),
              labor_force = sum(labor_force)) %>%
    ungroup() %>%
    mutate(level = 'country',
           id = 1) %>%
    select(level, id, year, unem_rate)

## ---------------------------
## Combine into long dataframe
## ---------------------------

df <- bind_rows(df_us, df_rg, df_st)

## ---------------------------
## Write
## ---------------------------

write_csv(df, file.path(data_dir, 'unemploy_2000_2016.csv'))
write_csv(cw, file.path(data_dir, 'stcrosswalk.csv'))

## -----------------------------------------------------------------------------
## END SCRIPT
################################################################################
