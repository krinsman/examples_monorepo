FROM jupyterhub-base:latest
LABEL maintainer="William Krinsman <williamkrinsman@lbl.gov>"

# JupyterHub components

RUN \
    pip install git+https://github.com/NERSC/sshspawner.git@named-servers

# Dummy users

RUN \
    adduser -q --gecos "" --disabled-password torgo     && \
    echo torgo:the-master-would-not-approve | chpasswd

RUN \
    adduser -q --gecos "" --disabled-password master    && \
    echo master:you-have-failed-us-torgo | chpasswd

WORKDIR /srv
ADD docker-entrypoint.sh .
ADD jupyterhub_config.py .
RUN chmod +x docker-entrypoint.sh
ADD add_named_server.sh .
RUN chmod +x add_named_server.sh
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

CMD ["jupyterhub", "--debug"]
ENTRYPOINT ["./docker-entrypoint.sh"]
