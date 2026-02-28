#!/usr/bin/bash

# Swich to root user
sudo -i

# Install java 11
dnf install java-11-openjdk java-11-openjdk-devel -y

# Install maven, git and wget
dnf install git maven wget -y

# Change dir to tmp
cd /tmp/

# Download tomcat and extract it 
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz

# Create user
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

# Create filesystem
cat <<EOL > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i
[Install]
WantedBy=multi-user.target
EOL

# Start & Enable service
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# Enabling the firewall and allowing port 8080 to access the tomcat
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload


# Download source code
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project

# Buld code 
mvn install

# Sopt tomcat
systemctl stop tomcat

# Remove Java-17
dnf remove java-17-openjdk java-17-openjdk-headless -y

# Deploy artifact
rm /usr/local/tomcat/webapps/ROOT -rf
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
chown tomcat:tomcat /usr/local/tomcat -R

# Start tomcat
systemctl start tomcat

echo "app01 machine was done"

#End