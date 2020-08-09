#!/system/bin/sh

#日志总开关

#路径
log_path=/data/adb/modules/Custom_temperature_control/script/
while true
do
sleep 2
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
if [ `cat $switch` = 'K' ];then
    if [ ! -e $thermal_engine ]; then
        echo "成功删除温控"
        sh "${log_path}LOG_monitor_Unlock.sh"
    else
        thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
        if [ $thermal_engine_zf -eq 0 ]; then
            echo "成功用空文件顶替温控"
            sh "${log_path}LOG_monitor_Unlock.sh"
        elif [ $thermal_engine_zf -ne 0 ]; then
            echo "请移出温控"
            sh "${log_path}LOG_monitor.sh"
        fi
    fi
fi
done