#!/system/bin/sh

#充电温控总开关，调用CTC文件

while true
do
sleep 1
thermal_engine=/system/vendor/etc/thermal-engine.conf
if [ ! -e $thermal_engine ]; then
    echo "成功删除温控"
    if [ -e "/storage/emulated/TC/script/CTC/CTC.sh" ]; then
        sh /storage/emulated/TC/script/CTC/CTC.sh
    else
        cp /system/bin/CTC.sh /storage/emulated/TC/script/CTC/
    fi
else
    thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    if [ $thermal_engine_zf -eq 0 ]; then
        echo "成功用空文件顶替温控"
        if [ -e "/storage/emulated/TC/script/CTC/CTC.sh" ]; then
            sh /storage/emulated/TC/script/CTC/CTC.sh
        else
            cp /system/bin/CTC.sh /storage/emulated/TC/script/CTC/
        fi
    elif [ $thermal_engine_zf -ne 0 ]; then
        echo "请移出温控"
    fi
fi

#禁止修改这里，修改这里请自己保护好手机
Shut_down=500
battery_temp=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
if [ $battery_temp -gt $Shut_down ]; then
    reboot -p
else
    echo "手机低于50度"
fi
done