FROM jupyterhub-base:latest
LABEL maintainer="William Krinsman <williamkrinsman@lbl.gov>"
WORKDIR /tmp

RUN \
    apt-get update          &&  \
    apt-get --yes upgrade   &&  \
    apt-get --yes install       \
        openssh-server

# Configure sshd

RUN \
    mkdir -p /var/run/sshd

# Python 3 Anaconda and additional packages

RUN \
    conda update --yes conda    &&  \
    conda install --yes             \
        ipykernel                   \
        ipywidgets                  \
        notebook                &&  \
    ipython kernel install      &&  \
    conda clean --yes --all

ADD get_port.py /opt/anaconda3/bin

# Typical extension

RUN \
    jupyter nbextension enable --sys-prefix --py widgetsnbextension

# Dummy user

RUN \
    adduser -q --gecos "" --disabled-password master    && \
    echo master:you-have-failed-us-torgo | chpasswd

WORKDIR /srv
ADD docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "/usr/sbin/sshd", "-p", "22", "-D" ]
