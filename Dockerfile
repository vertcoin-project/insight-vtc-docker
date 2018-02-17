FROM node:8-slim
MAINTAINER James Lovejoy <jameslovejoy1@gmail.com>

RUN apt update && apt install -y git build-essential python

RUN adduser vertcore

USER vertcore
WORKDIR /home/vertcore
ADD run.sh /home/vertcore/run.sh

RUN /home/vertcore/run.sh clone
RUN /home/vertcore/run.sh install

CMD ["/home/vertcore/vertcore/bin/vertcored"]
