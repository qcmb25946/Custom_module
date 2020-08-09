#!/system/bin/sh
MODDIR=${0%/*}
Delete_temperature_control=#sbin#.magisk#modules#Delete_temperature_control
find /system/vendor/ -name '*thermal*' > /sbin/Delete_temperature_control
grep -v "android" /sbin/Delete_temperature_control > /sbin/干温控.sh
sed -i "s/^/mkdir -p $Delete_temperature_control/g" /sbin/干温控.sh
sed -i "s/#/\//g" /sbin/干温控.sh
sh /sbin/干温控.sh
sed -i "s/mkdir -p/rm -rf/g" /sbin/干温控.sh
sh /sbin/干温控.sh
sed -i "s/rm -rf/touch/g" /sbin/干温控.sh
sh /sbin/干温控.sh
rm -rf /sbin/Delete_temperature_control
rm -rf /sbin/干温控.sh
find /sbin/.magisk/modules/Delete_temperature_control/ -name '*thermal*' > /sdcard/温控文件
echo "id=Delete_temperature_control
name=干掉全机型温控v1.31
version=v2020.07.10
versionCode=8
author=千城墨白
description=干就完了" > /sbin/.magisk/modules/Delete_temperature_control/module.prop
#关闭核心温控
echo "echo 0 > /sys/module/msm_thermal/core_control/enabled
echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
echo N > /sys/module/msm_thermal/parameters/enabled
setenforce 0" > /sbin/.magisk/modules/Delete_temperature_control/service.sh