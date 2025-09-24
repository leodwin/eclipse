source /home/espsjenk/jenkins/espsjenk-env.sh

CR_NUMBER=$1
CR_STAGE=$2
CR_COMMENT=$3

TIMENOW=$(date +'%d-%^b-%Y %H:%M')
echo $TIMENOW

/home/espsjenk/jenkins/jira -n=$CR_NUMBER -s=$CR_STAGE -c="$CR_COMMENT" -t="$TIMENOW"

echo "Error" $?