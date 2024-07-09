FROM osrf/ros:humble-desktop-full AS pkg_setup

ARG DKR_ALL_PROXY
ARG DKR_HTTP_PROXY
ARG DKR_HTTPS_PROXY

RUN export all_proxy=$DKR_ALL_PROXY && \
    export http_proxy=$DKR_HTTP_PROXY && \
    export https_proxy=$DKR_HTTPS_PROXY && \
    export ALL_PROXY=$DKR_ALL_PROXY && \
    export HTTP_PROXY=$DKR_HTTP_PROXY && \
    export HTTPS_PROXY=$DKR_HTTPS_PROXY


RUN while ! apt update; \
    do echo "apt update has failed... Waiting before next try"; \
    sleep 1; done

RUN while ! apt upgrade -y; \
    do echo "apt upgrade has failed... Waiting before next try"; \
    sleep 1; done

RUN while ! apt install -y \
    git \
    iproute2 \
    iputils-ping \
    nano \
    python3-pip \
    x11-apps \
    curl \
    ros-humble-mavros* \
    ros-humble-foxglove*; \
    do echo "apt install has failed... Waiting before next try"; \
    sleep 1; done


FROM pkg_setup AS user_setup

ARG USER
ARG DKR_UID="1000"
ARG DKR_GID="1000"

RUN groupadd --gid ${DKR_GID} ${USER} && \
    useradd --uid ${DKR_UID} --gid ${DKR_GID} -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}

RUN git config --global http.proxy $DKR_HTTP_PROXY && \
    git config --global https.proxy $DKR_HTTPS_PROXY