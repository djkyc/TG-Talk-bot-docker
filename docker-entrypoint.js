const fs = require('fs');
const { spawn } = require('child_process');
const path = require('path');

const CONFIG_PATH = path.join(process.cwd(), 'config.json');

// 检查环境变量 (支持 TB_ 前缀或无前缀)
const sessionString = process.env.TB_SESSION_STRING || process.env.SESSION_STRING;
const apiId = process.env.TB_API_ID || process.env.API_ID;
const apiHash = process.env.TB_API_HASH || process.env.API_HASH;

// 如果环境变量存在，则自动生成配置文件
if (sessionString && apiId && apiHash) {
    console.log('[Entrypoint] 检测到环境变量配置，正在生成 config.json...');
    const config = {
        api_id: parseInt(apiId),
        api_hash: apiHash,
        session: sessionString,
        connectionRetries: 5
    };
    try {
        fs.writeFileSync(CONFIG_PATH, JSON.stringify(config, null, 2));
        console.log('[Entrypoint] ✅ config.json 生成成功 (Cloud-Native Mode)');
    } catch (err) {
        console.error('[Entrypoint] ❌ 生成配置文件失败:', err);
    }
} else {
    console.log('[Entrypoint] 未检测到完整环境变量，使用本地 config.json 或交互模式');
}

// 执行原始命令 (默认为 npm start)
const args = process.argv.slice(2);
const command = args.length > 0 ? args[0] : 'npm';
const commandArgs = args.length > 0 ? args.slice(1) : ['start'];

console.log(`[Entrypoint] 启动主进程: ${command} ${commandArgs.join(' ')}`);

const child = spawn(command, commandArgs, { stdio: 'inherit' });

child.于('close'， (code) => {
    process.exit(code);
});

// 处理信号传递
process.on('SIGTERM', () => child.kill('SIGTERM'));
process.于('SIGINT', () => child.kill('SIGINT'));
