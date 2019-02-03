#!/usr/local/bin/bash
# ==============================================================================
#
#  [ PROJ ] Bulk report with Bash + Knitr
#  [ FILE ] run_reports.sh
#  [ AUTH ] Benjamin Skinner (@btskinner)
#  [ INIT ] 3 February 2019
#  
# ==============================================================================

# ==============================================================================
# SET OPTIONS
# ==============================================================================

usage()
{
    cat <<EOF
 
 PURPOSE:
 This script generates all reports.
 
 USAGE: 
 $0 <arguments>
 
 ARGUMENTS:		
    [-d]       Top level directory for project
    [-t]       Template file name (without path)
 
 EXAMPLE:
 
 ./run_reports.sh -d ./ -t template.rnw

EOF
}

# argument flags
d_flag=0
t_flag=0

while getopts "hd:t:o:" opt;
do
    case $opt in
	h)
	    usage
	    exit 1
	    ;;
	d)
	    d_flag=1
	    d=$OPTARG
	    ;;
	t)
	    t_flag=1
	    t=$OPTARG
	    ;;
	\?)
	    usage
	    exit 1
	    ;;
    esac
done

# check for missing arguments
if (( $d_flag==0 )) || (( $t_flag==0 )); then
    echo "Missing one or more arguments"
    usage
    exit 1
fi

# convert relative path to absolute path
d=`cd "$d"; pwd`

# set subdirectories
texdir=$d/reports/tex
pdfdir=$d/reports/pdf
figdir=$d/reports/figures

# make subdirectories (if they don't exist)
mkdir -p $texdir
mkdir -p $pdfdir
mkdir -p $figdir

# ==============================================================================
# MAIN
# ==============================================================================

# state list (using abbreviations)
state=(AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS
       KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC
       ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY)

# loop through each place to make report
echo "Creating report for:"
for i in "${state[@]}"
do
    echo "     $i"

    # files
    r=${i,,}			# lowercase (AL --> al)
    texfile=${r}_report.tex     # al_report.tex
    pdffile=${r}_report.pdf	# al_report.pdf

    # set data directory (in relation to top-level directory)
    datadir=$d/data

    # set reports directory (in relation to top-level directory)
    repdir=$d/reports

    # add path to template file (in relation to top-level directory)
    template=$d/reports/$t

    # knit template file into tex document using state subset
    # input:
    #   file     <-- $template : template file to knit
    #   data_dir <-- $datadir  : location of data
    #   repo_dir <-- $repdir   : location of reports
    #   stabbr   <-- $i        : which state?
    # output:
    #   output   <-- $texdir/$texfile : TeX file goes to tex subdir
    echo "       - Knitting..."   
    Rscript -e "data_dir <- '$datadir'" \
	    -e "repo_dir <- '$repdir'" \
    	    -e "stabbr <- '$i'" \
	    -e "knitr::knit('$template','$texdir/$texfile',quiet=T)" > /dev/null

    # produce pdf from tex file (run twice incase of Tikz or internal links)
    echo "       - Converting TeX file to PDF..." 
    pdflatex -output-directory=$texdir "$texdir/$texfile" > /dev/null
    pdflatex -output-directory=$texdir "$texdir/$texfile" > /dev/null

    # move pdf to clean directory
    echo "       - Moving PDF file to PDF directory..." 
    mv "$texdir/$pdffile" "$pdfdir/$pdffile"
    
done

## =============================================================================
## END
################################################################################
