log_file=/tmp/roboshop.lg

rm -f $log_file

code_dir=$(pwd)

print() {
  echo &>>$log_file
  echo &>>$log_file
  echo "##################################$*#######################" &>>$log_file
  echo $*
}

stat() {
  if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
    else
      echo -e "\e[31mFAILURE\e[0m"
      echo
      echo "Refer the log file for more information : File Path : ${log_file}"
      exit $1
    fi
}


app_prereq() {

  print adding application user
  id roboshop &>>$log_file
  if [ $? -ne 0 ]; then
    useradd roboshop &>>$log_file
  fi
  stat $?

  print Remove old content
  rm -rf ${app_path} &>>$log_file
  stat $?

  print adding appdirectory
  mkdir ${app_path} &>>$log_file
  stat $?

  print Download Application Content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$log_file
  stat $?

  print Extract Application Content
  cd ${app_path}
  unzip /tmp/${component}.zip &>>$log_file
  stat $?
}

systemd_setup() {

  print copy service file
  cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  stat $?

  print start service
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  stat $?

}

nodejs() {
  print disable nodejs defult version
  dnf module disable nodejs -y &>>$log_file
  stat $?

  print enable nodejs defult 20 version
  dnf module enable nodejs:20 -y &>>$log_file
  stat $?

  print install nodejs
  dnf install nodejs -y &>>$log_file
  stat $?


#  print copy mongodb repo file
#  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
#  stat $?



  app_prereq

#  print cleaning old content
#  rm -rf /app &>>$log_file
#  stat $?

#  print crating app directory
#  mkdir /app &>>$log_file
#  stat $?

#  print downloading app content
#  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$log_file
# stat $?

#  cd /app
#
#  print extracing app content
#  unzip /tmp/${component}.zip &>>$log_file
#  stat $?

  print download nodejs dependencies
  npm install &>>$log_file
  stat $?

  SCHEMA_SETUP
  systemd_setup


}

java() {
  print install maven
  dnf install maven -y &>>$log_file
  stat $?

  app_prereq

  print Download Dependencies
  mvn clean package &>>$log_file
  mv target/shipping-1.0.jar shipping.jar &>>$log_file
  stat $?


  SCHEMA_SETUP

  systemd_setup
}

SCHEMA_SETUP() {
  if [ "$schema_setup" == "mongo" ]; then
    PRINT COpy MongoDB repo file
    cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    STAT $?

    PRINT Install MongoDB Client
    dnf install mongodb-mongosh -y &>>$log_file
    STAT $?

    PRINT Load Master Data
    mongosh --host mongo.dev.rdevopsb80.online </app/db/master-data.js &>>$log_file
    STAT $?
  fi

  if [ "$schema_setup" == "mysql" ]; then
    PRINT Install MySQL Client
    dnf install mysql -y &>>$log_file
    STAT $?

    for file in schema master-data app-user; do
      PRINT Load file - $file.sql
      mysql -h mysql.dev.rdevopsb80.online -uroot -pRoboShop@1 < /app/db/$file.sql &>>$log_file
      STAT $?
    done

  fi

}
