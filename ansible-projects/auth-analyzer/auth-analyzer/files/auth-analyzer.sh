#!/bin/bash

#Below script is set to notify if failed login attempts are greater than or equal to 3 in last 1 hour.
#Replace "Failed password for" with "No supported authentication methods available" according to logs captured in auth.log file.
#Set below crontab 
#Authlog-analyzer for failed attempts
#0 * * * * sh /home/ubuntu/techsupport/scripts/auth-analyzer.sh

cd /home/ubuntu/techsupport/scripts

echo > failed-login-attempts.txt

pat=$(date -d '1 hour ago' '+%b %_d %H')

sudo sed -n -e "/$pat/,\$p" /var/log/auth.log | grep -i "Failed password for" > failed-login-attempts.txt
sudo sed -n -e "/$pat/,\$p" /var/log/auth.log | grep -i "No supported authentication methods available" > failed-login-attempts.txt

count=$(wc -l failed-login-attempts.txt | awk '{print $1}')

if [ $count -ge 3 ]
then
I echo "Failed login attempts were $count in last one hour, which is greater than or equal to set threshold 3" | mailx -s 'Alert: "Console login failures" on Server_Name' -r "support@ridlr.in" -S smtp="email-smtp.us-east-1.amazonaws.com:587" -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user="AKIAJDDDPPAKFGNONIKA" -S smtp-auth-password="Ar3wOKPaH0BoOAdY9QU31cnvbx8eceu08EUiNiU1q1GR" -S ssl-verify=ignore kdshinde62@gmail.com
fi



