FROM python:3.8-slim-buster

WORKDIR /app
COPY api /app

RUN pip3 install --no-cache-dir -r requirements.txt

RUN python -m textblob.download_corpora && \
    python - <<EOF
import nltk
nltk.download('punkt_tab')
EOF

EXPOSE 5000

CMD ["python", "logic_server.py"]