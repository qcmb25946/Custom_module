MODDIR=${0%/*}
CAPOCAF="/data/adb/modules/Custom_temperature_control/switch/CAPOCAF.sh"
PTC="/data/adb/modules/Custom_temperature_control/switch/CO_PTC.sh"
CTC="/data/adb/modules/Custom_temperature_control/switch/CO_CTC.sh"
LOG="/data/adb/modules/Custom_temperature_control/switch/CO_LOG.sh"
SOC="/data/adb/modules/Custom_temperature_control/script/SOC_Certification.sh"
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
sleep 1
nohup $PTC > /dev/null 2>&1 &
sleep 1
nohup $CTC > /dev/null 2>&1 &
sleep 1
nohup $LOG > /dev/null 2>&1 &
sleep 1
nohup $SOC > /dev/null 2>&1 &
sleep 1