FROM ubuntu:24.04
ENV DRAWIO_VERSION="26.0.16"
ENV TARGET_ARCH="amd64"

# Stage 1: Install Drawio Desktop
# This is inspired by https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/Dockerfile
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y xvfb wget libgbm1 libasound2t64 git language-pack-en
RUN wget -q https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-${TARGET_ARCH}-${DRAWIO_VERSION}.deb && \
    apt-get install -y ./drawio-${TARGET_ARCH}-${DRAWIO_VERSION}.deb && \
    rm -rf ./drawio-${TARGET_ARCH}-${DRAWIO_VERSION}.deb

RUN apt-get install -y  fonts-liberation \
                        fonts-arphic-ukai fonts-arphic-uming \
                        fonts-noto fonts-noto-cjk \
                        fonts-ipafont-mincho fonts-ipafont-gothic \
                        fonts-unfonts-core

##################################################################################################
# Stage 2: Install texlive-full without documentation and language packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install gawk -y && apt-get install coreutils -y && apt-get install grep -y
RUN apt-get install `apt-get --assume-no install texlive-full | awk '/The following additional packages will be installed/{f=1;next} /Suggested packages/{f=0} f' | tr ' ' '\n' | grep -vP 'doc$' | grep -vP 'texlive-lang' | grep -vP 'latex-cjk' | tr '\n' ' '`-y
RUN apt-get install texlive-lang-english texlive-lang-german -y

##################################################################################################
# Stage 3: Make latex-build script available
COPY latex-build.sh /usr/bin/latex-build
COPY drawio-build.sh /usr/bin/drawio-build
COPY latex-clean.sh /usr/bin/latex-clean
RUN chmod +x /usr/bin/latex-build /usr/bin/drawio-build /usr/bin/latex-clean
RUN mkdir /usr/share/latex-build/
COPY unwanted-logs.txt /usr/share/latex-build/unwanted-logs.txt
RUN echo "shopt -s globstar" >> /root/.bashrc