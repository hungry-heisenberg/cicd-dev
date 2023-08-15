ARG MY_BUILD_ARG

ENV MY_ENV_VAR=${MY_BUILD_ARG}
FROM tomcat:8-jre11
LABEL "Project"="LNP"
LABEL "Author"="Omkar"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY ${MY_ENV_VAR}/target/lnp-app-v1.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
WORKDIR /usr/local/tomcat/
VOLUME /usr/local/tomcat/webapps