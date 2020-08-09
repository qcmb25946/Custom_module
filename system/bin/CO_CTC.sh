#!/system/bin/sh
while true
do
sleep 1
thermal_engine="/system/vendor/bin/thermal-engine"
if [ ! -e $thermal_engine ]; then
    echo "成功删除温控"
    sh /system/bin/CTC.sh
else
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    if [ $thermal_engine_zf -eq 0 ]; then
        echo "成功用空文件顶替温控"
        sh /system/bin/CTC.sh
    elif [ $thermal_engine_zf -ne 0 ]; then
        echo "请移出温控"
    fi
fi
done