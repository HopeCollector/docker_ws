# oradar_ws

用于开发 oradar 旋转激光雷达，需要两个设备文件才能正常构建容器

```bash
sudo chmod a+rw /dev/ttyUSB0 # 电机设备
sudo chmod a+rw /dev/ttyUSB1 # 激光设备
```