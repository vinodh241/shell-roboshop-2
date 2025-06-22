
source ./common.sh
app_name=monogodb

check_root

cp mongodb.repo  /etc/yum.repos.d/mongodb.repo &>>$LOG_FILE
VALIDATE $? "copying mongodb.repo"

dnf install mongodb-org -y  &>>$LOG_FILE
VALIDATE $? "installing mongodb"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling mongodb"

systemctl start mongod 
VALIDATE $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Editing mongodb conf file for remote connections"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restrating MOngoDB"

print_time

