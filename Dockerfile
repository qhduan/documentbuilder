FROM ubuntu:18.04
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y libstdc++6 libcurl3-gnutls libc6 libxml2 libcurl3 fonts-dejavu fonts-opensymbol fonts-liberation ttf-mscorefonts-installer fonts-crosextra-carlito
# deb link from https://www.onlyoffice.com/en/download.aspx#builder
COPY onlyoffice-documentbuilder_amd64.deb /root/onlyoffice-documentbuilder_amd64.deb
RUN dpkg -i /root/onlyoffice-documentbuilder_amd64.deb
RUN rm -rf /root/onlyoffice-documentbuilder_amd64.deb
RUN mkdir /app
COPY app.js /app/app.js
COPY package.json /app/package.json
WORKDIR /app
RUN npm install
EXPOSE 3000
CMD [ "node", "app.js" ]
# docker build -t qhduan/docbuilder .
# docker run -it --rm --name db -v ${PWD}:/opt/documentbuilder/scripts -w /opt/documentbuilder qhduan/docbuilder onlyoffice-documentbuilder scripts/parser.docbuilder
