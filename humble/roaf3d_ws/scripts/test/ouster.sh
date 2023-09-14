#! /usr/bin/bash
source install/setup.bash

rm -rf res

ros2 launch roaf3d run.py cfg_file:=ouster/outdoor.yaml log_level:=info sub_pointcloud2_topic_name:=/ouster/points sub_imu_topic_name:=/ouster/imu &

ros2 bag play data/ousterspin-outdoor-fly2 --qos-profile-overrides-path scripts/ouster.yaml && echo ">>>>>>>  finish  <<<<<<"&

ros2 bag record -o res /tf /out/cld/world /out/path /out/odom