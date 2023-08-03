## SonarQube provides various scanners depending on the programming language. Install the Command line version of the Sonarscanner.

Download the scanner.
```shell
$ wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
Extract the archive.
```
```shell
$ sudo unzip sonar-scanner-cli-4.7.0.2747-linux.zip
```
Move the directory to /opt/sonarscanner.

```shell
$ sudo mv sonar-scanner-4.7.0.2747-linux /opt/sonarscanner
```
Switch to the directory.
```shell
$ cd /opt/sonarscanner
```
Open the sonar-scanner.properties file for editing.
```shell
$ sudo nano conf/sonar-scanner.properties
```
Find the following line and un-comment it.
```shell
#sonar.host.url=http://localhost:9000
```
Change its value and replace it with the server URL.
```shell
sonar.host.url=https://sonarqube.example.com
```
Save the file by pressing CTRL+X, then Y.

Make the scanner binary file executable.
```shell
$ sudo chmod +x bin/sonar-scanner
```
Create a symbolic link to the binary to make it accessible from anywhere.
```shell
$ sudo ln -s /opt/sonarscanner/bin/sonar-scanner /usr/local/bin/sonar-scanner
```
## Scan SonarQube Example Projects
You can test the scanner by running it on SonarQube example projects.

Create a new directory for project testing and switch to it.
```shell
$ mkdir ~/sonar-example-test && cd ~/sonar-example-test
```
Download the example project.

```shell
$ wget https://github.com/SonarSource/sonar-scanning-examples/archive/master.zip
```
Extract the project files.

```shell
$ unzip master.zip
```
Switch to the example project directory.
```shell
$ cd sonar-scanning-examples-master/sonarqube-scanner
```
Run the scanner on the code. Pass the token you created before.

```shell
$ sonar-scanner -D sonar.login=<YourLoginToken>
```
You get the following output after the scan is complete.
```shell
INFO: Analysis total time: 20.621 s

INFO: ------------------------------------------------------------------------

INFO: EXECUTION SUCCESS

INFO: ------------------------------------------------------------------------

INFO: Total time: 39.678s

INFO: Final Memory: 27M/94M

INFO: ------------------------------------------------------------------------
```

Visit the SonarQube dashboard to view the project report.

## Scan Your Code
Transfer the project to your server.

Switch to your project's root directory.
```shell
$ cd ~/myproject
```
Create and open the SonarQube configuration file.

```shell
$ nano sonar-project.properties
```
Define a project key for your project. The chosen key should be unique for your SonarQube instance.
```shell
# Unique ID for the project
sonar.projectKey=MyProject:Key1
```
Enter the project name and version to show up in the SonarQube dashboard.
```shell
sonar.projectName=First Project

sonar.projectVersion=1.0

sonar.projectDescription=My First Project
```
Enter the location of the project files. The location is relative to the directory in which the configuration file is present.
```shell
sonar.sources=src
```
Enter the location of the files you don't want to scan.
```shell
sonar.tests=tests
```
Set the level of logs produced by the scanner. You can skip the property if you want to use the default INFO log level.

```shell
sonar.log.level=DEBUG
```
If you are hosting the project on your server, paste the following line to disable checking for a Source Code Management (SCM) provider.
```shell
sonar.scm.disabled=true
```
Save the file by pressing CTRL+X, then Y.

Run the code scanner by passing your login token.
```shell
$ sonar-scanner -D sonar.login=<YourLoginToken>
```
