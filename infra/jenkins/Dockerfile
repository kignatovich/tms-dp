FROM jenkins/jenkins:lts-jdk11
USER root
RUN apt update && \
    apt install -y --no-install-recommends gnupg curl ca-certificates apt-transport-https && \
    curl -sSfL https://apt.octopus.com/public.key | apt-key add - && \
    sh -c "echo deb https://apt.octopus.com/ stable main > /etc/apt/sources.list.d/octopus.com.list" && \ 
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt update && apt install -y wget unzip git pylint ansible nodejs apache2-utils python3-pip
RUN pip3 install checkov
RUN pip3 install flake8
RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
RUN unzip sonar-scanner-cli-4.7.0.2747-linux.zip
RUN mkdir /opt/sonarscanner
RUN mkdir /opt/ansible
RUN mv sonar-scanner-4.7.0.2747-linux/* /opt/sonarscanner
RUN chmod +x /opt/sonarscanner/bin/sonar-scanner
RUN ln -s /opt/sonarscanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
RUN mkdir -p /var/jenkins_home/.ssh/
COPY ansible/ /opt/ansible/
RUN  chmod 600 /opt/ansible/id_rsa
COPY prod_url /var/jenkins_home/prod_url
COPY dev_url /var/jenkins_home/dev_url
COPY telegram.sh /var/jenkins_home/telegram.sh
COPY 200.sh /var/jenkins_home/200.sh
COPY ab.sh /var/jenkins_home/ab.sh
COPY id_rsa /var/jenkins_home/.ssh/id.rsa
COPY sonar-scanner.properties /opt/sonarscanner/conf/
COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY token /opt/sonarscanner/
RUN chmod a+x /var/jenkins_home/telegram.sh
RUN chmod a+x /var/jenkins_home/200.sh
RUN chmod a+x /var/jenkins_home/ab.sh
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY seedjob.groovy /usr/local/seedjob.groovy
COPY jenkins-casc.yaml /usr/local/jenkins-casc.yaml
ENV CASC_JENKINS_CONFIG /usr/local/jenkins-casc.yaml
