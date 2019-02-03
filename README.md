# Making bulk reports with Bash + knitr

This process uses a combination of Bash scripting and
[knitr](https://yihui.name/knitr/) to create state-specific reports in
bulk. The specific example used shows state-level unemployment trends
from 2000 to 2016. All numbers come from the [Bureau of Labor
Statistics county-level
estimates](https://www.btskinner.me/data/bls-unemployment/) that have
been aggregated to various levels, using labor force size as weights.

Each state will get its own report that contains:

1. A line plot showing the state-level unemployment rate change from
   2000 to 2016 as well as comparision lines for the state's census
   region and the United States as a whole. While the national line
   will be the same in each report, the region line will change based
   on the state.  
2. A table showing the same numbers used in the plot as well as
   columns showing the difference between the state's rates and those
   of the nation and the region.

## To run

Clone this directory, `cd` into the `scripts` directory, and run the
following scripts in order:

1. `get_data.r`
  - downloads necessary data files
2. `munge_data.r`
  - converts data files into format needed for reports
3. `run_reports.sh`
  - knits each state-level report, creating necessary subdirectories
    as needed

```bash
# clone
git clone

# change directory into ./build_reports/scripts
cd ./bulk_reports/scripts

# run get_data.r
Rscript get_data.r

# run munge_data.r
Rscript munge_data.r

# build reports
./run_reports -d ../ -t template.rnw
```

