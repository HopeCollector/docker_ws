FROM osrf/ros:humble-desktop-full-jammy
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
  git \
  iputils-ping \
  wget \
  curl \
  gdb \
  gdbserver \
  ros-humble-foxglove-bridge
RUN pip install jupyterlab

USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} bashrc /home/${USERNAME}/.bashrc
RUN mkdir /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace
ENV SHELL=/usr/bin/bash
CMD ["/bin/bash"]