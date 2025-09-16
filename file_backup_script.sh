
usage()
{
	echo -e "\nusage:file_backup_script.sh <options> [options: Infa,OBIEE,ODS,ODI]"
	echo -e "eg: file_backup_script.sh Infa\n"
	exit
}
if [ "$1" == "" ]

then 
	usage
fi

export maindir=/webadmin/ana_pre_ref_bkps/Ana-Stg-Bkp-`date +"%Y%m%d"`
mkdir $maindir
chmod -R 777 $maindir
bkupdir=$maindir/$1_`date +"%Y%m%d_%H%M%S"`/
export bkupdir
mkdir -p $bkupdir
while read line;
do

cp -r --backup $line $bkupdir
        echo -e "$line\n";
        done < /webadmin/team_dw/scripts/$1_bkp_files.txt 
          echo -ne " Files has been copied\n";
echo "-----------------------------------------";
echo $bkupdir
ls -lrt $bkupdir
