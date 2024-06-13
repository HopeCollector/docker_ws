#! /usr/bin/env python3

import os
import subprocess


def run(command: list[str]) -> str:
    process = subprocess.run(command, stdout=subprocess.PIPE)
    return process.stdout.decode().strip()


def make_proxy(ip: str) -> dict[str, str]:
    envs = run(["env"]).split("\n")
    proxys = {}
    for env in envs:
        key, value = env.split("=")[:2]
        key = key.upper()
        if "PROXY" in key and "NO" not in key and key not in proxys and len(value) > 0:
            proxys[f"DKR_{key}"] = value
    for key, value in proxys.items():
        if "localhost" in value:
            proxys[key] = value.replace("localhost", ip)
        elif "127.0.0.1" in value:
            proxys[key] = value.replace("127.0.0.1", ip)
    return proxys


def read(prompt: str = "", default: str = "") -> str:
    ret = input(prompt).strip()
    if len(ret) == 0:
        ret = default
    return ret


pwd = os.path.basename(os.getcwd())
container_host_name = read(
    f"Enter the container's host name (default: {pwd}-container): ", f"{pwd}-container"
)
network_name = read("Enter the network name (default: bridge): ", "bridge")
display = os.getenv("DISPLAY")
if display is None:
    print("DISPLAY environment variable not set")
    display = read("Enter the display (default: :0): ", ":0")
proxy = make_proxy(
    run(
        [
            "docker",
            "network",
            "inspect",
            network_name,
            "-f",
            "{{range .IPAM.Config}}{{.Gateway}}{{end}}",
        ]
    )
)

env_file = {
    "DKR_DISPLAY": display,
    "DKR_NAME": container_host_name,
    "DKR_UID": run(["id", "-u"]),
    "DKR_GID": run(["id", "-g"]),
}

env_file.update(proxy)

with open(".env", "w") as f:
    for key, value in env_file.items():
        f.write(f"{key}={value}\n")
        print(f"{key}={value}")
