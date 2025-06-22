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
           echo -e "$2 is .....$G SUCCESS $N"
        else
           echo -e "$2 is .....$R FAILURE $N"
           exit 1 
        fi           
}


#Nodejs installation common for every component so creating one function and calling there whenever required
nodejs_setup(){
            dnf module disable nodejs -y &>>$LOG_FILE
            VALIDATE $? "Disabling default nodejs"

            dnf module enable nodejs:20 -y &>>$LOG_FILE
            VALIDATE $? "Enabling nodejs:20"

            dnf install nodejs -y &>>$LOG_FILE
            VALIDATE $? "Installing nodejs:20"

            npm install &>>$LOG_FILE
            VALIDATE $? "Installing Dependencies"
}

app_setup(){

   id roboshop
      if [ $? -ne 0 ]
      then
         useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
         VALIDATE $? "Creating roboshop system user"
      else
         echo -e "System user roboshop already created ... $Y SKIPPING $N"
      fi

   mkdir -p /app 
   VALIDATE $? "Creating app directory"

   curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
   VALIDATE $? "Downloading $app_name"

   rm -rf /app/*
   cd /app 
   unzip /tmp/$app_name.zip &>>$LOG_FILE
   VALIDATE $? "unzipping $app_name"
}

systemd_setup(){

      cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
      VALIDATE $? "Copying $app_name service"

      systemctl daemon-reload &>>$LOG_FILE
      VALIDATE $? "Daemon -reload"

      systemctl enable $app_name  &>>$LOG_FILE
      VALIDATE $? "Enabled $app_name"

      systemctl start $app_name 
      VALIDATE $? "Starting $app_name"

}


print_time(){
      END_TIME=$(date +%s)
      TOTAL_TIME=$(( $END_TIME - $START_TIME ))

      echo -e "Script exection completed successfully, $Y time taken: $TOTAL_TIME seconds $N" | tee -a $LOG_FILE
}


