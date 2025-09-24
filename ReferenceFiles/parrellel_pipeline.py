import org.jenkinsci.plugins.pipeline.modeldefinition.Utils

node
{
	parallel firstBranch: {
		stage ('CC App Server') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/CC_AppServer_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, secondBranch: {
		stage ('ISP') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/ISP_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, thirdBranch: {
		stage ('MOSCP') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/MOSCP_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, fourthBranch: {
		sleep 900
		stage ('MOSEP') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/MOSEP_Weekend_Roll_Bounce_Pipeline_PROD'
		}
	}, fifthBranch: {
		sleep 900
		stage ('IWT') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/IWT_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, sixthBranch: {
		sleep 900
		stage ('MOS ANALYTICS') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/MOS_Analytics_Weekend_Roll_Bounce_Pipeline-Prod'
		}
	}, seventhBranch: {
		sleep 1200
		stage ('INQUIRA') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/INQUIRA_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, eighthBranch: {
		sleep 1200
		stage ('CC Web Server') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/CC_WebServer_Weekend_Roll_Bounce_Pipeline-PROD'	
		}
	}, ninthBranch: {
		sleep 1800
		stage ('MOSKM') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/MOSKM_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, tenthBranch: {
		sleep 1800
		stage ('NGCCR') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/NGCCR_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, eleventhBranch: {
		sleep 4500
		stage ('EWT') 
		{
			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/EWT_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}, twelfthBranch: {
		sleep 4500
		stage ('TDS Standby Monitor') 
		{
//			build job: '01_MOS_WEEKEND_ROLL_BOUNCE/TDS_Weekend_Roll_Bounce_Pipeline-PROD'
		}
	}
}