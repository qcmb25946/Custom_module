#!/system/bin/sh

#充电温控总开关，调用CTC文件

#路径
ctc_path=/data/adb/modules/Custom_temperature_control/script/
while true
do
sleep 1
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
if [ `cat $switch` = 'K' ];then
    if [ ! -e $thermal_engine ]; then
        echo "成功删除温控"
        sh ${ctc_path}CTC.sh
    else
        thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
        if [ $thermal_engine_zf -eq 0 ]; then
            echo "成功用空文件顶替温控"
            nohup ${ctc_path}CTC.sh
        elif [ $thermal_engine_zf -ne 0 ]; then
            echo "请移出温控"
        fi
    fi
fi
done