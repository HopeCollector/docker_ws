FROM osrf/ros:noetic-desktop-full-focal
ARG USERNAME
ARG UID
ARG GID

# Create the user
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y sudo
RUN groupadd --gid ${GID} ${USERNAME} \
  && useradd --uid ${UID} --gid ${GID} -m ${USERNAME} \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN apt-get install -y \
  python3-pip \
  git
RUN pip install jupyterlab

USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} bashrc /home/${USERNAME}/.bashrc
RUN mkdir /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace
ENV SHELL=/usr/bin/bash
CMD ["/bin/bash"]