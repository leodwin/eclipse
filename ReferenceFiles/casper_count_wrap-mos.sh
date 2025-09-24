#!/bin/bash
# ==========================================================================
#  Setups up variables to add colour to script output
# ==========================================================================

############################################
# Display colours
############################################
# Colour ANSI Code  Prefix  Text  Background  Suffix
# Black               [      30      40         m
# Red                        31      41
# Green                      32      42
# Yellow                     33      43
# Blue                       34      44
# Magenta                    35      45
# Cyan                       36      46
# White                      37      47

# Colour ANSI Code  Prefix   Char  Suffix
# All
# attributes off      [        0      m
# Bright characters            1
# Underlined characters        4
# Blinking characters          5
# Reverse video characters     7
# Hidden characters            8


ESC="\033"
STYLE_PLAIN='m'      # plain
STYLE_BOLD=';1m'     # bold

C_BGREY='\E[49;1;30m'     # Bright Grey
C_BRED='\E[49;1;31m'         # Bright Red on Black
C_BGREEN='\E[49;1;32m'    # Bright Green on Black
C_BYELLOW='\E[49;1;33m'   # Bright Yellow on Black
C_BBLUE='\E[49;1;34m'     # Bright Blue on Black
C_BMAGENTA='\E[49;1;35m'  # Bright Magenta on Black
C_BCYAN='\E[49;1;36m'     # Bright Cyan on Black
C_BWHITE='\E[49;1;37m'    # Bright White on Black

C_DGREY='\E[49;0;30m'     # Dark Grey on Black
C_DRED='\E[49;0;31m'      # Dark Red on Black
C_DGREEN='\E[49;0;32m'    # Dark Green on Black
C_DYELLOW='\E[49;0;33m'   # Dark Yellow on Black
C_DBLUE='\E[49;0;34m'     # Dark Blue on Black
C_DMAGENTA='\E[49;0;35m'  # Dark Magenta on Black
C_DCYAN='\E[49;0;36m'     # Dark Cyan on Black
C_DWHITE='\E[49;0;37m'    # Dark White on Black

C_RGREY='\E[7;30m'     # Reverse Grey on Black
C_RRED='\E[7;31m'      # Reverse Red on Black
C_RGREEN='\E[7;32m'    # Reverse Green on Black
C_RYELLOW='\E[7;33m'   # Reverse Yellow on Black
C_RBLUE='\E[7;34m'     # Reverse Blue on Black
C_RMAGENTA='\E[7;35m'  # Reverse Magenta on Black
C_RCYAN='\E[7;36m'     # Reverse Cyan on Black
C_RWHITE='\E[7;37m'    # Reverse White on Black

C_RESET='\E[0;0m'

C_BACKGROUND='\E[49m'  # Set background to black.


function comment_line() {
  echo -e "\n${C_BYELLOW}=========================================================${C_RESET}"
  echo -e "${C_BYELLOW}$(date): ${C_RESET}\n"

}

function comment() {
  echo -e "${C_BYELLOW}$(date): ${C_BBLUE}$1 ${C_RESET}"
}

function comment_error() {
  echo -e "${C_BYELLOW}$(date): ${C_BRED}$1 ${C_RESET}"
}

function comment_warn() {
  echo -e "${C_BYELLOW}$(date): ${C_DYELLOW}$1 ${C_RESET}"
}

function comment_prompt() {
  echo -ne "${C_BYELLOW}$(date): ${C_BBLUE}$1 ${C_RESET}"
}

function comment_green() {
  echo -e "${C_BYELLOW}$(date): ${C_BGREEN}$1 ${C_RESET}"
}

function comment_debug() {
  echo -e "${C_BYELLOW}$(date): ${C_BWHITE}$1 ${C_RESET}"
}

function comment_info() {
  echo -e "${C_BYELLOW}$(date): ${C_BGREY}$1 ${C_RESET}"
}



export http_proxy=http://www-proxy.us.oracle.com:80
export https_proxy=http://www-proxy.us.oracle.com:80

export PHANTOMJS_EXECUTABLE="$WORKSPACE/node_modules/phantomjs-prebuilt/bin/phantomjs"



OIFS="$IFS"; 
IFS=$'\n'; 

build=$1
stage=$2
env=$3
waiting=$4
userpass=$5
COUNTER=0

echo "List of Reports"
cat reports_css_mos.txt

#report_count=$(cat reports.txt | sed '/^\s*$/d' | wc -l)# Counting wrong
#report_count=$(wc -l reports.txt | awk '{print $1}')#Missing onee
report_count=$(grep -c . reports_css_mos.txt)

