# Description : Updating Splash Page in BIGIP
# Author : Dinkar Bhagia
# Date : 20-Aug-2018

#Revision History

# 27 Aug 2018 Switched from CSV to XML

import requests
import sys
import xml.etree.ElementTree as ET
import re
import os
requests.packages.urllib3.disable_warnings()
from f5.bigip import ManagementRoot

application = sys.argv[1]
env = sys.argv[2]
operation = sys.argv[3]
print ("Application : ", application, "Environment : ", env, "Operation : ", operation)


tree = ET.parse("bigip-conf.xml")
root = tree.getroot()

for app in root.iter('application'):
    if app.get('name') == application:
        app_type = app.get('type')
        environment = app.get('env')
        if environment == env:
            print (environment, app_type)
            bigip_server = app.find('bigip_server').text
            part = app.find('partition').text
            vs_name = app.find('vs_name').text
            rules = app.find('rules').text

rulesList = rules.split(",")

print ("Type : ", app_type, "BIGIP Server : ", bigip_server, "Virtual Server Name : ", vs_name, "Partition : ", part)
generic_user = 'moscc-automation_in'


#Password code for Psafe
result = os.popen('/root/bigip/psafe/api_showpassword.sh PDIT-MOS-PROD-AUTOMATION moscc-automation_in').read()
output = result.split('"')
password = output[1]

def findActiveBIGIP(bigip_server ,generic_user, password):
    API_ROOT = ManagementRoot(bigip_server, generic_user, password, token=True)
    state = API_ROOT.tm.cm.devices.get_collection()
    for st in state:
        if st.failoverState == 'active':
            active_bigip = state[0].name
            print ("Active BIGIP : ", active_bigip)
            return active_bigip
        else:
            print ("Please check BIGIP config. Not able identify active BIGIP")

def switchRule(vs_name, part, operation, rulesList):
    virtual_server = API_ROOT.tm.ltm.virtuals.virtual.load(name=vs_name, partition=part)
    print ("Virtual Server to be Updated : ", virtual_server.name)
    print ("Current Irule Config : ", virtual_server.rules)

    if operation == 'enable':
        if app_type == 'int-css':
            if env == 'uat':
                splash_rule = ['/Common/uat_schedule_outage_rule']
            elif env == 'prod':
                splash_rule = ['/Common/analytics_sched_outage_rule']
        elif app_type == 'int-episp':
            if env == 'uat':
                splash_rule = ['/Common/uat_schedule_outage_rule']
            elif env == 'prod':
                splash_rule = ['/Common/mosemp_sched_outage_emplite_rule']
        virtual_server.rules = splash_rule
    elif operation == 'disable':
        virtual_server.rules = rulesList
    else:
        print ("Wrong set of argument")
    virtual_server.update()
    API_ROOT.tm.cm.exec_cmd('run', utilCmdArgs='config-sync to-group device-group-failover')
    virtual_server = API_ROOT.tm.ltm.virtuals.virtual.load(name=vs_name, partition=part)
    print ("Updated Rule : ", virtual_server.rules)


#Code to be Executed

active_bigip = findActiveBIGIP(bigip_server,generic_user, password)
API_ROOT = ManagementRoot(active_bigip, generic_user, password, token=True)
#Update Splash Page to config file

print ("Connection Made to BIGIP : ", API_ROOT.hostname)
print ("Connectivity Check BIGIP Version : ", API_ROOT.tmos_version)
switchRule(vs_name, part, operation, rulesList)