#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 此脚本将在post-fs-data模式下执行
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
version=v2020.07.09
versionCode=8
author=千城墨白
description=干就完了" > /sbin/.magisk/modules/Delete_temperature_control/module.prop
echo "set_value 0 /sys/module/msm_thermal/core_control/enabled
echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
set_value N /sys/module/msm_thermal/parameters/enabled
setenforce 0" > /sbin/.magisk/modules/Delete_temperature_control/service.sh