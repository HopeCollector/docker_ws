# docker workspace

这是一个模板仓库，用于配合 vscode 的 Dev Container 插件在容器内开发

## 使用方式

1. 基于模板创建新的仓库
2. 克隆项目到本地
3. 根据项目需要新建网络如 `ros_bridge`

```base
docker network create ros_bridge
```

4. 更新 `.env` 文件

```bash
./update_env.py
```

5. 修改 `Dockerfile`
    - 基础镜像
    - 预安装的包

6. 修改 `compose.yml`
    - 服务名称
    - 镜像名称
    - 是否使用 nvidia gpu
        - `runtime`
        - `enviroment.NVIDIA_VISIBLE_DEVICES`
        - `enviroment.NVIDIA_DRIVER_CAPABILITIES`
    - 需要加入的网络的名称
    - 额外挂载的目录 **不需要挂载当前目录，vscode 默认会挂载当前目录的上一级，包含当前目录**
    - 额外需要访问的硬件设备
    - 是否需要特权模式 `privileged`
    - 配置 `networks`
7. 在 vscode 中打开项目
8. 按 `F1` 搜索 `reopen in container`
    - 将配置添加到项目本地
    - 使用 `compose.yml` 构造容器
    - 按需添加 feature 
