#!/system/bin/sh
while true
do
    #更新日志时间
    sleep 1
    #时间
    date
    #参数或日志路径
    #某一个温控路径
    thermal_engine=/system/vendor/bin/thermal-engine
    thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    #soc监控
    soc_max_freq_Current=/sbin/TC/Result/PTC/soc_max_freq_Current
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
    #日志合集
    if [ ! -f $thermal_engine ]; then
    	#减小满血温度阈值
    	Open_threshold=`cat /sbin/TC/parameter/PTC/Open_threshold`
        Limit_threshold=`cat /sbin/TC/parameter/PTC/Limit_threshold`
        #gpu检测间隔
        gpu_time=/sbin/TC/parameter/PTC/gpu_time
        #处理器降频幅度
        cpu_Frequency_reduction=`cat /sbin/TC/parameter/PTC/cpu_Frequency_reduction`
        gpu_Frequency_reduction=`cat /sbin/TC/parameter/PTC/gpu_Frequency_reduction`
        #充电减小满血温度阈值
        Increase_current_threshold=`cat /sbin/TC/parameter/CTC/Increase_current_threshold`
        Lower_current_threshold=`cat /sbin/TC/parameter/CTC/Lower_current_threshold`
        #每次减少电流阈值
        Reduce_current_size=/sbin/TC/parameter/CTC/Reduce_current_size
        #检测电池温度间隔
        charge_time=/sbin/TC/parameter/CTC/charge_time
        #充电最大最小电流
        Minimum_current=/sbin/TC/parameter/CTC/Minimum_current
        Maximum_current=/sbin/TC/parameter/CTC/Maximum_current
        if [ $Charge -ge 0 ]; then
            echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前处理器状态
当前`cat /sbin/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前电池状态
当前未充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前电池电流=`expr $Charge / 1000`毫安

当前设置处理器参数
当前设置检测GPU温度间隔=`cat $gpu_time`秒
当前设置处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置CPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%
当前设置GPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%

当前设置充电参数
检测设置电池温度间隔=`cat $charge_time`秒
当前设置减少充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置最大充电电流阈值=`cat $Maximum_current`毫安
当前设置最小充电电流阈值=`cat $Minimum_current`毫安
阶梯减少充电阈值=`cat $Reduce_current_size`毫安" > /sbin/TC/日志.log
            echo "执行完毕"
        elif [ $Charge -lt 0 ]; then
            echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前处理器状态
当前`cat /sbin/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前充电状态
当前正在充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前`cat /sbin/TC/Result/CTC/current_present.log`
当前`cat /sbin/TC/Result/CTC/current_present_mode.log`
当前充电电流=`expr $Charge / -1000`毫安
当前最大充电电流=`expr $recharging_current_freq_file / 1000`毫安

当前设置处理器参数
当前设置检测GPU温度间隔=`cat $gpu_time`秒
当前设置处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置CPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%
当前设置GPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%

当前设置充电参数
检测设置电池温度间隔=`cat $charge_time`秒
当前设置减少充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置最大充电电流阈值=`cat $Maximum_current`毫安
当前设置最小充电电流阈值=`cat $Minimum_current`毫安
阶梯减少充电阈值=`cat $Reduce_current_size`毫安" > /sbin/TC/日志.log
            echo "执行完毕"
        fi
	else
        if [ $thermal_engine_zf -eq 0 ]; then
            #减小满血温度阈值
            Open_threshold=`cat /sbin/TC/parameter/PTC/Open_threshold`
            Limit_threshold=`cat /sbin/TC/parameter/PTC/Limit_threshold`
            #gpu检测间隔
            gpu_time=/sbin/TC/parameter/PTC/gpu_time
            #处理器降频幅度
            cpu_Frequency_reduction=`cat /sbin/TC/parameter/PTC/cpu_Frequency_reduction`
            gpu_Frequency_reduction=`cat /sbin/TC/parameter/PTC/gpu_Frequency_reduction`
            #充电减小满血温度阈值
            Increase_current_threshold=`cat /sbin/TC/parameter/CTC/Increase_current_threshold`
            Lower_current_threshold=`cat /sbin/TC/parameter/CTC/Lower_current_threshold`
            #每次减少电流阈值
            Reduce_current_size=/sbin/TC/parameter/CTC/Reduce_current_size
            #检测电池温度间隔
            charge_time=/sbin/TC/parameter/CTC/charge_time
            #充电最大最小电流
            Minimum_current=/sbin/TC/parameter/CTC/Minimum_current
            Maximum_current=/sbin/TC/parameter/CTC/Maximum_current
            if [ $Charge -ge 0 ]; then
                echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前处理器状态
当前`cat /sbin/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前电池状态
当前未充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前电池电流=`expr $Charge / 1000`毫安

当前设置处理器参数
当前设置检测GPU温度间隔=`cat $gpu_time`秒
当前设置处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置CPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%
当前设置GPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%

当前设置充电参数
检测设置电池温度间隔=`cat $charge_time`秒
当前设置减少充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置最大充电电流阈值=`cat $Maximum_current`毫安
当前设置最小充电电流阈值=`cat $Minimum_current`毫安
阶梯减少充电阈值=`cat $Reduce_current_size`毫安" > /sbin/TC/日志.log
                echo "执行完毕"
            elif [ $Charge -lt 0 ]; then
                echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前处理器状态
当前`cat /sbin/TC/Result/PTC/soc_present.log`
`cat $soc_max_freq_Current`

当前充电状态
当前正在充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前`cat /sbin/TC/Result/CTC/current_present.log`
当前`cat /sbin/TC/Result/CTC/current_present_mode.log`
当前充电电流=`expr $Charge / -1000`毫安
当前最大充电电流=`expr $recharging_current_freq_file / 1000`毫安

当前设置处理器参数
当前设置检测GPU温度间隔=`cat $gpu_time`秒
当前设置处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置CPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%
当前设置GPU降频幅度=`expr 100 - $cpu_Frequency_reduction`%

当前设置充电参数
检测设置电池温度间隔=`cat $charge_time`秒
当前设置减少充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃
当前设置最大充电电流阈值=`cat $Maximum_current`毫安
当前设置最小充电电流阈值=`cat $Minimum_current`毫安
阶梯减少充电阈值=`cat $Reduce_current_size`毫安" > /sbin/TC/日志.log
                echo "执行完毕"
            fi
        elif [ $thermal_engine_zf -gt 0 ]; then
            if [ $Charge -ge 0 ]; then
	            echo "没充电"
                echo -e "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前去除温控失败
为了不影响使用体验
所以停止运行该模块
但保留对soc最大频率和充电最大电流监控
(仅作参考有可能不准确)

当前处理器状态
`cat $soc_max_freq_Current`

当前电池状态
当前未充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前电池电流=`expr $Charge / 1000`毫安" > /sbin/TC/日志.log
                echo "执行完毕"
            elif [ $Charge -lt 0 ]; then
	            echo "正在充电"
                echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前去除温控失败
为了不影响使用体验
所以停止运行该模块
但保留对soc最大频率和充电最大电流监控
(仅作参考有可能不准确)

当前处理器状态
`cat $soc_max_freq_Current`

当前充电状态
当前正在充电
当前电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
当前充电电流=`expr $Charge / -1000`毫安
当前最大充电电流=`expr $recharging_current_freq_file / 1000`毫安" > /sbin/TC/日志.log
                    echo "执行完毕"
                fi
            fi
    fi
done
}
