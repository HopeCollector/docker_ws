# docker workspace

1. put a `vscode_data` dir at `docker_things/`

```bash
mkdir docker_things/vscode_data
```

2. renew `.env` file, need .ssh/id_rsa for github's private repo

```bash
echo "USERNAME=$USER
UID=$(id -u)
GID=$(id -g)
HOSTNAME=$HOSTNAME
SSHDIR=$(readlink -f ~/.ssh)" > docker_things/.env
```

3. cd to any `*_ws` and run command blow to create a container.

```bash
docker compose create
```