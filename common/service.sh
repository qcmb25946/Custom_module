#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 该脚本将在设备开机后作为延迟服务启动
CAPOCAF="/system/bin/CAPOCAF.sh"
PTC="/system/bin/CO_PTC.sh"
CTC="/system/bin/CO_CTC.sh"
log="/system/bin/log.sh"
rm -rf /data/TC
rm -rf /data/vendor/thermal
nohup $CAPOCAF > /dev/null 2>&1 &
sleep 5
nohup $PTC > /dev/null 2>&1 &
sleep 1
nohup $CTC > /dev/null 2>&1 &
sleep 1
nohup $log > /dev/null 2>&1 &
sleep 1