# asus-docker-env

You can setup your environment by running this:

    $ source setup.sh

The default Dockerfile is from ubuntu:20.04 (./focal/Dockerfile). You can use the following command to change to another one such as ./xenial/Dockerfile.

    $ asus_docker_env_set_dockerfile ./xenial/Dockerfile

The default source path is same as where the script setup.sh is. You can use the following command to change to another one .

    $ asus_docker_env_set_source PATH_TO_YOUR_SOURCE

Now, you can use the following command to run ASUS Docker environment with shell. 

    $ asus_docker_env_run
