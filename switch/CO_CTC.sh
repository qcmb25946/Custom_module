#充电温控总开关，调用CTC文件

#路径
ctc_path=/data/adb/modules/Custom_temperature_control/script/
while true
do
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
if [ `cat $switch` = 'K' ];then
    sh ${ctc_path}CTC.sh
fi
sleep 1
done