# Your parent image next
#FROM jenkins:latest
# The user next
#USER root
# Environment variables next
#ENV M2_HOME=/usr/share/maven
#ENV M2=/usr/share/maven/bin
#ENV MAVEN_OPTS="-Xms256m -Xmx512m"
# ADDs and RUNs next (put ADDs last whenever possible to quicken image build
#ADD apache-maven-3.3.9 /opt/maven/apache-maven-3.3.9
#ADD jdk1.8.0_72 /opt/jdk/jdk1.8.0_72
#RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_72/bin/java 100
#RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_72/bin/javac 100
#ADD .ssh /root/.ssh
#RUN chmod 600 /root/.ssh/*
#ADD jenkins_home /var/jenkins_home
# Volume declarations next
VOLUME /var/jenkins_home
# Ports declaration next
EXPOSE 22 49148
# Command to run as default next
CMD ["/usr/sbin/sshd", "-D"]
