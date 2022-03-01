#!/bin/bash
#
# Provide the Docker environment for ASUS IoT.

declare -r ASUS_DOCKER_ENV_DEFAULT_WORKDIR="/source"

export ASUS_DOCKER_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ASUS_DOCKER_ENV_SOURCE="${ASUS_DOCKER_ENV_DIR}"
export ASUS_DOCKER_ENV_DOCKERFILE="${ASUS_DOCKER_ENV_DIR}/Dockerfile"
export ASUS_DOCKER_ENV_IMAGE="asus-iot/asus-docker-env-linux4.4-rk3288-tinker_board:latest"
export ASUS_DOCKER_ENV_WORKDIR=${ASUS_DOCKER_ENV_DEFAULT_WORKDIR}

function asus_docker_env_show_variables() {
  echo "====================================================================="
  echo "ASUS_DOCKER_ENV_DIR=${ASUS_DOCKER_ENV_DIR}"
  echo "ASUS_DOCKER_ENV_SOURCE=${ASUS_DOCKER_ENV_SOURCE}"
  echo "ASUS_DOCKER_ENV_DOCKERFILE=${ASUS_DOCKER_ENV_DOCKERFILE}"
  echo "ASUS_DOCKER_ENV_IMAGE=${ASUS_DOCKER_ENV_IMAGE}"
  echo "ASUS_DOCKER_ENV_WORKDIR=${ASUS_DOCKER_ENV_WORKDIR}"
  echo "====================================================================="
}

function asus_docker_env_check_docker() {
  if [[ -x "$(command -v docker)" ]]; then
    echo "Docker is installed and the execute permission is granted."
    if getent group docker | grep &>/dev/null "\b$(id -un)\b"; then
      echo "User $(id -un) is in the group docker."
      return 0
    else
      echo "Docker is not managed as a non-root user."
      echo "Please refer to the following URL to manage Docker as a non-root user."
      echo "https://docs.docker.com/install/linux/linux-postinstall/"
    fi
  else
    echo "Docker is not installed or the execute permission is not granted."
    echo "Please install Docker first aned make sure you are able to run it."
  fi
  return 1
}

function asus_docker_env_check_required_packages {
  if dpkg-query -s qemu-user-static 1>/dev/null 2>&1; then
    echo "The package qemu-user-static is installed."
  else
    echo "The package qemu-user-static is not installed yet. Please install it first."
    return 1
  fi

  if dpkg-query -s binfmt-support 1>/dev/null 2>&1; then
    echo "The package binfmt-support is installed."
  else
    echo "The package binfmt-support is not installed yet. Please install it first."
    return 1
  fi
  return 0
}

# Check to see if all the prerequisites are fullfilled.
function asus_docker_env_check_prerequisites() {
  if [[ ! -d ${ASUS_DOCKER_ENV_DIR} ]]; then
    echo "The directory [${ASUS_DOCKER_ENV_DIR}] for the ASUS Docker environment is not found."
    return 1
  fi

  if [[ ! -d ${ASUS_DOCKER_ENV_SOURCE} ]]; then
    echo "The source directory [${ASUS_DOCKER_ENV_SOURCE}] for the ASUS Docker environment is not found."
    return 1
  fi

  if [[ ! -f ${ASUS_DOCKER_ENV_DOCKERFILE} ]]; then
    echo "Dockerfile [${ASUS_DOCKER_ENV_DOCKERFILE}] for the ASUS Docker environment is not found."
    return 1
  fi

  if ! asus_docker_env_check_docker; then
    return 1
  fi

  if ! asus_docker_env_check_required_packages; then
    return 1
  fi

  return 0
}

function asus_docker_env_build_docker_image() {
  if asus_docker_env_check_prerequisites; then
    docker build --tag $ASUS_DOCKER_ENV_IMAGE --file $ASUS_DOCKER_ENV_DOCKERFILE $ASUS_DOCKER_ENV_DIR
  fi
}

