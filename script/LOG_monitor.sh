#未去除温控日志脚本

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
    #日志合集
            if [ $Charge -ge 0 ]; then
	            echo "没充电"
                echo -e "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前去除温控失败
为了不影响使用体验
所以停止运行该模块
但保留对soc最大频率和充电最大电流监控
(仅作参考有可能不准确)

`cat /storage/emulated/TC/Result/SOC`
`cat $soc_max_freq_Current`

当前电池状态
未充电
电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
电池电流=`expr $Charge / 1000`毫安" > /storage/emulated/TC/日志.log
                echo "执行完毕"
            elif [ $Charge -lt 0 ]; then
	            echo "正在充电"
                echo "当前时间：[ `date +"%Y年%m月%d日 %H点%M分%S秒 $Z"` ]
当前去除温控失败
为了不影响使用体验
所以停止运行该模块
但保留对soc最大频率和充电最大电流监控
(仅作参考有可能不准确)

`cat /storage/emulated/TC/Result/SOC`
`cat $soc_max_freq_Current`

当前充电状态
正在充电
电池温度=`echo "$battery_temp 10"|awk '{print ($1/$2)}'`℃
充电速度=`expr $Charge / -1000`毫安
最大充电电流=`expr $recharging_current_freq_file / 1000`毫安" > /storage/emulated/TC/日志.log
                    echo "执行完毕"
                fi