# TeleBox Docker 部署指南

一份基于 Docker Compose 的 TeleBox 完整部署方案。本方案完美解决了官方仓库缺省 Docker 支持的问题，并适配了国内/香港 VPS 环境，提供稳定的后台常驻能力。

## 📋 前置要求

- 一台 Linux 服务器 (Debian/Ubuntu/CentOS 均可)
- 已安装 Docker 和 Docker Compose
- 一个 Telegram 账号 (建议开启两步验证)

---

## 🚀 快速部署 (一键复制运行)

### 第一步：创建目录与配置文件

请直接在 SSH 终端中执行以下命令块。这将自动创建目录并写入优化的 `Dockerfile` 和 `docker-compose.yml`。

```bash
# 1. 创建并进入目录
mkdir -p ~/telebox && cd ~/telebox

# 2. 写入 Dockerfile (基于 Node.js 20 Alpine)
cat > Dockerfile <<EOF
FROM node:20-alpine
RUN apk add --no-cache git python3 make g++ build-base
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
CMD ["npm", "start"]
EOF
```
```
# 3. 写入 docker-compose.yml
# 注意：首次运行关闭重启策略，以便进行交互登录
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  telebox:
    build: .
    container_name: telebox
    restart: "no"
    volumes:
      - ./my_session:/app/my_session
      - ./plugins:/app/plugins
      - ./assets:/app/assets
      - ./temp:/app/temp
    environment:
      TZ: Asia/Shanghai
    stdin_open: true 
    tty: true
    command: npm start
EOF
```

### 第二步：拉取源码并启动

```bash
# 初始化 Git 并拉取最新代码
git init
git remote add origin https://github.com/TeleBoxDev/TeleBox.git
git fetch origin
git checkout -b main -f origin/main

# 构建镜像并启动容器
docker compose up --build -d
```

---

## 🔑 首次登录 (关键步骤)

TeleBox 首次运行需要交互输入手机号和验证码。

1.  **进入容器交互模式**：
    ```bash
    docker attach telebox
    ```

2.  **按照提示操作**：
    - 输入 API ID 和 Hash (如果需要)
    - 输入手机号 (格式：`+8613800000000`，务必带上国家代码)
    - 输入 Telegram App 收到的验证码
    - 输入两步验证密码 (盲打，屏幕不显示)

3.  **成功后退出**：
    看到 `[Signed in successfully]` 后：
    - 按住 `Ctrl`，点一下 `P`
    - 按住 `Ctrl`，点一下 `Q`
    *(这会保持容器在后台运行并退出交互界面)*

---

## ⚙️ 生产环境配置 (最后一步)

登录成功后，我们需要修改配置，确保 VPS 重启后机器人自动运行。

```bash
# 修改重启策略为 "unless-stopped"
sed -i 's/restart: "no"/restart: unless-stopped/g' docker-compose.yml

# 应用更改 (容器会重启，但因为已有 Session，会自动登录)
docker compose up -d
```

---

## 🛠️ 常用维护命令

| 功能 | 命令 |
| :--- | :--- |
| **查看日志** | `docker compose logs -f` |
| **重启应用** | `docker compose restart` |
| **停止应用** | `docker compose stop` |
| **更新版本** | `git pull && docker compose up --build -d` |
| **重置登录** | `docker compose down && rm -rf my_session && docker compose up -d` |

## ⚠️ 常见问题排查

- **无法输入验证码？**
  确保使用了 `docker attach` 而不是 `docker logs`。
  
- **构建失败？**
  如果提示 git 错误，尝试先清空目录：`rm -rf ~/telebox/*` (慎用，会删除所有数据)。

- **网络连接错误？**
  如果是国内机器，需要在 `docker-compose.yml` 中配置 `HTTPS_PROXY` 环境变量。
# TeleBox Docker 部署指南

一份基于 Docker Compose 的 TeleBox 完整部署方案。本方案完美解决了官方仓库缺省 Docker 支持的问题，并适配了国内/香港 VPS 环境，提供稳定的后台常驻能力。

