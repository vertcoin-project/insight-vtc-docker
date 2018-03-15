FROM node:8-slim
LABEL maintainer James Lovejoy <jameslovejoy1@gmail.com>

RUN apt update && apt install -y git build-essential python
RUN adduser vertcore -u 9000
RUN mkdir /data && chown vertcore:vertcore -R /data
RUN mkdir /app && chown vertcore:vertcore -R /app
COPY vertcore-node.json /data/vertcore-node.json

USER vertcore

# install vertcore
RUN npm config set prefix /app
RUN npm install --production -g vertcoin-project/vertcore

# run vertcore node
EXPOSE 3001
CMD ["/app/bin/vertcored", "-c", "/data"]