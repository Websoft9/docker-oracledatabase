sudo echo "oracle version:" $(cat /data/apps/oracle/.env |grep APP_VERSION|cut -d= -f2)  1>> /data/logs/install_version.txt
