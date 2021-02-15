#去除温控日志脚本

#时间
date
#参数或日志路径
tc_path=/storage/emulated/TC/
#某一个温控路径
thermal_engine=/system/vendor/bin/thermal-engine
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
#soc监控
soc_max_freq_Current=/storage/emulated/TC/Result/PTC/soc_max_freq_Current
#当前电流
Charge=`cat /sys/class/power_supply/bms/current_now`
#最大充电电流
recharging_current_freq_file=`cat /storage/emulated/TC/Result/CTC/current_temp|grep "000"|grep -v "-"|sort -unr|awk 'NR<2'`
#识别处理器
Identify=`getprop ro.board.platform`
#电池温度
battery_temp=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
if [ `date +%u` -eq 1 ]; then
    Z='星期一'
elif [ `date +%u` -eq 2 ]; then
    Z='星期二'
elif [ `date +%u` -eq 3 ]; then
    Z='星期三'
elif [ `date +%u` -eq 4 ]; then
    Z='星期四'
elif [ `date +%u` -eq 5 ]; then
    Z='星期五'
elif [ `date +%u` -eq 6 ]; then
    Z='星期六'
elif [ `date +%u` -eq 7 ]; then
    Z='星期日'
fi
        if [ $Charge -ge 0 ]; then
            echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
`cat /storage/emulated/TC/Result/SOC`
当前参数模式：`cat /storage/emulated/TC/Result/PTC/mode`
`cat /storage/emulated/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前电池状态
未充电
电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
电池电流=`expr $Charge / 1000`毫安" > /storage/emulated/TC/日志.log
            echo "执行完毕"
        elif [ $Charge -lt 0 ]; then
            echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
`cat /storage/emulated/TC/Result/SOC`
当前参数模式：`cat /storage/emulated/TC/Result/PTC/mode`
`cat /storage/emulated/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前充电状态
正在充电
电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
`cat /storage/emulated/TC/Result/CTC/current_present.log`
`cat /storage/emulated/TC/Result/CTC/current_present_mode.log`
当前充电电流=`expr $Charge / -1000`毫安
当前最大充电电流=`expr $recharging_current_freq_file / 1000`毫安" > /storage/emulated/TC/日志.log
        fi
