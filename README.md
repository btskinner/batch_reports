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
   will be the same in each report, the region and state lines will
   change based on the state.  
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
	- `-d` option is used to set the top-level directory (should be
      `../` unless you change the directory structure, which is not
      recommended). 
	- `-t` option is the name of the template file, without path
      (should be `template.rnw` unless you change the template file
      name). 

```bash
git clone
cd ./bulk_reports/scripts
Rscript get_data.r
Rscript munge_data.r
./run_reports -d ../ -t template.rnw
```

