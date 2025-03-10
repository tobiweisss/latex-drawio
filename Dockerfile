# This is a debian based image containing a headless version of draw.io
FROM rlespinasse/drawio-desktop-headless

# Install texlive-full without documentation and language packages
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install gawk -y && apt-get install coreutils -y && apt-get install grep -y
RUN apt-get install `apt-get --assume-no install texlive-full | awk '/The following additional packages will be installed/{f=1;next} /Suggested packages/{f=0} f' | tr ' ' '\n' | grep -vP 'doc$' | grep -vP 'texlive-lang' | grep -vP 'latex-cjk' | tr '\n' ' '`-y
RUN apt-get install texlive-lang-english texlive-lang-german -y

COPY latex-build.sh /usr/bin/latex-build
RUN chmod +x /usr/bin/latex-build
