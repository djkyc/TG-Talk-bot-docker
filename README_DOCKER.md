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
