#!/bin/bash

source ./common.sh
check_root


dnf module disable nginx -y  &>>$LOG_FILE
VALIDATE $? "Disable default nginx"

dnf module enable nginx:1.24 -y &>>$LOG_FILE
VALIDATE $? "enable nginx-1.24 version"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx 
VALIDATE $? "enable nginx"
systemctl start nginx 
VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "remove default nginx.html"


curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzipping frontend"

rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "Remove default nginx conf"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying nginx.conf"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"

END_TIME=$(date +%s)
TOTAL_TIME=$(( $END_TIME - $START_TIME ))


echo -e " Script execution completed successfully $Y total time taken : $TOTAL_TIME seconds $N" | tee -a $LOG_FILE