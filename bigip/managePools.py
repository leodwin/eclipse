# Description : Manage Pools in BIGIP
# Author : Dinkar Bhagia
# Date : 23-Oct-2018

#Revision History

# 23 OCT 2018 Creted Script to Manage Pools in BIGIP

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
sec_pool_name =''
if len(sys.argv) ==5:
    member_name = sys.argv[4]
elif len(sys.argv) ==6:
    sec_pool_name = sys.argv[4]
    member_name = sys.argv[5]

#print ("Application : ", application, "Environment : ", env, "Operation : ", operation)


tree = ET.parse("bigip-conf.xml")
root = tree.getroot()

for app in root.iter('application'):
    if app.get('name') == application:
        app_type = app.get('type')
        environment = app.get('env')
        if environment == env:
            #print (environment, app_type)
            bigip_server = app.find('bigip_server').text
            part = app.find('partition').text
            vs_name = app.find('vs_name').text
            #sec_pool = app.find('sec-pool').text
            #print sec_pool

#print ("Type : ", app_type, "BIGIP Server : ", bigip_server, "Virtual Server Name : ", vs_name, "Partition : ", part)
generic_user = 'moscc-automation_in'
password = 'Help1desk'

# Password code for Psafe
#result = os.popen('/root/bigip/psafe/api_showpassword.sh PDIT-MOS-PROD-AUTOMATION moscc-automation_in').read()
#output = result.split('"')
#password = output[1]

def findActiveBIGIP(bigip_server ,generic_user, password):
    API_ROOT = ManagementRoot(bigip_server, generic_user, password, token=True)
    state = API_ROOT.tm.cm.devices.get_collection()
    for st in state:
        if st.failoverState == 'active':
            active_bigip = state[0].name
            #print ("Active BIGIP : ", active_bigip)
            return active_bigip
        else :
            print ("Please check BIGIP config. Not able identify active BIGIP")

def getDetailPoolStatus(pool_name,part):
    pool = API_ROOT.tm.ltm.pools.pool.load(name=pool_name, partition=part)
    members = pool.members_s.get_collection()
    for member in members:
        stat = member.stats.load().raw
        url1 = stat['selfLink']
        url_nover = url1.split('?')[0]  # remove the 'ver=x.x.x'
        url_dirs = url_nover.split('/')  # break into path segments
        url_dirs.insert(-2, url_dirs[-2])  # add extra object
        url2 = '/'.join(url_dirs)
        print (url2)
        nestedStatsEntries = stat['entries'][url2]['nestedStats']['entries']
        for key, value in nestedStatsEntries.items():
            print('\t{} = {}'.format(key, value))

def getPoolStatus(pool_name,part):
    pool = API_ROOT.tm.ltm.pools.pool.load(name=pool_name, partition=part)
    members = pool.members_s.get_collection()
    for member in members:
        stat = member.stats.load().raw
        url1 = stat['selfLink']
        url_nover = url1.split('?')[0]  # remove the 'ver=x.x.x'
        url_dirs = url_nover.split('/')  # break into path segments
        url_dirs.insert(-2, url_dirs[-2])  # add extra object
        url2 = '/'.join(url_dirs)
        #print url2
        print ("POOL MEMBER -")
        nestedStatsEntries = stat['entries'][url2]['nestedStats']['entries']
        for key, value in nestedStatsEntries.items():
            if key =='nodeName' or key =='sessionStatus' or key =='port' :
                print('\t{} = {}'.format(key, value))

def updatePoolMember(pool_name,part,operation,member_name):
    pool = API_ROOT.tm.ltm.pools.pool.load(name=pool_name, partition=part)
    pool_member = pool.members_s.members.load(partition=part, name=member_name)
    #pool_member.state = 'unchecked'
    if operation == 'disable' :
        pool_member.session = 'user-disabled'
    elif operation == 'enable' :
        pool_member.session = 'user-enabled'
    else :
        print ( "Wrong Operation Option" )
        exit(1)
    pool_member.description = 'modified through f5-python-SDK'
    pool_member.update()
    API_ROOT.tm.cm.exec_cmd('run', utilCmdArgs='config-sync to-group device-group-failover')
    print("Member "+member_name+" is "+operation+"d")

def updateNode(member_name,part,operation) :
    node = API_ROOT.tm.ltm.nodes.node.load(name=member_name, partition=part)
    if operation == 'node-disable':
        node.state = 'user-down'
        print
    elif operation == 'node-enable':
        node.state = 'user-up'
    else:
        print ("Wrong Operation Option")
        exit(1)
    node.update()
    API_ROOT.tm.cm.exec_cmd('run', utilCmdArgs='config-sync to-group device-group-failover')
    print("Node " + member_name + " is " + operation + "d")
# def managePoolMember(pool_name,member_name,operation):
#     pool = API_ROOT.tm.ltm.pools.pool.load(name=pool_name, partition=part)
#     member = pool.members_s.members.load(name=member_name, partition=part)
#     if operation = 'disable'
#         member.session = 'user-disabled'
#     else if operation = 'enable':
#         member.session = 'user-disabled'
#     else
#         print ("Wrong Operation Value")
#Code to be Executed

active_bigip = findActiveBIGIP(bigip_server,generic_user, password)
API_ROOT = ManagementRoot(active_bigip, generic_user, password, token=True)
#Update Splash Page to config file

print ("Connection Made to BIGIP : ", API_ROOT.hostname)
#print ("Connectivity Check BIGIP Version : ", API_ROOT.tmos_version)
virtual_server = API_ROOT.tm.ltm.virtuals.virtual.load(name=vs_name, partition=part)
print ("Virtual Server : ", virtual_server.name)
print ("Default Pool : ", virtual_server.pool)
pool_name = (virtual_server.pool).split("/")[-1]


#updatePoolMember(pool_name,part,operation,member_name)
#getPoolStatus(pool_name,part)

if operation == 'status':
    getPoolStatus(pool_name, part)
elif operation =='detail-status':
    getDetailPoolStatus(pool_name, part)
elif operation =='node-enable' or operation=='node-disable':
    updateNode(member_name, part, operation)
elif operation == 'enable' or operation =='disable':
    if sec_pool_name =='':
        updatePoolMember(pool_name,part,operation,member_name)
    else:
        updatePoolMember(sec_pool_name, part, operation, member_name)
else :
    print ("Wrong Operation")

#member_name = '152.69.132.34:7780'

#managePoolMember(pool_name,member_name,port,operation)