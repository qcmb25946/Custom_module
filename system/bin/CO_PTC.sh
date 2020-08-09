#!/system/bin/sh

#处理器温控总开关，调用PTC_Transit.sh文件

while true
do
sleep 1
#温控文件
thermal_engine=/system/vendor/etc/thermal-engine.conf
if [ ! -e $thermal_engine ]; then
    echo "成功删除温控"
    if [ ! -e '/storage/emulated/TC/script/PTC/PTC_Transit.sh' ];then
        cp /system/bin/PTC_Transit.sh /storage/emulated/TC/script/PTC/
        sh /storage/emulated/TC/script/PTC/PTC_Transit.sh
    else
        sh /storage/emulated/TC/script/PTC/PTC_Transit.sh
    fi
else
    thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    if [ $thermal_engine_zf -eq 0 ]; then
        echo "成功用空文件顶替温控"
        if [ ! -e '/storage/emulated/TC/script/PTC/PTC_Transit.sh' ];then
            cp /system/bin/PTC_Transit.sh /storage/emulated/TC/script/PTC/
            sh /storage/emulated/TC/script/PTC/PTC_Transit.sh
        else
            sh /storage/emulated/TC/script/PTC/PTC_Transit.sh
        fi
    elif [ $thermal_engine_zf -ne 0 ]; then
        echo "请移出温控"
        if [ ! -e '/storage/emulated/TC/script/PTC/PTC_monitor.sh' ];then
            cp /system/bin/PTC_monitor.sh /storage/emulated/TC/script/PTC/
            sh /storage/emulated/TC/script/PTC/PTC_monitor.sh
        else
            sh /storage/emulated/TC/script/PTC/PTC_monitor.sh
        fi
    fi
fi
done