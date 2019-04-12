# AWS
AWS Scripts

Collection of scripts written to facilitate various AWS CLI operations.

## route53_update_a.sh

Script to update a single DNS A record.  Currently takes a Route53 
"Hosted Zone ID", top-level domain, and the domain record to update
as parameters, and updates to the "current" external IP (as reported
by ifconfig.me or similar.)  This should be tweaked to work a lot 
nicer.

