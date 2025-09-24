#!/bin/bash
# Sample script to demonstrate the creation of an HTML report using shell scripting
# Web directory
build=$1
env=$2
mkdir html
rm -fr html/*.html
WEB_DIR=html
# A little CSS and table layout to make the report look a little nicer
echo "<HTML>
<HEAD>
<style>
.titulo{font-size: 1em; color: white; background:#f80000; padding: 0.1em 0.2em;}
table
{
border-collapse:collapse;
}
table, td, th
{
border:1px solid black;
}
</style>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>
<table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
<tr>

<strong>Count where Tolerance of 2% has been crossed for " >> $WEB_DIR/report.html
echo $env_name >> $WEB_DIR/report.html
echo "</strong><br>
<table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
<tr>
<tr><th class='titulo'>Report #</td>
<th class='titulo'>Pipeline</td>
<th class='titulo'>Report Path</td>
<th class='titulo'>Before Count</td>
<th class='titulo'>After Count</td>
</tr>" >> $WEB_DIR/report.html
# Read the output of df -h line by line
IFS=','
while read f1 f2 f3 f4 f5; do
echo "<tr><td width="10%" >" >> $WEB_DIR/report.html
echo $f1 >> $WEB_DIR/report.html
echo "</td><td width="10%" >" >> $WEB_DIR/report.html
echo $f2 >> $WEB_DIR/report.html
echo "</td><td width="50%" >" >> $WEB_DIR/report.html
echo $f3 >> $WEB_DIR/report.html
echo "</td><td width="10%" >" >> $WEB_DIR/report.html
echo $f4 >> $WEB_DIR/report.html
echo "</td><td width="10%" >" >> $WEB_DIR/report.html
echo $f5 >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < results-$build.csv 
echo "</td>" >> $WEB_DIR/report.html
echo "</tr>" >> $WEB_DIR/report.html
echo "</table>" >> $WEB_DIR/report.html
echo "<br><br>     

   
<strong>BEFORE</strong><br>
<table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
<tr><th class='titulo'>Report #</td>
<th class='titulo'>Pipeline</td>
<th class='titulo'>Report Path</td>
<th class='titulo'>Row Count</td>
</tr>" >> $WEB_DIR/report.html
# Read the output of df -h line by line
IFS=','
while read f1 f2 f3 f4; do
echo "<tr><td width="5%" >" >> $WEB_DIR/report.html
echo $f1 >> $WEB_DIR/report.html
echo "</td><td width="5%" >" >> $WEB_DIR/report.html
echo $f2 >> $WEB_DIR/report.html
echo "</td><td width="60%" >" >> $WEB_DIR/report.html
echo $f3 >> $WEB_DIR/report.html
echo "</td><td width="10%" >" >> $WEB_DIR/report.html
echo $f4 >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < rows-$build-before.log
 echo "</td>" >> $WEB_DIR/report.html
    echo "</tr>" >> $WEB_DIR/report.html
echo "</table>" >> $WEB_DIR/report.html
echo "<br><br>" >> $WEB_DIR/report.html

echo "<strong>AFTER</strong><br>
<table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
<tr>
<tr><th class='titulo'>Report #</td>
<th class='titulo'>Pipeline</td>
<th class='titulo'>Report Path</td>
<th class='titulo'>Row Count</td>
</tr>" >> $WEB_DIR/report.html
# Read the output of df -h line by line
IFS=','
while read f1 f2 f3 f4; do
echo "<tr><td width="5%" >" >> $WEB_DIR/report.html
echo $f1 >> $WEB_DIR/report.html
echo "</td><td width="5%" >" >> $WEB_DIR/report.html
echo $f2 >> $WEB_DIR/report.html
echo "</td><td width="60%" >" >> $WEB_DIR/report.html
echo $f3 >> $WEB_DIR/report.html
echo "</td><td width="10%" >" >> $WEB_DIR/report.html
echo $f4 >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < rows-$build-after.log
echo "</td>" >> $WEB_DIR/report.html
echo "</tr>" >> $WEB_DIR/report.html
echo "</table>" >> $WEB_DIR/report.html
echo "<br><br>" >> $WEB_DIR/report.html





echo "</BODY></HTML>" >> $WEB_DIR/report.html