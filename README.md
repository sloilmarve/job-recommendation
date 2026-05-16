# AI 招聘推荐系统

这是一个完整的 AI 全栈项目示例，包含后端 FastAPI 服务和前端 React + Vite 应用。项目支持候选人简历与岗位信息录入，并生成匹配推荐结果。

## 目录结构

- `backend/`：FastAPI 后端服务，包含数据库与推荐算法
- `frontend/`：React + Vite 前端界面

## 运行步骤

### 1. 后端

1. 进入后端目录：
   ```powershell
   cd backend
   ```
2. 安装 Python 依赖：
   ```powershell
   python -m pip install -r requirements.txt
   ```
3. 复制环境变量文件并填写 `OPENAI_API_KEY`（可选）：
   ```powershell
   copy .env.example .env
   ```
4. 启动后端服务：
   ```powershell
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

> 如果没有配置 OpenAI API Key，系统仍会使用关键词匹配作为推荐降级方案。

### 2. 前端

1. 进入前端目录：
   ```powershell
   cd ../frontend
   ```
2. 安装 Node 依赖：
   ```powershell
   npm install
   ```
3. 启动前端开发服务器：
   ```powershell
   npm run dev
   ```

### 3. 使用说明

- 在前端页面创建职位与候选人
- 选择候选人后点击“生成推荐”
- 系统会展示最匹配的岗位结果

## Docker 启动命令

项目根目录提供一个方便的 PowerShell 脚本，用于直接构建并启动网站：

```powershell
cd d:\vscode\project1
.\run-docker.ps1
```

该命令会执行：

```powershell
docker compose up --build
```

## 云服务器部署

你可以把项目部署到任意支持 Docker 的云服务器（例如 VPS、Azure Linux VM、AWS EC2、DigitalOcean Droplet 等）。

### 1. 上传代码到服务器

在服务器上执行：

```bash
git clone <你的仓库地址> project1
cd project1
```

### 2. 安装 Docker 与 Docker Compose

- Ubuntu/Debian:
  ```bash
  sudo apt update
  sudo apt install -y docker.io docker-compose
  sudo systemctl enable --now docker
  ```
- 或使用 Docker 官方安装方式

### 3. 设置环境变量

复制环境文件并填写 `OPENAI_API_KEY`（可选）：

```bash
cp .env.example .env
nano .env
```

### 4. 运行云端部署脚本

```bash
chmod +x deploy-cloud.sh
./deploy-cloud.sh
```

### 4.1 使用本地远程部署脚本

如果你想从本地机器直接部署到远程云服务器，可以使用新增的脚本：

- Linux/macOS 本地机：
  ```bash
  chmod +x deploy-remote.sh
  ./deploy-remote.sh user@server.example.com git@github.com:yourname/project1.git ~/project1
  ```
- Windows 本地机：
  ```powershell
  .\deploy-remote.ps1 -Remote user@server.example.com -RepoUrl git@github.com:yourname/project1.git -DeployDir ~/project1
  ```

脚本会在远程服务器上执行以下操作：

- 克隆或更新仓库
- 如果尚未存在，则复制 `.env.example` 为 `.env`
- 构建并启动 Docker Compose 服务

### 5. 开放端口

确保服务器防火墙允许访问以下端口：

- `4173`：前端网站
- `8000`：后端 API

### 6. 访问网站

在浏览器里访问：

```text
http://<服务器公网IP>:4173
```

后端健康检查：

```text
http://<服务器公网IP>:8000/health
```

## 技术栈

- 后端：Python, FastAPI, SQLModel, SQLite
- AI：OpenAI Embeddings（可选），关键词匹配退化方案
- 前端：React + TypeScript + Vite
- 数据存储：本地 SQLite

## Docker 部署

1. 复制根目录环境文件：
   ```powershell
   copy .env.example .env
   ```
2. 填写 `.env` 中的 `OPENAI_API_KEY`（如果使用 OpenAI Embeddings）
3. 启动 Docker Compose：
   ```powershell
   docker compose up --build
   ```
4. 访问服务：
   - 前端：`http://localhost:4173`
   - 后端：`http://localhost:8000`

> `frontend` 服务会将构建产物以静态站点方式暴露在端口 `4173`，`backend` 服务则运行 FastAPI。