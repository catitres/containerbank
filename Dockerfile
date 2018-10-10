# Pull base image
From tomcat:8-jre8-alpine

# Copy to images tomcat path
COPY target/containerbank.war /usr/local/tomcat/webapps/
