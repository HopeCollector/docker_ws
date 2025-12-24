# ============================================================================
# 基础环境设置
# ============================================================================
FROM ubuntu:24.04 AS base

# 设置默认 shell 为 bash
SHELL ["/bin/bash", "-c"]

ARG TZ=Asia/Shanghai
ENV TZ=${TZ}

# 更换为国内源
ARG UBUNTU_REPO
ARG ARCHIVE_UBUNTU_REPO=${UBUNTU_REPO:-"archive.ubuntu.com"}
ARG SECURITY_UBUNTU_REPO=${UBUNTU_REPO:-"security.ubuntu.com"}

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# 复制工具函数
COPY ./docker/utils.sh /tmp/utils.sh

# 换源
RUN sed -i "s/archive.ubuntu.com/$ARCHIVE_UBUNTU_REPO/g" /etc/apt/sources.list.d/ubuntu.sources \
    && sed -i "s/security.ubuntu.com/$SECURITY_UBUNTU_REPO/g" /etc/apt/sources.list.d/ubuntu.sources \
    && apt update

# 安装基础工具
RUN source /tmp/utils.sh \
    && install_deb \
        sudo \
        curl \
        wget \
        git \
        texlive-full \
        fonts-wqy*
# ============================================================================
# 叠加环境设置
# ============================================================================
FROM base AS overlay

ARG USERNAME=user
ARG UID=1000
ARG GID=${UID}

# 额外安装的包
RUN source /tmp/utils.sh \
    && install_deb \
        python3-venv \
    && install_deb --no-install-recommends \
        libegl1 \
        libgl1 \
        libgomp1

# 安装 pandoc
WORKDIR /tmp
RUN curl -LO https://github.com/jgm/pandoc/releases/download/3.8/pandoc-3.8-1-amd64.deb \
    && source /tmp/utils.sh \
    && install_deb ./pandoc-3.8-1-amd64.deb

# 用户创建和基础配置
RUN source /tmp/utils.sh \
    && setup_user \
    && mkdir -p /ws/share \
    && chown -R ${USERNAME}:${USERNAME} /ws

# ============================================================================
# 用户配置层
# ============================================================================
FROM overlay AS user

# 安装 uv
USER ${USERNAME}
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# 清理临时文件
USER root
RUN source /tmp/utils.sh \
    && cleanup_system

# 恢复 apt 为普通模式
ENV DEBIAN_FRONTEND=newt
ENV DEBCONF_NONINTERACTIVE_SEEN=false

# 配置默认用户
USER ${USERNAME}
WORKDIR /ws

