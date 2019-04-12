#!/bin/bash
## Script to update a single Route53 DNS entry
## Author: John Q.   Updated: 2017-09-26
## Tools: bash awscli curl dig cut grep

## Standard variables
AWSZONEID="$1"
DNSZONE="$2"
RECORDSET="$3"
TTL="$4"

## Override here
#AWSZONEID="/hostedzone/ABCDEFG"
#DNSZONE="example.com"
#RECORDSET="www.example.com" ## To change a "root" DNS entry, simply put the full domain as the recordset
TTL=3600

## Fix me: pull zone ID from hosted zones automatically:
##   aws route53 list-hosted-zones --output text | cut -f 3-4 | grep example.com | cut -f 1

###

printf "=== Route53 Update === \n"
printf "ZoneID: ${AWSZONEID} | DNS Zone: ${DNSZONE} | RecordSet: ${RECORDSET} \n"

## Pull current IP
printf "Current IP from DNS: "
MYIP="`curl -s https://checkip.amazonaws.com/`"
#MYIP="1.2.3.4"
printf "${MYIP} ... \n"

## Pull current record from NameServers (warning, could be out of date if a recent change was submitted)
SITEIP="`dig +short ${RECORDSET}`"

if [ "${SITEIP}" == "${MYIP}" ] ; then
        printf "IP ${SITEIP} unchanged.\n"
else
        ## Send change request using formatted JSON
        printf "Updating ${MYIP} ... \n"
        aws route53 change-resource-record-sets  --cli-input-json  "{ \"HostedZoneId\":\"${AWSZONEID}\", \"ChangeBatch\": { \"Comment\":\"Update ${DNSZONE} ${RECORDSET} to ${MYIP}\",\"Changes\":[ { \"Action\":\"UPSERT\",\"ResourceRecordSet\": { \"Name\":\"${RECORDSET}\", \"Type\":\"A\", \"TTL\":${TTL}, \"ResourceRecords\": [ { \"Value\":\"${MYIP}\" } ] } } ] } }"

fi

printf "=== Done. ===\n"

