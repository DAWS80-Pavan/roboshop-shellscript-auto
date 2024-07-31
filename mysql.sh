source comman.sh
component=mysql


print Install MySQL Server
dnf install mysql-server -y &>>$log_file
stat $?

print Start MySQL Service
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
stat $?

print Setup MySQL Root Password
mysql_secure_installation --set-root-pass RoboShop@1 &>>$log_file
stat $?