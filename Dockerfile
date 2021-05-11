FROM ubuntu:18.04
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y libstdc++6 libcurl3-gnutls libc6 libxml2 libcurl3 fonts-dejavu fonts-opensymbol fonts-liberation ttf-mscorefonts-installer fonts-crosextra-carlito
# deb link from https://www.onlyoffice.com/en/download.aspx#builder
ADD https://download.onlyoffice.com/install/desktop/docbuilder/linux/onlyoffice-documentbuilder_amd64.deb /root/
RUN dpkg -i /root/onlyoffice-documentbuilder_amd64.deb
RUN rm -rf /root/onlyoffice-documentbuilder_amd64.deb
# docker build -t qhduan/docbuilder .
# docker run -it --rm --name db -v ${PWD}:/opt/documentbuilder/scripts -w /opt/documentbuilder qhduan/docbuilder onlyoffice-documentbuilder scripts/parser.docbuilder
