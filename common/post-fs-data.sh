#!/system/bin/sh
MODDIR=${0%/*}
Delete_temperature_control=#data#adb#modules#Delete_temperature_control
find /system/ -name '*thermal*' > /data/Delete_temperature_control
find /system/vendor/ -name '*thermal*' >> /data/Delete_temperature_control
echo "/system/vendor/etc/perf/perfboostsconfig.xml" >> /data/Delete_temperature_control
#                                        " rog卡桌面 "           "                    lg不能快充           "
cat /data/Delete_temperature_control|grep -v '.so'|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v "/vendor/bin/thermal-engine" > /data/干温控.sh
sed -i "s/^/mkdir -p $Delete_temperature_control/g" /data/干温控.sh
sed -i "s/#/\//g" /data/干温控.sh
sh /data/干温控.sh
sed -i "s/mkdir -p/rm -rf/g" /data/干温控.sh
sh /data/干温控.sh
sed -i "s/rm -rf/touch/g" /data/干温控.sh
sh /data/干温控.sh
rm -rf /data/Delete_temperature_control
rm -rf /data/干温控.sh
echo "id=Delete_temperature_control
name=干掉全机型温控v1.40
version=v2020.07.14
versionCode=8
author=千城墨白
description=这是自定义温控模块的文件代码自定义生成的。根据不同机型去生成不同的空温控文件，来顶替原温控文件。删除改模块重启会还原温控，但自定义模块将不运行" > /data/adb/modules/Delete_temperature_control/module.prop
#关闭核心温控
echo "echo 0 > /sys/module/msm_thermal/core_control/enabled
echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
echo N > /sys/module/msm_thermal/parameters/enabled
rm -rf /data/vendor/thermal
setenforce 0" > /data/adb/modules/Delete_temperature_control/service.sh