FROM ppiper/jenkins-master

ENV JENKINSFILE_RUNNER_VERSION 1.0-beta-9

# User needs to be root for access to mounted Docker socket
# hadolint ignore=DL3002
USER root
RUN curl -O https://repo.jenkins-ci.org/releases/io/jenkins/jenkinsfile-runner/jenkinsfile-runner/$JENKINSFILE_RUNNER_VERSION/jenkinsfile-runner-$JENKINSFILE_RUNNER_VERSION-app.zip && \
    unzip jenkinsfile-runner-$JENKINSFILE_RUNNER_VERSION-app.zip -d jenkinsfile-runner && \
    rm jenkinsfile-runner-$JENKINSFILE_RUNNER_VERSION-app.zip && \
    chmod +x /jenkinsfile-runner/bin/jenkinsfile-runner

RUN mkdir /jenkins-war && unzip /usr/share/jenkins/jenkins.war -d /jenkins-war && \
    mkdir -p /var/cx-server/jenkins-configuration

# "Default" Jenkinsfile for test case
COPY Jenkinsfile /workspace/Jenkinsfile


RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.5 \
    python3-pip \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install nibabel pydicom matplotlib pillow
RUN pip3 install med2image
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install flask

COPY main.py /workspace/main.py

ENTRYPOINT ["/jenkinsfile-runner/bin/jenkinsfile-runner", \
            "--jenkins-war", "/jenkins-war", \
            "--plugins", "/usr/share/jenkins/ref/plugins", \
            "--file", "/workspace", \
            "--no-sandbox"]