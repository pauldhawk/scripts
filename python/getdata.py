#! /usr/bin/python

# To change this template, choose Tools | Templates
# and open the template in the editor.

__author__="paulhawk"
__date__ ="$Nov 21, 2009 9:38:36 PM$"

import psycopg2
import re
import commands

rxDig = re.compile(r'^([^\t\s\;]+)[\t\s]+([^\t\s]+)[\t\s]+[^\t\s]+[\t\s]+([^\t\s]+)[\t\s]+([^\n\r]+)', re.MULTILINE)

dnsServer = "156.111.235.146"
#dnsServer = "156.111.60.150"

# connect to the DB
try:
   conn = psycopg2.connect("dbname='dnsfun' user='WebUser' host='localhost' password='test'");
except:
   print "I am unable to connect to the database"

# Get the data to test
cur = conn.cursor()
cur.execute("""select LookupValue,LookupsId  from Lookups""")
rows = cur.fetchall()

for row in rows:
    digOutPut = commands.getoutput(r'dig @%s %s ANY +noall +answer' %( dnsServer, row[0]))
    rx = re.findall(rxDig, digOutPut)

    if (len(rx) < 1):
            print "add insert"
            cur.execute("""insert into Records (LookupId,Lookupdate,dnsServer, fqdn)
            values(%s,'1994-11-29','%s','%s')""" % (row[1],dnsServer,row[0]))
    else:
        for record in rx:
            print 'entering data into db'
            cur.execute("""insert into Records (LookupId,Lookupdate,dnsServer,recordType,ip,fqdn,ttl)
            values(%s,'1994-11-29','%s','%s','%s','%s',%s)""" % (row[1],dnsServer,record[2],record[3],record[0],record[1]))
            
            InLookup = (cur.execute("""select * from Lookups where LookupValue = '%s'""" % (record[3])))
            if (InLookup == None):
                cur.execute("""insert into Lookups(LookUpTypeID,LookupValue,LookupValueUpate,ErrorID,ErrorUpdate)
                        values(1,'%s','1994-11-29',1,'1994-11-29')"""%(record[3]))
            

conn.commit()
conn.close()