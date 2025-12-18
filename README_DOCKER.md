# Telegram 多 Bot 管理平台 - Docker 部署指南

## 📦 项目简介

1.支持多个 Telegram Bot 的托管管理平台，提供私聊模式和话题模式两种消息转发方式。

```
ghcr.io/djkyc/tg-talk:latest
```
## 🚀 三步快速部署

| 变量名                | 值                     |
| ------------------ | --------------------- |
| `TG_TOKEN`         | 你的 Telegram bot token |
| `TG_BOT_DATA_DIR`  | `/data`               |
| `PYTHONUNBUFFERED` | `1`                   |
| `MANAGER_TOKEN`    | `管理员bot token`                   |

2.因为你容器里的 default 路径是 /app/data
但 Zeabur 的卷挂载最佳方式是 /data

3.让管理 Bot 和主 Bot 用同一个 TG_TOKEN****


V1.03
但你仍然可以让它们共用同一个 Dockerfile！

区别在于：

✔ 一个 Dockerfile
✔ 两个 Service（Zeabur Deploy 两次）

Service 1（Bot） 使用：dockerfile → CMD ["python", "host_bot.py"]

Service 2（Web） 使用：dockerfile → CMD ["python", "verify_server.py"]

🎯 3. 完整 Zeabur 部署教程（两服务部署）

你的单 Dockerfile 会被 Zeabur 用 两次：

服务 1：Telegram Bot

服务 2：Verify Server（CF Turnstile）
⭐ 详细步骤（超级清晰版）
🚀 A. 部署 Telegram Bot 服务

Zeabur → Add Service → Deploy Container → 输入你的镜像：

ghcr.io/djkyc/tg-talk:1.03

设置环境变量：
TG_TOKEN=xxxxx
MANAGER_TOKEN=xxxxx
CF_TURNSTILE_SITE_KEY=xxxx
CF_TURNSTILE_SECRET_KEY=xxxx
VERIFY_SERVER_URL=https://你的域名/verify
TG_BOT_DATA_DIR=/data

绑定 Volume：

Mount path：data
Container path：/data

Start Command（默认即可）：
python host_bot.py


点击 Deploy

🚀 B. 部署 Verify Server 服务

再 Add Service → 再 Deploy Container → 同样镜像：

ghcr.io/djkyc/tg-talk:1.03


但这次 修改 Start Command：

Start Command:
python verify_server.py

端口设置：

设定 expose 端口：

5000

绑定 Route：
Path: /verify/*
Target: verify-server-service


💯 至此，你的 Zeabur 已成功运行：

Telegram Bot：后台长轮询

Flask Turnstile 验证服务：公网 HTTP

🎯 4. docker-compose（本地运行两个服务）

docker-compose.yml 放在项目根目录即可：

version: "3.9"

services:
  bot:
    build: .
    container_name: tg-talk-bot
    restart: always
    environment:
      TG_TOKEN: ${TG_TOKEN}
      MANAGER_TOKEN: ${MANAGER_TOKEN}
      TG_BOT_DATA_DIR: "/data"
    volumes:
      - ./data:/data

  verify:
    build: .
    container_name: tg-talk-verify
    restart: always
    command: python verify_server.py
    ports:
      - "5000:5000"
    environment:
      CF_TURNSTILE_SITE_KEY: ${CF_TURNSTILE_SITE_KEY}
      CF_TURNSTILE_SECRET_KEY: ${CF_TURNSTILE_SECRET_KEY}
      VERIFY_SERVER_PORT: 5000
      TG_BOT_DATA_DIR: "/data"
    volumes:
      - ./data:/data


运行：

docker compose up -d

🎉 本次交付内容总结：
✔ Dockerfile（1.03）
✔ GitHub Actions（自动构建 + tag 版本）
✔ Zeabur 两服务完整部署流程
✔ docker-compose（本地开发）

所有4项全部完成，马上可用！
