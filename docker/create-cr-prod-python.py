import requests
import os
import csv
import json

os.environ['TZ'] = 'PST8PDT'
proxies = {
    'http': 'www-proxy.us.oracle.com:80',
    'https': 'www-proxy.us.oracle.com:80',
}

NO_PROXY = {
    'no': 'pass',
}




headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1'}


s = requests.session()
s.headers.update(headers)

with open('ana-cr.csv', mode='r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    line_count = 0
    for i in csv_reader:
        if line_count == 0:
            print(f'Column names are {", ".join(i)}')
            line_count += 1
        #create_json = '{"fields":{"project":{"key":"' + i['project_key'] + '"},"summary":"' + i['summary'] + '","description":"' + i['description'] + '","issuetype":{"name":"' + i['issue_type'] + '"},"components":[{"name":"' + i['component'] + '"}],"customfield_10232":{"value":"' + i['env_type'] + '"},"customfield_10220":{"value":"' + i['activity_type'] + '","child":{"value":"'+i['activity_type_sub']+'"}},"customfield_10233":{"value":"' + i['object'] + '"},"customfield_10234":{"value":"' + i['outage_type'] + '"},"customfield_10236":{"value":"' + i['risk_level'] + '"},"customfield_10700":{"value":"' + i['automation'] + '"},"customfield_10701":[{"value":"' + i['patching_type'] + '"}],"customfield_10226":"' + i['start'] + '","customfield_10223":"' + i['end'] + '","customfield_10240":"' + i['risk_impact'] + '","customfield_10242":"' + i['implement'] + '","customfield_10238":"' + i['backout'] + '","customfield_12600":{"value":"' + i['env_group'] + '"},"labels":["MOS-ANA-AUTO-CR"],"assignee":{"name":"' + i['assignee'] + '"},"reporter":{"name":"' + i['reporter'] + '"},"customfield_10239":"' + i['business_just'] + '"}}}'
        create_json = '{"fields":{"project":{"key":"' + i['project_key'] + '"},"summary":"' + i[
            'summary'] + '","description":"' + i['description'] + '","issuetype":{"name":"' + i[
                          'issue_type'] + '"},"components":[{"name":"' + i[
                          'component'] + '"}],"customfield_10232":{"value":"' + i[
                          'env_type'] + '"},"customfield_10220":{"value":"' + i[
                          'activity_type'] + '","child":{"value":"' + i[
                          'activity_type_sub'] + '"}},"customfield_10233":{"value":"' + i[
                          'object'] + '"},"customfield_10234":{"value":"' + i[
                          'outage_type'] + '"},"customfield_10236":{"value":"' + i[
                          'risk_level'] + '"},"customfield_10700":{"value":"' + i[
                          'automation'] + '"},"customfield_10701":[{"value":"' + i[
                          'patching_type'] + '"}],"customfield_10226":"' + i['start'] + '","customfield_10240":"' + i['risk_impact'] + '","customfield_10242":"' + i[
                          'implement'] + '","customfield_10238":"' + i['backout'] + '","labels":["MOS-ANA-AUTO-CR"],"assignee":{"name":"' + i[
                          'assignee'] + '"},"reporter":{"name":"' + i['reporter'] + '"},"customfield_10239":"' + i[
                          'business_just'] + '"}}}'

        print(create_json)
        headerpost = {'Content-Type': 'application/json'}

        post_url = "https://occn-jira.appoci.oraclecorp.com/rest/api/2/issue/"
        j = s.post(url=post_url, data=create_json, headers={'Content-Type': 'application/json',
                                                            'Authorization': 'Basic ZXNwcy1hdXRvX3d3QG9yYWNsZS5jb206UDBpbnRlclMxc3RlciQ=',
                                                            "User-Agent": "ESPS", "X-Atlassian-Token": "nocheck"})
        print(j)
        print(j.content)

        if j.status_code == 201:

           data = json.loads(j.content)
           print(data['key'])
           new_key = data['key']


           post_url = "https://occn-jira.appoci.oraclecorp.com/rest/api/2/issue/"+new_key+"/assignee"
           g = s.put(url=post_url, data='{"name": "' + i['assignee'] + '"}', headers={'Content-Type': 'application/json',
                                                            'Authorization': 'Basic ZXNwcy1hdXRvX3d3QG9yYWNsZS5jb206UDBpbnRlclMxc3RlciQ=',
                                                             "User-Agent": "ESPS", "X-Atlassian-Token": "nocheck"})

        line_count += 1
    print(f'Processed {line_count} lines.')
