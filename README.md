# ROS Humble Desktop for M1/M2 Macs

I have been trying to get a ROS setup working on my M1 Mac for a while. While getting ROS to work itself it pretty straightforward, I need `gazebo` simulations and rviz to work fine as well. `rviz2` doesn't quite work well over Xquartz either.
For whatever reasons, UTM `x86_64` doesn't work as well as I want it to on the M1 mac either. I could be missing something here though. So as a result of these failed attempts, I decided to get a docker based setup to work. I hunt down half a dozen github issues and blogs while arriving at this configuration that works for me. Hopefully, this can help you out as well.

## Build

``` shell
docker buildx build --platform linux/amd64 -t ros-humble-desktop:latest --build-arg username=abishek --build-arg userid=501 --build-arg groupid=20 .
```

## Run


