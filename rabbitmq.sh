source comman.sh
print copy rabbitmq.repo
cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
stat $?

print install rabbitmq-server user
dnf install rabbitmq-server -y &>>$log_file
stat $?

print start service
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
stat $?

print add application user
rabbitmqctl add_user roboshop roboshop123 &>>$log_file
stat $?

print set_permissions for roboshop
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
stat $?