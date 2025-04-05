#! /bin/bash
# Instance Identity Metadata Reference - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-identity-documents.html

# Update the package list and upgrade installed packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Apache (httpd is called apache2 on Ubuntu)
sudo apt-get install -y apache2

# Enable and start the Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Create a simple HTML file for the main page
sudo echo '<h1>Welcome to StackSimplify - APP-1</h1>' | sudo tee /var/www/html/index.html

# Create a directory for the app1 content
sudo mkdir /var/www/html/app1

# Create a simple HTML file for the app1 page
sudo echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html

# Retrieve the instance identity document and save it to a file
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
sudo curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html

# AWS Documentation to retrieve EC2 Instance Data
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html
