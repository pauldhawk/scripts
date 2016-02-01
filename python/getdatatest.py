#! /usr/bin/python

# To change this template, choose Tools | Templates
# and open the template in the editor.

__author__="paulhawk"
__date__ ="$Nov 21, 2009 9:38:36 PM$"

import psycopg2
import re
import commands

rxDig = re.compile(r'^([^\t\s\;]+)[\t\s]+([^\t\s]+)[\t\s]+[^\t\s]+[\t\s]+([^\t\s]+)[\t\s]+([^\n\r]+)', re.MULTILINE)
# mcDnsServer =  "156.111.235.146" coreDnsServer = "156.111.60.150"
dnsServer = "156.111.60.150"

digOutPut = commands.getoutput(r"dig '@%s' 'adesktopnas.cumc.columbia.edu' ANY +noall +answer" %(dnsServer))
digRecords = re.findall(rxDig, digOutPut)

if (len(digRecords) < 1):
    print "not record"
else:
    for rec in digRecords:
        print rec[0] # fqdn
        print rec[1] # ttl
        print rec[2] # rec type
        print rec[3] # ip

    print """insert into Records (LookupId,Lookupdate,dnsServer,recordType,ip,fqdn,ttl)
            values(33,'1994-11-29',%s,%s,%s,%s,%s)""" % (dnsServer,rec[2],rec[3],rec[0],rec[1])
