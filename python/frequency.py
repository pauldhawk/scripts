import csv

users_old_ftp = '/Users/phawk/Dropbox/workscripts/ftp/import_lists/userfromoldftp.csv '
users_new_ftp = '/Users/phawk/Dropbox/workscripts/ftp/import_lists/citinewusers/unamesfromnewciti.csv' 

pcs = []

def freq (lst):
	"returns a dictionary of the frequency of an object in a list"
	retDict = {} 
	for i in lst:
		if (i not in retDict):
			retDict[i] = 0
		retDict[i] += 1
	return retDict

def GetCsv(FSCsvFile):
	retLst = []
	csvFile = open(FSCsvFile, 'r')
	csvData = csv.reader(csvfile, delimiter=',')
	for data in csvData:
		retLst.append(data)
	csvFile.close()
	return retLst

oldftp = GetCsv(users_old_ftp)
newfpt =  GetCsv(users_new_ftp)


for c in csvData:
	if 'impact' not in c['Primary Owner'].lower():
		pcs.append(c)

fieldnames = sorted(list(set(k for d in csvData for k in d)))
writer = csv.DictWriter(outFile, fieldnames=fieldnames, dialect='excel')

writer.writeheader() 
for row in pcs:
	writer.writerow(row)

outFile.close()

