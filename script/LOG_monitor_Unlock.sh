#!/system/bin/sh

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
recharging_current_freq_file=`cat /sys/class/power_supply/battery/constant_charge_current_max`
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
#减小满血温度阈值
Open_threshold=`cat /storage/emulated/TC/parameter/PTC/Open_threshold`
Limit_threshold=`cat /storage/emulated/TC/parameter/PTC/Limit_threshold`
#小核心降频档位
small_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/small_cpu_Frequency_reduction`
#大核心降频档位
big_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/big_cpu_Frequency_reduction`
#超大核心降频档位
super_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/super_cpu_Frequency_reduction`
#gpu降频档位
gpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/gpu_Frequency_reduction`
#充电减小满血温度阈值
Increase_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
#每次减少电流阈值
Reduce_current_size=/storage/emulated/TC/parameter/CTC/Reduce_current_size
#充电最大最小电流
Minimum_current=/storage/emulated/TC/parameter/CTC/Minimum_current
Maximum_current=/storage/emulated/TC/parameter/CTC/Maximum_current
#控制cpu最大频率路径
cpu0_max_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
cpu1_max_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"
cpu2_max_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu4_max_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu6_max_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
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
