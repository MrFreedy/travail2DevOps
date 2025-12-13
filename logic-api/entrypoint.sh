#!/bin/sh
set -e

echo "📥 Downloading TextBlob corpora..."
python -m textblob.download_corpora

echo "📥 Downloading missing NLTK resource: punkt_tab"
python - <<EOF
import nltk
nltk.download('punkt_tab')
EOF

echo "✅ Corpora ready, starting API"
exec python logic_server.py