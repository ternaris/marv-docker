FROM ros:kinetic-ros-base

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        capnproto \
        curl \
        ffmpeg \
        libcapnp-dev \
        libjpeg-dev \
        libssl-dev \
        libz-dev \
        python-cv-bridge \
        python2.7-dev \
        python-opencv \
        python-virtualenv \
        ros-kinetic-laser-geometry \
        ros-kinetic-ros-base \
        less \
        locales \
        vim

RUN locale-gen en_US.UTF-8; dpkg-reconfigure -f noninteractive locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN useradd -mU --shell /bin/bash marv
RUN mkdir /opt/marv && chown marv:marv /opt/marv

USER marv

ENV MARV_VENV=/opt/marv
WORKDIR $MARV_VENV
RUN virtualenv -p python2.7 --system-site-packages .
RUN bash -c "./bin/pip install -U pip setuptools pip-tools"
RUN curl -LO https://raw.githubusercontent.com/ternaris/marv-robotics/3f6d689c71e32d81a78424baa15251af8b9bfa7a/requirements.txt
RUN bash -c "source ./bin/activate && pip-sync requirements.txt"
RUN bash -c "./bin/pip install -U --force-reinstall --no-binary :all: uwsgi"
RUN bash -c "./bin/pip install --no-deps pycapnp-for-marv marv-cli marv marv-robotics"

COPY .docker/0001-sessionkey-file.patch $MARV_VENV
RUN bash -c "cd local/lib/python2.7/site-packages; patch -p1 < $MARV_VENV/0001-sessionkey-file.patch"
RUN sed -ie 's,sitedir = os.path.dirname(siteconf),sitedir = "/var/lib/marv",' local/lib/python2.7/site-packages/marv/site.py

USER root
COPY .docker/marv_entrypoint.sh /
COPY .docker/marv_env.sh /etc/profile.d/
RUN echo 'source /etc/profile.d/marv_env.sh' >> /etc/bash.bashrc

ENV MARV_ADDONS=/opt/marv/addons
ENV MARV_CONFIG=/etc/marv/marv.conf
ENV MARV_ETC=/etc/marv
ENV MARV_SCANROOT=/scanroot
ENV MARV_SITE=/var/lib/marv
ENV MARV_VENV=/opt/marv

WORKDIR	/home/marv
USER marv
ENTRYPOINT ["/marv_entrypoint.sh"]
CMD ["uwsgi", "--ini", "/etc/marv/uwsgi.conf"]
