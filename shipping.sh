#!/bin/bash

source ./common.sh
app_name=shipping

check_root

echo "Please enter the mysql root password"
read -s MYSQL_ROOT_PASSWORD

app_setup


systemd_setup

mavne_setup

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "installing mysql"



mysql -h mysql.vinodh.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/schema.sql
VALIDATE $? "Login and Loading content to mysql for roboshop app"


mysql -h mysql.vinodh.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/app-user.sql 
VALIDATE $? "Login and Loading content to mysql for roboshop app"

mysql -h mysql.vinodh.site -uroot -p$MYSQL_ROOT_PASSWORD < /app/db/master-data.sql
VALIDATE $? "Login and Loading content to mysql for roboshop app"

systemctl restart shipping
VALIDATE $? "restarting the shipping application"


print_time