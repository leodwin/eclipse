import requests
requests.packages.urllib3.disable_warnings()
from f5.bigip import ManagementRoot
API_ROOT = ManagementRoot("ucf-c1z4-lb15a.us.oracle.com", 'moscc-automation_in', 'Help1desk', token=True)
print (API_ROOT.tmos_version)
VIRTUALS_ANA_UAT = API_ROOT.tm.ltm.virtuals.virtual.load(name='uat-mos-analytics.us.oracle.com_443',partition='MOS_Dev_Stage')
print (VIRTUALS_ANA_UAT.name)
print (VIRTUALS_ANA_UAT.rules)
VIRTUALS_ANA_UAT.rules =['/Common/uat_schedule_outage_rule']
VIRTUALS_ANA_UAT.update()
print (VIRTUALS_ANA_UAT.rules)