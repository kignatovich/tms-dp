FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt update && \
    apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
    curl -sSfL https://apt.octopus.com/public.key | apt-key add - && \
    sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && \
    apt update && apt install -y wget unzip git pylint
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
RUN unzip sonar-scanner-cli-4.7.0.2747-linux.zip
RUN mkdir /opt/sonarscanner
RUN mv sonar-scanner-4.7.0.2747-linux/* /opt/sonarscanner
#RUN echo sonar.host.url=http://192.168.104.10:9000 /opt/sonarscanner/conf/sonar-scanner.properties
RUN chmod +x /opt/sonarscanner/bin/sonar-scanner
RUN ln -s /opt/sonarscanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
RUN mkdir -p /var/jenkins_home/.ssh/
COPY id_rsa /var/jenkins_home/.ssh/id.rsa
COPY id_rsa.pub /var/jenkins_home/.ssh/id.rsa.pub
COPY authorized_keys /var/jenkins_home/authorized_keys
COPY sonar-scanner.properties /opt/sonarscanner/conf/
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY token /opt/sonarscanner/
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY seedjob.groovy /usr/local/seedjob.groovy
COPY jenkins-casc.yaml /usr/local/jenkins-casc.yaml
ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml
