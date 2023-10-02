# ROS Humble Desktop for M1/M2 Macs

I have been trying to get a ROS setup working on my M1 Mac for a while. While getting ROS to work itself it pretty straightforward, I need `gazebo` simulations and rviz to work fine as well. `rviz2` doesn't quite work well over Xquartz either.
For whatever reasons, UTM `x86_64` doesn't work as well as I want it to on the M1 mac either. I could be missing something here though. So as a result of these failed attempts, I decided to get a docker based setup to work. I hunt down half a dozen github issues and blogs while arriving at this configuration that works for me. Hopefully, this can help you out as well.

The key reasons to do this are follows:

- repeatability and predictable results each time
- ability to run gazebo and rviz GUI interfaces
- ability to run x86_64 images on the M1/M2 mac reliably.

## Issues with X11 and M1/M2 Macs

I initially used this gist: https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285 to setup Xquartz based setup. However, Xquartz is unable to support rviz2. The relevant discussions are here:

- https://github.com/XQuartz/XQuartz/issues/144
- https://github.com/ros2/rviz/issues/929

## Inspiration (read: copied from)

https://github.com/bwingo47/docker_envs/tree/mac_arm_dev/mac_env


## Build

We need the following mandatory arguments to build the image. 
- username: this maps to the current user in the mac. the name is not mandatory to be the same, but it keeps it simple.
- userid: the user id of the current user in the mac. this is to ensure mounted file permissions remain sane
- grouid: the group id of the current group in the mac. I am defaulting to `staff` group. You can choose differently.

To find the username, do this
``` shell
whoami
```

To find the userid, do this

``` shell
id -u <username>
```

To find the group id, do this
``` shell
id -G <username>
```
and select the first one. Of course, you might need to choose differently, assuming you know how these things eventually work.

``` shell
docker buildx build --platform linux/amd64 -t ros-humble-desktop:latest --build-arg username=<username> --build-arg userid=<userid> --build-arg groupid=<groupid> .
```

## Run

``` shell
docker run --platform linux/amd64 --rm -v $(pwd)/supervisor-conf-d:/etc/supervisor/conf.d -p 5900:5900  -it ros-humble-desktop:latest
```

Once the docker shell opens, run `ctwm &` to start the desktop. Of course, replace this with other appropriate window manager commands.

Once started, you can use a VNC client to connect to the running X11 display. I used `tigervnc` to do this. On the mac, you can `brew install tigervnc-viewer` to get the client. Since X11Vnc is started without a password, some generic VNC clients may not work. TigerVNC supports connecting without a password. Of course, we can easily modify the supervisor scripts to start X11VNC with a password and then get the system to work reliably with all VNC clients.

## Known Issues

`cyclonedds` has issues with this setup. Refer to

- https://github.com/sea-bass/turtlebot3_behavior_demos/issues/37
- https://github.com/ros2/rmw_cyclonedds/issues/273

for details.
