
FROM python:3.12-slim

WORKDIR /app

# Update operating-system packages
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Install updated pip and application dependencies
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade pip setuptools urllib3 msgpack \
    && python -m pip install --no-cache-dir -r requirements.txt

# Create a non-root user
RUN useradd --create-home --uid 10001 appuser

COPY --chown=appuser:appuser app/ ./app/

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)" || exit 1

CMD ["python", "-m", "app"]
