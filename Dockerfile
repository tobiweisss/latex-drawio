FROM ubuntu:24.04

# Stage 1: Install Drawio Desktop
# This is copied from https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/Dockerfile
rm /var/lib/dpkg/info/libc-bin.*
apt-get clean

apt-get update
apt-get install -y xvfb wget libgbm1 libasound2

DRAWIO_VERSION="26.0.16"
wget -q https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb
apt-get install -y /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb
rm -rf /opt/drawio-desktop/drawio-${TARGETARCH}-${DRAWIO_VERSION}.deb

apt-get install -y fonts-liberation \
  fonts-arphic-ukai fonts-arphic-uming \
  fonts-noto fonts-noto-cjk \
  fonts-ipafont-mincho fonts-ipafont-gothic \
  fonts-unfonts-core

apt-get remove -y wget
apt-get clean
rm -rf /var/lib/apt/lists/*

##################################################################################################
# Stage 2: Install texlive-full without documentation and language packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install gawk -y && apt-get install coreutils -y && apt-get install grep -y
RUN apt-get install `apt-get --assume-no install texlive-full | awk '/The following additional packages will be installed/{f=1;next} /Suggested packages/{f=0} f' | tr ' ' '\n' | grep -vP 'doc$' | grep -vP 'texlive-lang' | grep -vP 'latex-cjk' | tr '\n' ' '`-y
RUN apt-get install texlive-lang-english texlive-lang-german -y

COPY latex-build.sh /usr/bin/latex-build
RUN chmod +x /usr/bin/latex-build
