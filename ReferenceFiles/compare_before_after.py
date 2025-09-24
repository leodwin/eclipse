#!/usr/bin/env python

import csv
import sys
with open('rows-'+sys.argv[1]+'-before.log', 'r') as before:
    before_indices = dict((i[2], i[3]) for i in csv.reader(before))


with open('rows-'+sys.argv[1]+'-after.log', 'r') as reportAfter:
    with open('results-'+sys.argv[1]+'.csv', 'w') as results:
        reader = csv.reader(reportAfter)
        writer = csv.writer(results, quoting=csv.QUOTE_NONNUMERIC)

        for row in reader:
            value = before_indices.get(row[2])

            if float(row[3]) > 1.02*float(value) or float(row[3]) < 0.98*float(value):
                writer.writerow([int(row[0]),int(row[1]),row[2],int(value),int(row[3])])
