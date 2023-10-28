#!/bin/bash
sleep 30
sudo apt update -y
sudo apt install python3-pip -y
sudo pip3 install locust
sudo apt install nginx -y
sudo apt install nghttp2-client -y
sudo apt install nghttp2-client -y

cat << 'EOF' > /home/ubuntu/locustfile.py
import random,string,urllib3
from locust import HttpUser, task

#Disabling the "InsecureRequestWarning" warning 
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

class proxyTesting(HttpUser):
    host = "https://server.proxy.com"

    def on_start(self):
        self.client.proxies = { "http"  : "http://lsimon.proxy.com:11443", "https" : "http://lsimon.proxy.com:11443"}
        self.client.verify = False
    
    @task
    def get(self):
        self.client.get("/")

EOF

cat << 'EOF' > /home/ubuntu/master.conf
[master conf]
master = true
expect-workers = 4

[runtime settings]
locustfile = /home/ubuntu/locustfile.py
users 400
spawn-rate = 1
run-time = 1m
headless = true
only-summary = true

EOF

#sudo sh -c 'echo export HTTP_PROXY="lsimon.proxy.com:11443" >> /etc/environment'
#sudo sh -c 'echo export HTTPS_PROXY="lsimon.proxy.com:11443" >> /etc/environment'
#sudo sh -c 'echo "Acquire::http::Proxy \"http://lsimon.proxy.com:11443/\";" >> /etc/apt/apt.conf.d/proxy.conf'
#sudo sh -c 'echo "Acquire::https::Proxy \"https://lsimon.proxy.com:11443/\";" >> /etc/apt/apt.conf.d/proxy.conf'
sudo sh -c 'echo "*               soft    nofile            15000" >> /etc/security/limits.conf'
sudo sh -c 'echo "*               hard    nofile            30000" >> /etc/security/limits.conf'
nohup sudo locust --config master.conf &
touch /home/ubuntu/finishInit.txt
echo "*****+++++=====  CLOUD INIT SCRIPT FINISHED  *****+++++====="