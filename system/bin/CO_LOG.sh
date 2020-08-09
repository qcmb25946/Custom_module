#!/system/bin/sh

#日志总开关

while true
do
sleep 1
thermal_engine=/system/vendor/etc/thermal-engine.conf
if [ ! -e $thermal_engine ]; then
    echo "成功删除温控"
    if [ -e "/storage/emulated/TC/script/LOG/LOG_monitor_Unlock.sh" ]; then
        sh "/storage/emulated/TC/script/LOG/LOG_monitor_Unlock.sh"
    else
        cp "/system/bin/LOG_monitor_Unlock.sh" "/storage/emulated/TC/script/LOG/"
    fi
else
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    if [ $thermal_engine_zf -eq 0 ]; then
        echo "成功用空文件顶替温控"
        if [ -e "/storage/emulated/TC/script/LOG/LOG_monitor_Unlock.sh" ]; then
            sh "/storage/emulated/TC/script/LOG/LOG_monitor_Unlock.sh"
        else
            cp "/system/bin/LOG_monitor_Unlock.sh" "/storage/emulated/TC/script/LOG/"
        fi
    elif [ $thermal_engine_zf -ne 0 ]; then
        echo "请移出温控"
        if [ -e "/storage/emulated/TC/script/LOG/LOG_monitor.sh" ]; then
            sh "/storage/emulated/TC/script/LOG/LOG_monitor.sh"
        else
            cp "/system/bin/LOG_monitor.sh" "/storage/emulated/TC/script/LOG/"
        fi
    fi
fi
done