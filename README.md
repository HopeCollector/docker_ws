# 🚀 Docker 工作空间模板

本模板帮助你快速搭建基于 Docker 的开发环境，适用于 VSCode Remote Container 开发。  
请根据你的实际需求，**务必完成以下自定义配置**后再使用！

---

## 📁 目录结构

```
.
├── compose.yml
├── docker
│   ├── paper.Dockerfile
│   ├── roaf3d.Dockerfile
│   └── utils.sh
├── proj
│   ├── paper
│   └── roaf3d
└── README.md
```

---

## 🛠️ 使用前请务必修改以下内容！

### 1️⃣ `.env` 文件中的环境变量

- 代理设置（`proxy_host`, `proxy_port`）
- 软件源（`apt_src`）
- 用户信息（`uid`, `gid`, `username`）
- 时区（`timezone`）
- 镜像名称（`img_name`）
- x11 转发地址 (`x11_display`)

> ⚠️ **请根据你的实际环境修改 `.env` 文件！**

---

### 2️⃣ `docker/` 目录下的 Dockerfile

- 本项目包含多个服务的 Dockerfile（如 `paper.Dockerfile`, `roaf3d.Dockerfile`）。
- 默认基础镜像为 `osrf/ros:noetic-desktop-full`。
- 如需 CUDA、Ubuntu 等其他环境，请**更换为合适的基础镜像**  
  例如：`nvidia/cuda:12.9.1-cudnn-devel-ubuntu24.04`

---

### 3️⃣ 定制镜像内容

- **直接修改对应的 Dockerfile** 来增删安装的软件包。
- 不再使用 `setup.sh`，请将安装命令直接写在 Dockerfile 的 `RUN` 指令中。
- `docker/utils.sh` 可作为辅助脚本在构建过程中被调用。

---

### 4️⃣ `.devcontainer/devcontainer.json` 容器配置

- 修改 `"name"` 字段，设置容器名称
- 配置 `"extensions"` 和 `"settings"`，自定义 VSCode 容器内的开发体验

---

### 5️⃣ `compose.yml` 文件

- 根据你的开发需求，**调整端口映射、挂载卷、GPU/特权模式等配置**
- 例如：如需使用 GPU、USB 设备或自定义端口，请取消相关注释并按需修改

---

## 🏗️ 构建镜像

完成上述配置后，在项目根目录下运行：

```bash
docker compose build
```

如无报错，说明环境配置无误！

---

## 💻 在 VSCode 中启动开发环境

1. 打开 VSCode，进入命令面板（`Ctrl+Shift+P`）
2. 搜索并选择：  
   **`Remote-Containers: Reopen in Container`**  
   或  
   **`Dev Containers: Reopen in Container`**
3. 等待环境启动，即可在容器内愉快开发！

---

## 🎉 祝你开发顺利！

- 有问题欢迎提 Issue 或自行修改模板
- 多用 🟢🟡🔵🟣 等色彩丰富的 emoji，让开发更有趣！

---

