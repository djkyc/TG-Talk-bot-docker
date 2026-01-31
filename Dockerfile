# 使用 Node.js 20 Alpine 作为基础镜像
FROM node:20-alpine

# 安装基础运行工具
RUN apk add --no-cache git python3 make g++ build-base

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 lock 文件 (如果有)
COPY package.json ./

# 安装依赖
RUN npm install

# 复制项目所有文件
COPY . .

# 复制入口脚本
COPY docker-entrypoint.js ./

# 设置入口点
ENTRYPOINT ["node", "docker-entrypoint.js"]

# 默认启动命令 (会作为参数传给 ENTRYPOINT)
CMD ["npm", "start"]
