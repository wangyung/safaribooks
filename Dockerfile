FROM python:3.8.5-alpine

WORKDIR /app/safaribooks

COPY requirements.txt ./

RUN apk add --update --no-cache --virtual .build-deps \ 
    g++ gcc

RUN apk add --no-cache libxslt-dev libxml2-dev && \
    pip3 install --no-cache-dir -r requirements.txt && \ 
    apk del .build-deps

COPY *.py run.sh ./

ENTRYPOINT [ "/app/safaribooks/run.sh" ]