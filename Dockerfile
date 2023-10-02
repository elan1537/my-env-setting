FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

# 필요한 의존성 설치
RUN apt-get update && apt-get install -y curl && apt-get install -y vim
RUN apt-get install -y apt-utils locales
RUN locale-gen ko_KR.UTF-8
ENV LC_ALL ko_KR.UTF-8

# Jupyter 설치
RUN pip install jupyter

# VS Code Server 설치
RUN curl -fsSL https://code-server.dev/install.sh | sh


RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

#set password
RUN echo 'root:qazwsxedc@2023' |chpasswd

#replace sshd_config
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#make .ssh
RUN mkdir /root/.ssh

EXPOSE 22

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# VS Code Server 설정
EXPOSE 8080
# Jupyter 설정
EXPOSE 8888

# 작업 디렉토리 설정
WORKDIR /workspace

# Jupyter notebook과 VS Code Server 실행
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root & code-server --auth none --bind-addr 0.0.0.0:8080 . & /usr/sbin/sshd -D
