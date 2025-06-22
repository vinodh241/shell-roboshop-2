#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root



cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "copying rabbitmq repos"

dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "installing rabbitmq server" 

systemctl enable rabbitmq-server
VALIDATE $? "enabling rabbitmq"

systemctl start rabbitmq-server
VALIDATE $? "Starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "Adding user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "setting up the permissions" 


print_time


