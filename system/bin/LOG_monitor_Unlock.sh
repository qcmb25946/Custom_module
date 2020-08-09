#!/system/bin/sh

#去除温控日志脚本

#时间
date
#参数或日志路径
#某一个温控路径
thermal_engine=/system/vendor/bin/thermal-engine
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
#soc监控
soc_max_freq_Current=/storage/emulated/TC/Result/PTC/soc_max_freq_Current
#当前电流
Charge=`cat /sys/class/power_supply/bms/current_now`
#最大充电电流
recharging_current_freq_file=`cat /sys/class/power_supply/battery/constant_charge_current`
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
#减小满血温度阈值
Open_threshold=`cat /storage/emulated/TC/parameter/PTC/Open_threshold`
Limit_threshold=`cat /storage/emulated/TC/parameter/PTC/Limit_threshold`
#gpu检测间隔
gpu_time=/storage/emulated/TC/parameter/PTC/gpu_time
#处理器降频幅度
cpu_Frequency_reduction=`cat /storage/emulated/TC/parameter/PTC/cpu_Frequency_reduction`
gpu_Frequency_reduction=`cat /storage/emulated/TC/parameter/PTC/gpu_Frequency_reduction`
#充电减小满血温度阈值
Increase_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
#每次减少电流阈值
Reduce_current_size=/storage/emulated/TC/parameter/CTC/Reduce_current_size
#检测电池温度间隔
charge_time=/storage/emulated/TC/parameter/CTC/charge_time
#充电最大最小电流
Minimum_current=/storage/emulated/TC/parameter/CTC/Minimum_current
Maximum_current=/storage/emulated/TC/parameter/CTC/Maximum_current
#当前模式
Current_mode=`cat /storage/emulated/TC/parameter/PTC/Current_mode`
        if [ $Current_mode = A ]; then
            mode=默认模式
        elif [ $Current_mode = B ]; then
            mode=重度模式
        fi
        if [ $Charge -ge 0 ]; then
            echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
`cat /storage/emulated/TC/Result/SOC`
`cat /storage/emulated/TC/Result/PTC/mode`
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
`cat /storage/emulated/TC/Result/PTC/mode`
`cat /storage/emulated/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前充电状态
正在充电
电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
`cat /storage/emulated/TC/Result/CTC/current_present.log`
`cat /storage/emulated/TC/Result/CTC/current_present_mode.log`
当前充电电流=`expr $Charge / -1000`毫安
当前最大充电电流=`expr $recharging_current_freq_file / 1000`毫安" > /storage/emulated/TC/日志.log
            echo "执行完毕"
        fi
        echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前设置处理器参数
$mode
均衡模式小核最大频率=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`
均衡模式大核最大频率=`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`
均衡模式GPU最大频率=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`

检测GPU温度间隔=`cat $gpu_time`秒
处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃
CPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%
GPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%

当前设置充电参数
电池温度间隔=`cat $charge_time`秒
降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃
最大充电电流档位=`cat $Maximum_current`毫安
最小充电电流档位=`cat $Minimum_current`毫安
阶梯减少充电阈值=`cat $Reduce_current_size`毫安" > /storage/emulated/TC/parameter/log.log