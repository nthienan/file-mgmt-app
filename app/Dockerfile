FROM python:3.11.4-alpine3.18

RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add busybox-extras && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    adduser -D -g apprunner apprunner

WORKDIR /opt/file-mgmt-app
COPY . /opt/file-mgmt-app/app
RUN pip install -r app/requirements.txt && \
    chown -R apprunner:apprunner /opt/file-mgmt-app/app
USER apprunner

ENTRYPOINT ["/opt/file-mgmt-app/app/entrypoint.sh"]
