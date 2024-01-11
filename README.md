# docker workspace

保存了常用开发环境的配置

## 文件结构

- humble: 提供了 ros2-humble 常用的开发工具并加入了一个与宿主机用户相同的用户用于保证文件的所有权不出问题
- noetic: 提供了 ros2-noetic 常用的开发工具并加入了一个与宿主机用户相同的用户用于保证文件的所有权不出问题
- containers: 不同开发环境的容器配置文件，开发时可以直接将源代码放在 src 文件夹目录下，然后修改 compose 文件来调整挂载方式

## compose 文件组织方式

所有 compose 文件通过 [`extends`](https://docs.docker.com/compose/multiple-compose-files/extends/) 级联在一起，
只需在 containers 中的任何一个 _ws 文件夹内调用  `docker compose create` 即可生成对应的容器


## 使用方式

1. 首先要创建给容器使用的网络环境

```base
docker network create ros_bridge_network
```

2. 更新 `.env` 文件

```bash
echo "USERNAME=$USER
USER_UID=$(id -u)
USER_GID=$(id -g)
USER_HOSTNAME=$HOSTNAME
SSHDIR=$(readlink -f ~/.ssh)
DOCKER_HOST_IP=$(docker network inspect ros_bridge_network -f \
 '{{range .IPAM.Config}}{{.Gateway}}{{end}}')" > <path to workspace>/.env
```