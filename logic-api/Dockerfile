FROM python:3.8-slim-buster

COPY api /app
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5000
ENTRYPOINT ["/entrypoint.sh"]