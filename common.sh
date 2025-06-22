#!/bin/bash

START_TIME=$( date +%s )
USERID=$( id -u )
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-2-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME.log
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER

check_root(){
      if [ $USERID -ne 0 ]
      then
         echo -e "$R ERROR: : $Y Please run this script with root access $N"
         exit 1
      else
         echo -e "$G You are running with root access $N"
      fi
}

# VALIDATE functions takes input as exit  status, what command they tried to install 
    VALIDATE(){
        if [ $1 -eq 0 ]
        then
           echo -e "$G Installing $2 is ..... SUCCESS $N"
        else
           echo -e "$R Installing $2 is ..... FAILURE $N"
           exit 1 
        fi           
}

print_time(){
      END_TIME=$(date +%s)
      TOTAL_TIME=$(( $END_TIME - $START_TIME ))

      echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
}


