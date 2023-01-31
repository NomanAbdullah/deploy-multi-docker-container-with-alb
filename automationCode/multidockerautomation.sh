#!/bin/bash

# Program: A simple bash script to create two nginx 1.23.3 containers and run using docker-compose with two different ports and map with nginx alb
# Author: Abdullah Al Noman
# Date: January 28, 2023

echo ""
echo "Hello there! Let's create two nginx 1.23.3 containers and run them using docker-compose with port 8080 and 9090 and attach with nginx from host machine as application load balancer."
echo "Let me guide you through out the whole process..."

# Step 1: Create a directory - ContainerA
echo ""
echo "[Step 1] Create Directory - ContainerA and add Dockerfile and index.html for Nginx.."
mkdir ./ContainerA
ls
ls ./ContainerA/ 
echo -e 'FROM nginx:1.23.3\n\nCMD ["nginx", "-g", "daemon off;"]' >> ./ContainerA/Dockerfile

cat > ./ContainerA/index.html << EOL
<!DOCTYPE html>
<html>
<head>
        <title> St14 - Abdullah Al Noman </title>
</head>
<body>
        <body style=text-align:center;background-color:red;font-weight:900;font-size:20px;font-family:Helvetica,Arial,sans-serif>
        <img src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png">
	<h1> Welcome to my custom nginx webpage hosted in a Docker as <b>container A</b> </h1>
	<p> Hi, I am Abdullah Al Noman, a SNE student at Innopolis University. I am excited that I just deployed another custom nginx image in a docker container. </p>
</body>
</html>
EOL

# Step 2: Create another directory - ContainerB
echo ""
echo "[Step 2] Create Directory - ContainerB and add Dockerfile and index.html for Nginx.."
mkdir ./ContainerB
ls
ls ./ContainerB
echo -e 'FROM nginx:1.23.3\n\nCMD ["nginx", "-g", "daemon off;"]' >> ./ContainerB/Dockerfile

cat > ./ContainerB/index.html << EOL
<!DOCTYPE html>
<html>
<head>
        <title> St14 - Abdullah Al Noman </title>
</head>
<body>
        <body style=text-align:center;background-color:green;font-weight:900;font-size:20px;font-family:Helvetica,Arial,sans-serif>
        <img src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png">
	<h1> Welcome to my custom nginx webpage hosted in a Docker as <b>container B</b> </h1>
	<p> Hi, I am Abdullah Al Noman, a SNE student at Innopolis University. I am excited that I just deployed another custom nginx image in a docker container. </p>
</body>
</html>
EOL

# Step 3: Create a docker-compose file to build and run the two containers
echo ""
echo "[Step 3] Let's create a docker-compose file.."

cat > docker-compose.yaml << EOL
version: '3.9'
services: 
  containera: 
    build: 
      context: ContainerA 
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    volumes:
      - "./ContainerA/index.html:/usr/share/nginx/html/index.html:ro"

  containerb: 
    build: 
      context: ContainerB
      dockerfile: Dockerfile
    ports:
      - "9090:80"
    volumes:
      - "./ContainerB/index.html:/usr/share/nginx/html/index.html:ro"
EOL

# Step 4: Build the docker-compose file and run it as a daemon
echo ""
echo "[Step 4] Let's build and run the docker-compose file"
docker-compose up -d

# Step 5: Install Nginx in the host machine and configure ALB
echo ""
echo "[Step 5] Let's install and configure Nginx as ALB"
apt-get update -y
apt-get install nginx -y

cat > /etc/nginx/nginx.conf << EOL
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
	worker_connections 768;
}

http {
	upstream abdullahapp {
        server MACHINE_IP:8080;
        server MACHINE_IP:9090;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://abdullahapp;
        }
    }

	sendfile on;
	tcp_nopush on;
	types_hash_max_size 2048;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;


	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; 
	ssl_prefer_server_ciphers on;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	gzip on;

}
EOL

# Restart Nginx Services
systemctl restart nginx

# Congratulations!
echo ""
echo "Congratulations! You have completed all the steps."
echo "Access your websites - http://MACHINE_IP"
