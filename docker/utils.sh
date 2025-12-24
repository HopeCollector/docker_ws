# ============================================================================
# Docker 构建脚本工具库
# ============================================================================
# 
# 此脚本提供了用于 Docker 镜像构建的通用工具函数，包括：
#
# 【安装函数】
#   - install_deb()             : 安装 apt 软件包，支持重试机制
#
# 【系统配置函数】
#   - cleanup_system()      : 清理 apt 缓存和临时文件
#   - setup_user()          : 创建新用户并配置权限和工作空间
# ============================================================================

# apt 安装的最大重试次数
readonly MAX_RETRIES=5

# ============================================================================
# 日志函数
# ============================================================================

# 打印信息日志
log_info() {
    echo "[INFO] $*" >&2
}

# 打印错误日志
log_error() {
    echo "[ERROR] $*" >&2
}

# 打印调试日志
log_debug() {
    if [[ "${DEBUG:-}" == "1" ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# ============================================================================
# 安装函数
# ============================================================================

# 安装软件包的函数
install_deb() {
    local RETRY_COUNT=0
    # 安装包的循环
    until [ $RETRY_COUNT -ge $MAX_RETRIES ]; do
        if apt update && apt install -y "$@"; then
            break
        else
            RETRY_COUNT=$((RETRY_COUNT+1))
            log_error "Installation failed, retrying $RETRY_COUNT/$MAX_RETRIES..."
            sleep 5
        fi
    done

    # 如果超过最大重试次数，退出
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        log_error "The maximum number of retries was reached, and the installation failed"
        exit 1
    fi
}

# ============================================================================
# 系统配置函数
# ============================================================================

# 清理系统缓存
cleanup_system() {
    log_info "Cleaning up system..."
    apt-get -y autoremove
    apt-get clean autoclean
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*
    log_info "System cleanup completed"
}

# 用户管理函数
setup_user() {
    log_info "Setting up user..."
    
    # 移除默认用户
    if id "ubuntu" &>/dev/null; then
        touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu
        userdel -r ubuntu
    fi

    # 创建新用户
    groupadd --gid $GID $USERNAME
    useradd --uid ${UID} --gid ${GID} --create-home ${USERNAME}
    echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME}
    chmod 0440 /etc/sudoers.d/${USERNAME}
    mkdir -p /home/${USERNAME}
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

    log_info "User setup completed"
}
