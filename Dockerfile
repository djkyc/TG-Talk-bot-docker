FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/
COPY src/templates /app/templates

ENV PYTHONUNBUFFERED=1 \
    TG_BOT_DATA_DIR=/data \
    VERIFY_SERVER_PORT=5000

EXPOSE 5000

CMD ["python", "host_bot.py"]   # 默认启动 bot
