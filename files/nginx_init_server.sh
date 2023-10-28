#!/bin/bash
sleep 30
sudo apt update -y

### Nginx configurations ###
sudo apt install nginx -y
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=US/ST=Ohio/L=Col/O=SE/OU=SE_Test/CN=server.proxy.com" -keyout /etc/ssl/private/server.proxy.com.key -out /etc/ssl/certs/server.proxy.com.crt
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048
cat << 'EOF' > /etc/nginx/snippets/self-signed.conf
ssl_certificate /etc/ssl/certs/server.proxy.com.crt;
ssl_certificate_key /etc/ssl/private/server.proxy.com.key;
EOF

echo "Adding SSL/TLS settings"
cat << 'EOF' > /etc/nginx/snippets/ssl-params.conf
ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_dhparam /etc/nginx/dhparam.pem;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
ssl_session_timeout  10m;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off; # Requires nginx >= 1.5.9
ssl_stapling on; # Requires nginx >= 1.3.7
ssl_stapling_verify on; # Requires nginx => 1.3.7
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;
# Disable strict transport security for now. You can uncomment the following
# line if you understand the implications.
# add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
EOF

echo "Added 443 configuration"
cat << EOF >> /etc/nginx/sites-available/default
#/etc/nginx/sites-available/example.com
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    include snippets/self-signed.conf;
    include snippets/ssl-params.conf;

    server_name server.proxy.com www.server.proxy.com;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

}
server {
    listen 4443 ssl http2;
    include snippets/self-signed.conf;
    include snippets/ssl-params.conf;

    server_name server.proxy.com www.server.proxy.com;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

}
EOF

echo "Checking Nginx config with 'nginx -t'"
nginx -t

echo "Re-starting Nginx with 'systemctl restart nginx'"
systemctl restart nginx


### Locust configs ###
sudo apt install python3-pip -y
sudo pip3 install locust
cat << 'EOF' > /home/ubuntu/locustfile.py
import random,string
from locust import HttpUser, task

class proxyTesting(HttpUser):
    host = "https://ubuntu.com"

    @task
    def get(self):
        self.client.get("/")

EOF
sudo sh -c 'echo export HTTP_PROXY="lsimon.proxy.com:11443" >> /etc/environment'
sudo sh -c 'echo export HTTPS_PROXY="lsimon.proxy.com:11443" >> /etc/environment'
sudo sh -c 'echo "Acquire::http::Proxy \"http://lsimon.proxy.com:11443/\";" >> /etc/apt/apt.conf.d/proxy.conf'
sudo sh -c 'echo "Acquire::https::Proxy \"https://lsimon.proxy.com:11443/\";" >> /etc/apt/apt.conf.d/proxy.conf'

echo "*****+++++=====  CLOUD INIT SCRIPT FINISHED  *****+++++====="