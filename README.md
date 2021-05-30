# asus-docker-env

You can setup your environment by running this:

    $ source setup.sh

The default Dockerfile is from ubuntu:20.04 (./focal/Dockerfile). You can use the following command to change to another one such as ./xenial/Dockerfile.

    $ asus_docker_env_set_dockerfile ./xenial/Dockerfile

The default source path is same as where the script setup.sh is. You can use the following command to change to another one .

    $ asus_docker_env_set_source PATH_TO_YOUR_SOURCE

If you need exactly the same path both in the Docker and the host environments such as building balenaOS, you can use the following command to set the source path. A temporary symbolic link will be created as the working directory for the container based on the md5sum from the source path you provide.

    $ asus_docker_env_set_source_with_symbolic_link PATH_TO_YOUR_SOURCE

Now, you can use the following command to run ASUS Docker environment with shell. 

    $ asus_docker_env_run

You can also use the following command to execute the commands directly in the ASUS Docker environment. 

    $ asus_docker_env_run "commands"
