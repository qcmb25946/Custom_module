#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 该脚本将在设备开机后作为延迟服务启动
CAPOCAF="/data/adb/modules/Custom_temperature_control/switch/CAPOCAF.sh"
PTC="/data/adb/modules/Custom_temperature_control/switch/CO_PTC.sh"
CTC="/data/adb/modules/Custom_temperature_control/switch/CO_CTC.sh"
LOG="/data/adb/modules/Custom_temperature_control/switch/CO_LOG.sh"
SOC="/data/adb/modules/Custom_temperature_control/script/SOC_Certification.sh"
a=/data/adb/modules/Custom_temperature_control/switch/1.sh
#删除老文件
rm -rf /data/TC
rm -rf /sdcard/TC
rm -rf /data/adb/modules/Delete_temperature_control
#关闭核心温控、selinux 删除云温控
setenforce 0
#执行权限
chmod 555 /data/adb/modules/Custom_temperature_control/switch/*
chmod 555 /data/adb/modules/Custom_temperature_control/script/*
#执行脚本
nohup $CAPOCAF > /dev/null 2>&1 &
nohup $PTC > /dev/null 2>&1 &
nohup $CTC > /dev/null 2>&1 &
nohup $LOG > /dev/null 2>&1 &
nohup $SOC > /dev/null 2>&1 &
nohup $a > /dev/null 2>&1 &