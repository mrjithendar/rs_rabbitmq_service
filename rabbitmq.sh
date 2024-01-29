#!bin/bash 

ORGANIZATION=DecodeDevOps
COMPONENT=rabbitmq
USERNAME=roboshop

ERLANG=https://raw.githubusercontent.com/$ORGANIZATION/$COMPONENT/main/erlang.sh
RABBITMQ_REPO=https://raw.githubusercontent.com/$ORGANIZATION/$COMPONENT/main/rabbitmq-server.sh

OS=$(hostnamectl | grep 'Operating System' | tr ':', ' ' | awk '{print $3$NF}')
selinux=$(sestatus | awk '{print $NF}')

if [ $(id -u) -ne 0 ]; then
  echo -e "\e[1;33mYou need to run this as root user\e[0m"
  exit 1
fi

if [ $OS == "CentOS8" ]; then
    echo -e "\e[1;33mRunning on CentOS 8\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please user CentOS 8\e[0m"
        exit 1
fi

if [ $selinux == "disabled" ]; then
    echo -e "\e[1;33mSE Linux Disabled\e[0m"
    else
        echo -e "\e[1;33mOS Check not satisfied, Please disable SE linux\e[0m"
        exit 1
fi

hostname $COMPONENT

echo -e "\e[1;33minstalling $COMPONENT-server\e[0m"
curl -s $ERLANG | sudo bash
curl -s $RABBITMQ_REPO | sudo bash
yum install -y $COMPONENT-server

echo -e "\e[1;33mstarting $COMPONENT service\e[0m"
systemctl enable $COMPONENT-server
systemctl restart $COMPONENT-server

echo -e "\e[1;33madding $COMPONENT user $USERNAME\e[0m"
rabbitmqctl add_user $USERNAME roboshop123
rabbitmqctl set_user_tags $USERNAME administrator
rabbitmqctl set_permissions -p / $USERNAME ".*" ".*" ".*"

systemctl restart $COMPONENT-server
echo -e "\e[1;33m$COMPONENT successfully installed and configured\e[0m"

if [ $? -eq 0 ]; then
    echo -e "\e[1;33m$COMPONENT configured successfully\e[0m"
    else
        echo -e "\e[1;33mfailed to configure $COMPONENT\e[0m"
        exit 0
fi