go_compare="false"
###while read p; do

NAMES="$(< reports_css_mos.txt)" #names from reports.txt file

for p in $NAMES; do

echo "$p"

IFS=',' read -a report_array <<< "$p"



path=${report_array[0]}
report_type=${report_array[1]}

echo "FULL: $p"
echo "PATH: $path"
echo "TYPE: $report_type"

OIFS="$IFS";
IFS=$'\n';



 COUNTER=$(expr $COUNTER + 1)
 
 
  pathurl=$(python -c "import urllib; print urllib.quote('''$path''')")
 # echo "PATH : $p -- COUNTER: $COUNTER "
  #sh casper_count.sh "$p" $build $stage $COUNTER
  

  echo -e "\033[31mSTART CASPERJS CALL\033[0m"
  
 # casperjs test report-obiee-csv-gourl-testing.js --fail-fast --xunit=log.xml --path="$p" --build=$build --stage=$stage --num=$COUNTER
 
 # casperjs responsive-testing-emds-obiee.js "http://ubimv4168.us.oracle.com:9502/analytics/saw.dll?PortalGo&Action=prompt&path=$pathurl"
 
 echo "Counter " $COUNTER
 echo "Report Count" $report_count
if [[ $COUNTER -eq $report_count ]]; then
    go_compare="true"
fi
  
  ./node_modules/casperjs/bin/casperjs test --web-security=no --ignore-ssl-errors=true --verbose --log-level=debug report-obiee-csv-gourl-testing-$env.js --xunit=log-$build-$stage.xml --path="$pathurl" --build=$build --stage=$stage --num=$COUNTER --waiting=$waiting --go_compare=$go_compare --userpass=$userpass
   
  
  
file="report-$build-$stage-$COUNTER.csv"




  #echo ""
  #echo "ERROR"
  #echo $?
  #echo "ERROR"
  #echo ""
  
  echo -e "\033[31mEND CASPERJS CALL\033[0m"
  
  if [ -s $file ]
then 
echo "File contains content"
else
#echo "#ERROR-Empty file $file"
echo -e "\033[31m#ERROR-Empty file $file \033[0m"

fi
  
  if [ "$report_type" == "Detailed" ] ; then
  
  rowcount=$(cat report-$build-$stage-$COUNTER.csv | wc -l )

  elif [ "$report_type" == "Summary" ] ; then
  
  rowcount=$(cat report-$build-$stage-$COUNTER.csv | grep -v IFNULL )
  
  elif [ "$report_type" == "SummaryRows" ] ; then
  
  rowcount=$(cat report-$build-$stage-$COUNTER.csv | grep -v IFNULL )
  
  elif [ "$report_type" == "SummaryHTML" ] ; then
  
  rowcount=$(cat report-$build-$stage-$COUNTER.csv | grep -v IFNULL )
  
  else
  
  rowcount=$(cat report-$build-$stage-$COUNTER.csv | wc -l )
  
  fi
  
if [ "$stage" == "after" ] ; then

  
  comment_error "Checking Before and After Difference..."
  : '
  sdiff -B -b -s "report-$build-before-$COUNTER.csv" "report-$build-after-$COUNTER.csv" > report-$build-$COUNTER-diff.csv
  
  #rowdiff=$(cat report-$build-$COUNTER-diff.csv| wc -l )
  
  difference=$(cat report-$build-$COUNTER-diff.csv | wc -l)

  beforehand=$(cat report-$build-before-$COUNTER.csv | wc -l)
  
  percent=$((200*$difference/$beforehand % 2 + 100*$difference/$beforehand))
  
  #percent_raw=$(echo "scale=4 ; ($difference/$beforehand)" | bc)

  unset percent_noround
'
 # percent_noround=$(awk -v percent_raw="${percent_raw}" -v hundred="100" 'BEGIN{print (percent_raw*hundred)}')
  


  echo "$COUNTER,$build,"\"$path\"",$rowcount,$difference,$percent_noround" >> rows-$build-$stage.log
  
else



  echo "$COUNTER,$build,"\"$path\"",$rowcount" >> rows-$build-$stage.log

fi 
  

##done < reports.txt
done

  #echo -e "\033[31mSTART PHANTOMJS Compare CALL\033[0m"
#casperjs test report-obiee-csv-gourl-testing-phantom.js --xunit=log-$build-$stage.xml --path="$pathurl" --build=$build --stage=$stage --num=$COUNT 
  #echo -e "\033[31mEND PHANTOMJS Compare CALL\033[0m"
IFS="$OIFS"


