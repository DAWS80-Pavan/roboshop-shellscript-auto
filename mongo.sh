source comman.sh
component=mongo

print Copy MongoDB repo file
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
stat $?

print Install MongoDB
dnf install mongodb-org -y &>>$log_file
stat $?

print Update MongoDB config file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$log_file
stat $?

print Start MongoDB Service
systemctl enable mongod
systemctl restart mongod
stat $?
