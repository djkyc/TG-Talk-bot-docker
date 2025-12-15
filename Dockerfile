FROM python:3.11-slim

WORKDIR /app

# 基础依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 包
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制 src 目录到容器
COPY src/ /app/

# 创建数据目录
RUN mkdir -p /app/data

ENV TG_BOT_DATA_DIR=/app/data \
    PYTHONUNBUFFERED=1

CMD ["python", "host_bot.py"]
