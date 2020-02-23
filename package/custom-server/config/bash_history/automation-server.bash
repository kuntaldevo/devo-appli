cd /usr/local/paxata/server/config/
ssh centos@mongo-server
rpm -qa | grep paxata-server
sudo su paxata
sudo rm /var/log/paxata/frontend.log
ps aux | grep paxata-server
sudo tailf -1000 /var/log/paxata/frontend.log
sudo service paxata-server status
