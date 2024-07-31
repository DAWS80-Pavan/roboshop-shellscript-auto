source comman.sh
component=redis

print Disbale redis default
dnf module disable redis -y &>>$log_file
stat $?

print Enable redis 7
dnf module enable redis:7 -y &>>$log_file
stat $?

print Install Redis 7
dnf install redis -y &>>$log_file
stat $?

print Update Redis Config
sed -i '/^bind/ c bind 0.0.0.0' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$log_file
stat $?

print Start Redis Service
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
stat $?