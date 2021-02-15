#日志总开关

#路径
log_path=/data/adb/modules/Custom_temperature_control/script/
while true
do
sleep 2.5
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
if [ `cat $switch` = 'K' ];then
        sh "${log_path}LOG_monitor_Unlock.sh"
fi
done