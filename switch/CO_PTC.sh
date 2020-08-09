#!/system/bin/sh

#处理器温控总开关，调用PTC_Transit.sh文件

while true
do
sleep 1
#温控文件
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
Current_mode=/storage/emulated/TC/parameter/PTC/Current_mode
#电池温度
battery_temp_dir=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
protect_yourself=`cat /storage/emulated/TC/parameter/PTC/protect_yourself`
if [ $protect_yourself -gt $battery_temp_dir ];then
    if [ `cat $switch` = 'K' ];then
        if [ ! -e $thermal_engine ]; then
            echo "成功删除温控"
            sh /data/adb/modules/Custom_temperature_control/Transit/PTC_Transit.sh
        else
            thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
            if [ $thermal_engine_zf -eq 0 ]; then
                echo "成功用空文件顶替温控"
                sh /data/adb/modules/Custom_temperature_control/Transit/PTC_Transit.sh
            elif [ $thermal_engine_zf -ne 0 ]; then
                echo "请移出温控"
                sh /data/adb/modules/Custom_temperature_control/script/PTC_monitor.sh
            fi
        fi
    fi
elif [ $protect_yourself -le $battery_temp_dir ];then
    if [ `cat $switch` = 'K' -a $Current_mode = 'A' ];then
        sh /data/adb/modules/Custom_temperature_control/script/PTC_protection.sh
    else
        reboot -p
    fi
fi
done