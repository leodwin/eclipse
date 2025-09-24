#updating Expiry
#===============

#To validate, pbrun as root and run the command 
chage -l oracle   #If Maximum number of days between password change :90, then this is the default.
#To update:
chage -m 0 -M 99999 -I -1 -E -1 oracle

#once you run above, the output should be something like below¿
chage -l oracle

#Result
Last password change : Oct 10, 2020
Password expires : never
Password inactive : never
Account expires : never
Minimum number of days between password change : 0
Maximum number of days between password change : 99999
Number of days of warning before password expires : 7
