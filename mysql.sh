#!/bin/bash


source ./common.sh

app_name=mysql

check_root

echo "Please enter thw mysql root password"
read -s MYSQL_ROOT_PASSWORD



dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing MySql server"

systemctl enable mysqld
VALIDATE $? "enablling MySql server"

systemctl start mysqld  
VALIDATE $? "starting MySql Server"


mysql_secure_installation --set-root-pass $MYSQL_ROOT_PASSWORD
VALIDATE $? " setuping root password to login mysql server"

print_time
