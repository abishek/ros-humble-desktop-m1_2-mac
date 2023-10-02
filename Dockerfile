FROM ros:humble-ros-base-jammy
ARG username
ARG userid
ARG groupid
# This step is required for managing permissions.
RUN useradd --uid $userid --gid $groupid -m $username \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y sudo \
    && echo $username ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$username \
    && chmod 0400 /etc/sudoers.d/$username
# This step is for installing ros dependencies. Add whatever makes sense to you. I need turtlebot3 simulations over gazebo.
# Additionally, we need x11vnc, xvfb and supervisor for managing X sessions. I use twm to keep it simple.
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install python3-pip curl wget bzip2 ros-humble-rmw-cyclonedds-cpp ros-dev-tools ros-humble-nav2-msgs \
                          ros-humble-navigation2 ros-humble-nav2-bringup ros-humble-turtlebot3 ros-humble-gazebo-* \
                          ros-humble-cartographer ros-humble-cartographer-ros x11vnc xvfb supervisor mesa-utils ctwm \
                          xfonts-traditional\
    && apt-get -qq -y autoremove
# Some of the environment will vary depending on your setup.
ENV DISPLAY=:0
ENV SHELL /bin/bash
ENV RMW_IMPLEMENTATION rmw_cyclonedds_cpp
ENV ROS_DOMAIN_ID 1
ENV ROS_LOCALHOST_ONLY 0
RUN echo source /opt/ros/humble/setup.bash >> /home/$username/.bashrc
WORKDIR /home/$username
USER $username
CMD ["/bin/bash"]