function asus_docker_env_run() {
  echo "Entering the ASUS Docker environment......."
  asus_docker_env_show_variables
  if [[ "$ASUS_DOCKER_ENV_WORKDIR" != "$ASUS_DOCKER_ENV_DEFAULT_WORKDIR" ]]; then
    echo "Create the symbolic link $ASUS_DOCKER_ENV_WORKDIR to $ASUS_DOCKER_ENV_SOURCE......."
    ln -s $ASUS_DOCKER_ENV_SOURCE $ASUS_DOCKER_ENV_WORKDIR
  fi
  if asus_docker_env_check_prerequisites; then
    asus_docker_env_build_docker_image
    if [ $# -eq 0 ]; then
      docker run --interactive --privileged --rm --tty \
        --hostname asus-docker-env \
        --volume $ASUS_DOCKER_ENV_SOURCE:$ASUS_DOCKER_ENV_WORKDIR \
        --workdir $ASUS_DOCKER_ENV_WORKDIR \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        --volume /var/lib/docker:/var/lib/docker \
        $ASUS_DOCKER_ENV_IMAGE /bin/bash -c \
        "groupadd --gid $(id -g) $(id -g -n); \
        useradd -m -e \"\" -s /bin/bash --gid $(id -g) --uid $(id -u) $(id -u -n); \
        passwd -d $(id -u -n); \
        echo \"$(id -u -n) ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers; \
        sudo groupmod -g $(awk -F\: '/docker/ {print $3}' /etc/group) docker; \
        sudo usermod -aG docker $(id -u -n); \
        sudo -E -u $(id -u -n) --set-home /bin/bash -i"
    else
      docker run --interactive --privileged --rm --tty \
        --hostname asus-docker-env \
        --volume $ASUS_DOCKER_ENV_SOURCE:$ASUS_DOCKER_ENV_WORKDIR \
        --workdir $ASUS_DOCKER_ENV_WORKDIR \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        --volume /var/lib/docker:/var/lib/docker \
        $ASUS_DOCKER_ENV_IMAGE /bin/bash -c \
        "groupadd --gid $(id -g) $(id -g -n); \
        useradd -m -e \"\" -s /bin/bash --gid $(id -g) --uid $(id -u) $(id -u -n); \
        passwd -d $(id -u -n); \
        echo \"$(id -u -n) ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers; \
        sudo groupmod -g $(awk -F\: '/docker/ {print $3}' /etc/group) docker; \
        sudo usermod -aG docker $(id -u -n); \
        sudo -E -u $(id -u -n) --set-home ${1}"
    fi
  fi
  if [[ "$ASUS_DOCKER_ENV_WORKDIR" != "$ASUS_DOCKER_ENV_DEFAULT_WORKDIR" ]]; then
    echo "Remove the symbolic link $ASUS_DOCKER_ENV_WORKDIR......."
    unlink $ASUS_DOCKER_ENV_WORKDIR
  fi

  echo "Leaving the ASUS Docker environment......."
}

function asus_docker_env_set_dockerfile() {
  if [ $# -eq 0 ]; then
    echo "Please provide the Dockerfile path."
  else
    export ASUS_DOCKER_ENV_DOCKERFILE="$(readlink -f ${1})"
    asus_docker_env_show_variables
  fi
}

function asus_docker_env_set_source() {
  if [ $# -eq 0 ]; then
    echo "Please provide the source path."
  else
    export ASUS_DOCKER_ENV_SOURCE="$(readlink -f ${1})"
    export ASUS_DOCKER_ENV_WORKDIR=${ASUS_DOCKER_ENV_DEFAULT_WORKDIR}
    asus_docker_env_show_variables
  fi
}

function asus_docker_env_set_source_with_symbolic_link() {
  if [ $# -eq 0 ]; then
    echo "Please provide the source path."
  else
    export ASUS_DOCKER_ENV_SOURCE="$(readlink -f ${1})"
    export ASUS_DOCKER_ENV_WORKDIR=`echo ${ASUS_DOCKER_ENV_SOURCE} | md5sum | cut -f1 -d" "`
    export ASUS_DOCKER_ENV_WORKDIR="/tmp/${ASUS_DOCKER_ENV_WORKDIR}"
    asus_docker_env_show_variables
  fi
}

function main() {
  asus_docker_env_show_variables
  asus_docker_env_check_prerequisites
}

main "$@"
