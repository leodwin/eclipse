import sys
import requests
import json
from bs4 import BeautifulSoup
import os
from datetime import datetime
import csv
import pytz
from urllib import parse
#test
#os.environ['HTTPS_PROXY']='https://www-proxy.us.oracle.com:80'
#os.environ['HTTP_PROXY'] = 'https://www-proxy.us.oracle.com:80'
#os.environ['HTTPS_PROXY'] = 'http://www-proxy.us.oracle.com:80'
#os.environ['HTTP_PROXY'] = 'http://www-proxy.us.oracle.com:80'
os.environ['TZ'] = 'PST8PDT'
proxies = {
  'http': 'www-proxy.us.oracle.com:80',
  'https': 'www-proxy.us.oracle.com:80',
}



st_time = datetime.now(pytz.timezone('PST8PDT'))
#st_time = datetime.now()
print ("Start_Time:"+str(st_time))

i_url = 'https://occn-jira.oraclecorp.com/sr/jira.issueviews:searchrequest-csv-current-fields/18756/SearchRequest-18756.csv'


##i_url = 'https://jira.oraclecorp.com/jira/sr/jira.issueviews:searchrequest-csv-all-fields/157222/SearchRequest-157222.csv'

ftime_prv = open("date_store.txt","r")
prv_time = ftime_prv.read().replace('\n','')

print("Previous script run end time => "+str(prv_time))

last_time = prv_time.replace(":","%3A")

url = i_url
print("csv download URL is :"+url)


def mprint(x):
        sys.stdout.write(x)
        print
        return


headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'}

mprint('[-] Initialization...')
s = requests.session()
s.headers.update(headers)
print ('done')


mprint('[-] Gathering JSESSIONID..')


r = s.get(url)
if r.status_code != requests.codes.ok:
  print ('error')
  exit(1)
print ('done')

c = r.content
soup = BeautifulSoup(c,'lxml')
svars = {}

for var in soup.findAll('input',type="hidden"):
        svars[var['name']] = var['value']


s = requests.session()
r = s.post('https://login.oracle.com/mysso/signon.jsp', data=svars)
#print (r.text)
mprint('[-] Trying to submit credentials...')
#inputRaw = open('credentials.json','r')
#login = json.load(inputRaw)
#print (login)



data =  {
                'v': svars['v'],
                'request_id': svars['request_id'],
                'OAM_REQ': svars['OAM_REQ'],
                'site2pstoretoken': svars['site2pstoretoken'],
                'locale': svars['locale'],
                'ssousername': 'esps-auto_ww@oracle.com',
                'password': 'xxxxx',
}
#print ('before login post')
#print (data)
r = s.post('https://login.oracle.com/oam/server/sso/auth_cred_submit', data=data)
#print (r.text)
#print (url)

r = s.get(url)
#print r
# dumping the HTML report page to CSV file
f = open("jira_csv_for_emds.csv","wb")
f.write(r.content)
f.close()
