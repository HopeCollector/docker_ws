FROM osrf/ros:noetic-desktop-full-focal
ARG USERNAME
ARG USER_UID
ARG USER_GID

# Create the user
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y sudo
RUN groupadd --gid ${USER_GID} ${USERNAME} \
  && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN apt-get install -y \
  python3-pip \
  # 需要安装一个 ping 来保证 roslaunch 的正常运行
  iputils-ping \
  git \
  wget \
  curl \
  ros-noetic-foxglove-bridge
RUN pip install jupyterlab

USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} bashrc /home/${USERNAME}/.bashrc
RUN mkdir /home/${USERNAME}/workspace
RUN sudo sh \
  -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
  > /etc/apt/sources.list.d/ros-latest.list' \
  && wget http://packages.ros.org/ros.key -O - | sudo apt-key add - \
  && sudo apt update \
  && sudo apt install -y python3-catkin-tools
WORKDIR /home/${USERNAME}/workspace
ENV SHELL=/usr/bin/bash
CMD ["/bin/bash"]