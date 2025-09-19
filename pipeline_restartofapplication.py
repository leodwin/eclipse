node{
   notifyBuild()

try{
      stage('Blackout: OBIEE targets') 
{
  build job: '01_MOS_WEEKEND_ROLL_BOUNCE/EM_Blackout_CREATE/', parameters: 
      [
      string(name: 'target', value: 'analyticsprodmt'),
      string(name: 'duration', value: '120')
      ]
      BO_NAME=readFile('/shared_mount/em_blackout/blackout_name/analyticsprodmt.log').trim()
        echo "Blackout Name : ${BO_NAME}"
        EM_BO = 'SUCCESS'
        EM_BO_STS = ':tick:'
        }
}
catch (err)
{
 echo "Blackout Failed"
 /*
 stage('Slack Publish Message Start')
   { build job: 'Slack Publisher', parameters :
     [ 
      string(name: 'env', value:'PROD'),
      string(name: 'PublishContext', value:'OBIEERestart'),
      string(name: 'SlackJsonPayload', value:'EMBlackoutFailed.json'),
      string(name:'SlackChannel', value:'ee-mos-app-maintenance')
     ]
    } */
notifyfailed()
currentBuild.result = 'Failure'
   return;
   }
/*
try{
stage('Slack Publish Message Start')
{ build job: '12_MOS_ANALYTICS_JOBS/Slack Publisher', parameters :
  [ 
  string(name: 'env', value:'PROD'),
  string(name: 'PublishContext', value:'OBIEERestart'),
  string(name: 'SlackJsonPayload', value:'OBIEERestartInProgress.json'),
  string(name:'SlackChannel', value:'ee-mos-app-maintenance'),
  string(name:'CR', value:"CHANGE-1319716?filter=64931")
  ]
}
}
catch (err)
{ echo "Failed to send the message to Slack"
}
*/
try
{stage('MOS Analytics OBIEE Restart') 
{
  build job: '12_MOS_ANALYTICS_JOBS/MOS Analytics OBIEE Restart', parameters:
    [
      string(name: 'env', value: 'PROD'),
    string(name: 'mode', value: 'LIVE')
    ]
}
}
catch (err){
      echo "OBIEE - Bounce failed"
      stage('OBIEE - Bounce failed')
/*      
{ build job: '12_MOS_ANALYTICS_JOBS/Slack Publisher', parameters :
  [ 
  string(name: 'env', value:'PROD'),
  string(name: 'PublishContext', value:'OBIEERestart'),
  string(name: 'SlackJsonPayload', value:'OBIEERestartUnstable.json'),
  string(name:'SlackChannel', value:'ee-mos-app-maintenance')
  ]
} */
notifyfailed()
currentBuild.result = 'Failure'
   return;
   }
/*
stage ('Slack Publish Message Complete')
{ build job: '12_MOS_ANALYTICS_JOBS/Slack Publisher', parameters :
  [ 
  string(name: 'env', value:'PROD'),
  string(name: 'PublishOptions', value:'OBIEERestart'),
  string(name: 'SlackJsonPayload', value:'OBIEERestartComplete.json'),
  string(name:'SlackChannel', value:'ee-mos-app-maintenance'),
  string(name:'CR', value:"CHANGE-1319716?filter=64931")
  ]
} */
try {
stage('Stopping Blackout..')
{ build job: '01_MOS_WEEKEND_ROLL_BOUNCE/EM_Blackout_STOP', parameters :
[
	string(name: 'Blackout_Name', value:"${BO_NAME}")
	]
}}
catch (err){
      echo "BO Stop has failed : ${BO_NAME} - Please stop it manually"
}
notifycomplete() 
}
def notifyBuild() 
{
    userId = "${currentBuild.getBuildCauses()[0].userId}"
    slkmsg1 = "Job Name : ${env.JOB_NAME} \n Job URL : ${JOB_URL} \n Build Number : ${env.BUILD_NUMBER} \n Build Start by : ${userId} \n Build Parameters : \n \t Application : *MOS Analytics* \n \t Environment : PROD \n \t Activity : Weekend Roll Bounce \n Build Status : Started "
    THREAD_ID=readFile('/shared_mount/mos_weekend_roll_bounce/SLACK_THREAD_ID').trim()
    slackSend (color: '#FFFF00', channel: "${THREAD_ID}", message: "${slkmsg1}")
}

def notifyfailed() 
{
    userId = "${currentBuild.getBuildCauses()[0].userId}"
    slkmsg2 = "Job Name : ${env.JOB_NAME} \n Job URL : ${JOB_URL} \n Build Number : ${env.BUILD_NUMBER} \n Build Start by : ${userId} \n Build Parameters : \n \t Application : *MOS Analytics* \n \t Environment : PROD \n \t Activity : Weekend Roll Bounce \n Build Status : Failed "
    THREAD_ID=readFile('/shared_mount/mos_weekend_roll_bounce/SLACK_THREAD_ID').trim()
    slackSend (color: '#db0424', channel: "${THREAD_ID}", message: "${slkmsg2}")
}

def notifycomplete() 
{
    userId = "${currentBuild.getBuildCauses()[0].userId}"
    slkmsg2 = "Job Name : ${env.JOB_NAME} \n Job URL : ${JOB_URL} \n Build Number : ${env.BUILD_NUMBER} \n Build Start by : ${userId} \n Build Parameters : \n \t Application : *MOS Analytics* \n \t Environment : PROD \n \t Activity : Weekend Roll Bounce \n Build Status : Completed "
    THREAD_ID=readFile('/shared_mount/mos_weekend_roll_bounce/SLACK_THREAD_ID').trim()
    slackSend (color: '#076d15', channel: "${THREAD_ID}", message: "${slkmsg2}")
}
