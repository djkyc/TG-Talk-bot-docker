# 1.03 Edition

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 拷贝 Python 脚本 + 模板文件
COPY src/ /app/
COPY src/templates /app/templates

# 环境变量（默认值，可被 Zeabur 覆盖）
ENV PYTHONUNBUFFERED=1 \
    TG_BOT_DATA_DIR=/data \
    VERIFY_SERVER_PORT=5000

# Verify Server 默认监听端口（Zeabur 用）
EXPOSE 5000

# 默认启动 Telegram Bot
CMD ["python", "host_bot.py"]
