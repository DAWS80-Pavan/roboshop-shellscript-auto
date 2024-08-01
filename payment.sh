source comman.sh
component=payment
app_path=/app
systemd_setup

print install python3
dnf install python3 gcc python3-devel -y &>>$log_file
stat $?

app_prereq


print pip3 install
pip3 install -r requirements.txt &>>$log_file
stat $?

#print start service
#systemctl daemon-reload &>>$log_file
#systemctl enable payment &>>$log_file
#systemctl restart payment &>>$log_file
#stat $?
