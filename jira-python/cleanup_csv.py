from sys import argv
import csv

if len(argv) == 4:
  script, inputFile, outputFile, cols_str = argv
  cols = [int(i) for i in cols_str.split(",")]

with open(inputFile,"r") as fin:
  with open(outputFile,"w") as fout:
    writer=csv.writer(fout)
    for row in csv.reader(fin):
      sublist = [row[x] for x in cols]
      writer.writerow(sublist)
