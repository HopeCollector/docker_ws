FROM osrf/ros:noetic-desktop-full-focal
ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG DOCKER_HOST_IP

RUN echo Acquire::http::Proxy \"http://${DOCKER_HOST_IP}:7890\"\; >> /etc/apt/apt.conf \
  && echo Acquire::https::Proxy \"http://${DOCKER_HOST_IP}:7890\"\; >> /etc/apt/apt.conf \
  && export all_proxy=${DOCKER_HOST_IP}:7890 \
  && sh \
  -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
  > /etc/apt/sources.list.d/ros-latest.list' \
  && apt update \
  && apt upgrade -y \
  && apt install -y sudo \
  python3-pip \
  git \
  iputils-ping \
  iproute2 \
  wget \
  curl \
  gdb \
  gdbserver \
  ros-noetic-foxglove-bridge \
  && wget http://packages.ros.org/ros.key -O - | apt-key add - \
  && apt update \
  && apt install -y python3-catkin-tools \
  && groupadd --gid ${USER_GID} ${USERNAME} \
  && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
COPY --chown=${USERNAME}:${USERNAME} bashrc /home/${USERNAME}/.bashrc
RUN mkdir /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace
ENV SHELL=/usr/bin/bash
CMD ["/bin/bash"]