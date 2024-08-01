source comman.sh
component=dispatch
app_path=/app
systemd_setup


print install golang
dnf install golang -y &>>$log_file
stat $?



app_prereq
#dnf install golang -y
#useradd roboshop
#rm -rf /app
#mkdir /app
#curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip
#cd /app
#unzip /tmp/dispatch.zip
print init dispatch
go mod init dispatch &>>$log_file
stat $?

print go get
go get &>>$log_file
stat $?


print go build
go build &>>$log_file
stat $?


print start service
systemctl daemon-reload &>>$log_file
systemctl enable dispatch &>>$log_file
systemctl restart dispatch &>>$log_file
stat $?