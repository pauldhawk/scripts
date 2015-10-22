import sys, csv, django, os
#sys.path.append("C:/Users/paul/Desktop/citiftp")
sys.path.append("/path/to/append")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "site.settings")
from vendors.models import Vendor, User
from datetime import datetime
from django.utils import timezone
import pytz
from pytz import timezone
from datetime import datetime, timedelta

#csv_file_path = "/Volumes/tmp/citiftp/utility_scripts/temp/ad_vendors_output.csv"
csv_file_path = "//deploy/tmp/citiftp/utility_scripts/temp/ad_vendors_output.csv"

def GetCsv(csv_file_path):
	'''returns a dict of a cvs file'''
	retLst = []
	csvFile = open(csv_file_path, 'r')
	csvData = csv.DictReader(csvFile)
	for data in csvData:
		retLst.append(data)
	csvFile.close()
	return retLst

def FillDb(csv_file_path):
	'''fills the db with the data from the lan desk report'''
	users = GetCsv(csv_file_path)
	cen_tz = timezone('America/Chicago')
	time_format = "%m/%d/%y %H:%M"
	for user in users:
		'''in get or create it returns two values fist is the object second is the bool if it existed'''
		try:
			vendor, created = Vendor.objects.get_or_create(vendor=user['Company'].strip().lower())	#adnames
			u, created  = User.objects.get_or_create(email=user['EmailAddress'].strip().lower(),vendor=vendor)
			u.first_name = user['GivenName'].strip().capitalize()
			u.last_name = user['Surname'].strip().capitalize()
			u.email =  user['EmailAddress'].strip().lower()
			u.phone =  user['OfficePhone']
			if (user['PasswordExpired'] == 'TRUE' or user['Enabled'] == 'False'):
				u.account_active = False
			else:
				u.account_active = True

			u.pass_last_set = cen_tz.localize(datetime.strptime(user['PasswordLastSet'], time_format))
			u.user_name = user['SamAccountName'].strip().capitalize()
			u.pass_last_set =
			u.save()
		except:
			print("could not save " +user['GivenName'] + " " + user['Surname'].strip().capitalize() + " "+user['EmailAddress'].strip().lower() )


FillDb(csv_file_path)

users = GetCsv(csv_file_path)
user = users[3]
vendor, created = Vendor.objects.get_or_create(vendor=user['Company'].strip().lower())

cen_tz = timezone('America/Chicago')
time_format = "%m/%d/%y %H:%M"
vendor, created = Vendor.objects.get_or_create(vendor=user['Company'].strip().lower())	#adnames
u, created  = User.objects.get_or_create(email=user['EmailAddress'].strip().lower(),vendor=vendor)
u.first_name = user['GivenName'].strip().capitalize()
u.last_name = user['Surname'].strip().capitalize()
u.email =  user['EmailAddress'].strip().lower()
u.phone =  user['OfficePhone']
if (user['PasswordExpired'] == 'TRUE' or user['Enabled'] == 'False'):
        u.account_active = False
else:
        u.account_active = True

u.pass_last_set = cen_tz.localize(datetime.strptime(user['PasswordLastSet'], time_format))
u.user_name = user['SamAccountName'].strip().capitalize()

#'5/7/2013 4:32:51 PM' does not match format '%m/%d/%y %H:%M'