## 📋 前置要求

- 一台 Linux 服务器 (Debian/Ubuntu/CentOS 均可)
- 已安装 Docker 和 Docker Compose
- 一个 Telegram 账号 (建议开启两步验证)

---

## 🚀 快速部署 (一键复制运行)

### 第一步：创建目录与配置文件

请直接在 SSH 终端中执行以下命令块。这将自动创建目录并写入优化的 `Dockerfile` 和 `docker-compose.yml`。

```bash
# 1. 创建并进入目录
mkdir -p ~/telebox && cd ~/telebox

# 2. 写入 Dockerfile (基于 Node.js 20 Alpine)
cat > Dockerfile <<EOF
FROM node:20-alpine
RUN apk add --no-cache git python3 make g++ build-base
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
CMD ["npm", "start"]
EOF

# 3. 写入 docker-compose.yml
# 注意：首次运行关闭重启策略，以便进行交互登录
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  telebox:
    build: .
    container_name: telebox
    restart: "no"
    volumes:
      - ./my_session:/app/my_session
      - ./plugins:/app/plugins
      - ./assets:/app/assets
      - ./temp:/app/temp
    environment:
      TZ: Asia/Shanghai
    stdin_open: true 
    tty: true
    command: npm start
EOF
```

### 第二步：拉取源码并启动

```bash
# 初始化 Git 并拉取最新代码
git init
git remote add origin https://github.com/TeleBoxDev/TeleBox.git
git fetch origin
git checkout -b main -f origin/main

# 构建镜像并启动容器
docker compose up --build -d
```

---

## 🔑 首次登录 (关键步骤)

TeleBox 首次运行需要交互输入手机号和验证码。

1.  **进入容器交互模式**：
    ```bash
    docker attach telebox
    ```

2.  **按照提示操作**：
    - 输入 API ID 和 Hash (如果需要)
    - 输入手机号 (格式：`+8613800000000`，务必带上国家代码)
    - 输入 Telegram App 收到的验证码
    - 输入两步验证密码 (盲打，屏幕不显示)

3.  **成功后退出**：
    看到 `[Signed in successfully]` 后：
    - 按住 `Ctrl`，点一下 `P`
    - 按住 `Ctrl`，点一下 `Q`
    *(这会保持容器在后台运行并退出交互界面)*

---

## ⚙️ 生产环境配置 (最后一步)

登录成功后，我们需要修改配置，确保 VPS 重启后机器人自动运行。

```bash
# 修改重启策略为 "unless-stopped"
sed -i 's/restart: "no"/restart: unless-stopped/g' docker-compose.yml

# 应用更改 (容器会重启，但因为已有 Session，会自动登录)
docker compose up -d
```

---

## 🛠️ 常用维护命令

| 功能 | 命令 |
| :--- | :--- |
| **查看日志** | `docker compose logs -f` |
| **重启应用** | `docker compose restart` |
| **停止应用** | `docker compose stop` |
| **更新版本** | `git pull && docker compose up --build -d` |
| **重置登录** | `docker compose down && rm -rf my_session && docker compose up -d` |

## ⚠️ 常见问题排查

- **无法输入验证码？**
  确保使用了 `docker attach` 而不是 `docker logs`。
  
- **构建失败？**
  如果提示 git 错误，尝试先清空目录：`rm -rf ~/telebox/*` (慎用，会删除所有数据)。

- **网络连接错误？**# TeleBox Docker 部署指南

一份基于 Docker Compose 的 TeleBox 完整部署方案。本方案完美解决了官方仓库缺省 Docker 支持的问题，并适配了国内/香港 VPS 环境，提供稳定的后台常驻能力。

## 📋 前置要求

- 一台 Linux 服务器 (Debian/Ubuntu/CentOS 均可)
- 已安装 Docker 和 Docker Compose
- 一个 Telegram 账号 (建议开启两步验证)

---

## 🚀 快速部署 (一键复制运行)

