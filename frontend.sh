source comman.sh
component=frontend
app_path=/usr/share/nginx/html


print Disable Nginx default Version
dnf module disable nginx -y &>>$log_file
stat $?

print Enable Nginx 24 Version
dnf module enable nginx:1.24 -y &>>$log_file
stat $?

print Install Nginx
dnf install nginx -y &>>$log_file
stat $?

print Copy nginx config file
cp nginx.conf /etc/nginx/nginx.conf
stat $?

app_prereq

PRINT Start Nginx Service
systemctl enable nginx
systemctl restart nginx
stat $?
