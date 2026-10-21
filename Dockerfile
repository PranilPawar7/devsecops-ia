
FROM python:3.12-alpine

WORKDIR /app

# Apply available Alpine package updates
RUN apk upgrade --no-cache

COPY requirements.txt .

RUN python -m pip install --no-cache-dir --upgrade \
    pip \
    "setuptools>=78.1.1" \
    "urllib3>=2.8.0" \
    "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt

RUN adduser -D -u 10001 appuser

COPY --chown=appuser:appuser app/ ./app/

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)" || exit 1

CMD ["python", "-m", "app"]