### 第一步：创建目录与配置文件

请直接在 SSH 终端中执行以下命令块。这将自动创建目录并写入优化的 `Dockerfile` 和 `docker-compose.yml`。

```bash
# 1. 创建并进入目录
mkdir -p ~/telebox && cd ~/telebox

# 2. 写入 Dockerfile (基于 Node.js 20 Alpine)
cat > Dockerfile <<EOF
FROM node:20-alpine
RUN apk add --no-cache git python3 make g++ build-base
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .
CMD ["npm", "start"]
EOF

# 3. 写入 docker-compose.yml
# 注意：首次运行关闭重启策略，以便进行交互登录
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  telebox:
    build: .
    container_name: telebox
    restart: "no"
    volumes:
      - ./my_session:/app/my_session
      - ./plugins:/app/plugins
      - ./assets:/app/assets
      - ./temp:/app/temp
    environment:
      TZ: Asia/Shanghai
    stdin_open: true 
    tty: true
    command: npm start
EOF
```

### 第二步：拉取源码并启动

```bash
# 初始化 Git 并拉取最新代码
git init
git remote add origin https://github.com/TeleBoxDev/TeleBox.git
git fetch origin
git checkout -b main -f origin/main

# 构建镜像并启动容器
docker compose up --build -d
```

---

## 🔑 首次登录 (关键步骤)

TeleBox 首次运行需要交互输入手机号和验证码。

1.  **进入容器交互模式**：
    ```bash
    docker attach telebox
    ```

2.  **按照提示操作**：
    - 输入 API ID 和 Hash (如果需要)
    - 输入手机号 (格式：`+8613800000000`，务必带上国家代码)
    - 输入 Telegram App 收到的验证码
    - 输入两步验证密码 (盲打，屏幕不显示)

3.  **成功后退出**：
    看到 `[Signed in successfully]` 后：
    - 按住 `Ctrl`，点一下 `P`
    - 按住 `Ctrl`，点一下 `Q`
    *(这会保持容器在后台运行并退出交互界面)*

---

## ⚙️ 生产环境配置 (最后一步)

登录成功后，我们需要修改配置，确保 VPS 重启后机器人自动运行。

```bash
# 修改重启策略为 "unless-stopped"
sed -i 's/restart: "no"/restart: unless-stopped/g' docker-compose.yml

# 应用更改 (容器会重启，但因为已有 Session，会自动登录)
docker compose up -d
```

---

## 🛠️ 常用维护命令

| 功能 | 命令 |
| :--- | :--- |
| **查看日志** | `docker compose logs -f` |
| **重启应用** | `docker compose restart` |
| **停止应用** | `docker compose stop` |
| **更新版本** | `git pull && docker compose up --build -d` |
| **重置登录** | `docker compose down && rm -rf my_session && docker compose up -d` |

## ⚠️ 常见问题排查

- **无法输入验证码？**
  确保使用了 `docker attach` 而不是 `docker logs`。
  
- **构建失败？**
  如果提示 git 错误，尝试先清空目录：`rm -rf ~/telebox/*` (慎用，会删除所有数据)。

- **网络连接错误？**
  如果是国内机器，需要在 `docker-compose.yml` 中配置 `HTTPS_PROXY` 环境变量。


这几行日志显示它 正在连接 Telegram 服务器，但还没连接成功。

注意看最后一行的时间是 17:00:03，而现在已经是 17:15 了。 如果它一直停在 Connecting to Telegram... 超过 1 分钟没有动静，也没有显示 [Signed in successfully]，说明卡住了。

这种情况在网络波动时偶尔会发生。解决方法很简单，重启一下容器让它重新握手即可：
```
bash
docker compose restart
重启后，再查看日志，正常情况应该在 10-20 秒内就会显示 ✅ Login completed。
```
```
bash
docker compose logs -f
  如果是国内机器，需要在 `docker-compose.yml` 中配置 `HTTPS_PROXY` 环境变量。
```
