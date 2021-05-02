#!/system/bin/sh


#估算电池容量

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#计算电池路径
Battery_calculation="$zdy_path/Battery_calculation"
#路径参数文件
Charge_control_needs_path="/cache/ZDY/surroundings/Charge_control_needs_path"
#当前电池状态
Charging_judgment="$(cat $(cat $Charge_control_needs_path|grep "Charging_judgment_path="|cut -d= -f2))"
#当前电池电量
capacity="$(cat $(cat $Charge_control_needs_path|grep "Battery_path="|cut -d= -f2))"
#当前电池电流
Current_battery="$(cat $(cat $Charge_control_needs_path|grep "Current_battery_path="|cut -d= -f2))"
#电池容量
charge_full="$(cat "/sys/class/power_supply/battery/charge_full")"
#开关
switch="$(cat "$Battery_calculation/switch")"
#等待时间
waiting_time="$(cat "$Battery_calculation/waiting_time")"
#当前电量文件
Current_battery_path="$Battery_calculation/Current_battery"
#结束电量文件
End_battery_path="$Battery_calculation/End_battery"
#电池容量
battery_capacity="$Battery_calculation/battery_capacity"
#记录
recording="$(date "+%Y-%m-%d_%H:%M:%S")"

#当前类型路径
battery_type_path="$Battery_calculation/type"
#读取类型
if [ -f "$battery_type_path" ];then
    cat_battery_type="$(cat "$battery_type_path")"
fi
#统计前时间路径
Time_before_statistics_path="$Battery_calculation/Time_before_statistics"
#读取统计前时间
if [ -f "$Time_before_statistics_path" ];then
    cat_Time_before_statistics="$(cat "$Time_before_statistics_path")"
fi
#统计前电量路径
Electricity_before_statistics_path="$Battery_calculation/Electricity_before_statistics"
#读取统计前电量
if [ -f "$Electricity_before_statistics_path" ];then
    cat_Electricity_before_statistics="$(cat "$Electricity_before_statistics_path")"
fi
#统计容量路径
battery_volume_path="$Battery_calculation/battery_volume"
#读取统计容量
if [ -f "$battery_volume_path" ];then
    cat_battery_volume="$(cat "$battery_volume_path")"
fi
#统计次数路径
Calculation_times_path="$Battery_calculation/Calculation_times"
#读取统计次数
if [ -f "$Calculation_times_path" ];then
    cat_Calculation_times="$(cat "$Calculation_times_path")"
fi
#充电文件夹
Recharge_path="$Battery_calculation/Recharge"
if [ ! -d "$Recharge_path" ];then
    mkdir -p "$Recharge_path"
fi
#充电文件
Recharge_file="$Recharge_path/$(date "+%F %T")"
#放电文件夹
Discharge_path="$Battery_calculation/Discharge"
if [ ! -d "$Discharge_path" ];then
    mkdir -p "$Discharge_path"
fi
#放电文件
Discharge_file="$Discharge_path/$(date "+%F %T")"

#写入统计开始参数
Statistics_start(){
#统计前时间
echo $(date "+%F %T") > $Time_before_statistics_path
#统计前电量
echo "$capacity" > $Electricity_before_statistics_path
#当前电流
echo "$Current_battery" > $battery_volume_path
#记录次数
echo 1 > $Calculation_times_path
}

#电流计算
Current_calculation(){
#计算电量
echo "$((cat_battery_volume+Current_battery))" > $battery_volume_path
#记录次数
echo "$(($cat_Calculation_times+1))" > $Calculation_times_path
}
#清理参数
Clean_up_parameters(){
if [ -f "$battery_type_path" ];then
    rm -rf $battery_type_path 
fi
if [ -f "$Electricity_before_statistics_path" ];then
    rm -rf $Electricity_before_statistics_path
fi
if [ -f "$battery_volume_path" ];then
    rm -rf $battery_volume_path
fi
if [ -f "$Calculation_times_path" ];then
    rm -rf $Calculation_times_path
fi
if [ -f "$Time_before_statistics_path" ];then
    rm -rf $Time_before_statistics_path
fi
}

#整理参数
Arrange_parameters(){
#释放电量差
Poor_battery=$(($cat_Electricity_before_statistics-$capacity))
if [ $Poor_battery -lt 0 ];then
    Poor_battery=$(($Poor_battery*-1))
    Recharge_type=1
fi
#充电掉电不整理清理参数
if [ ! -z "$Recharge_type" -a "$cat_battery_volume" -ge 0 ];then
    #清理参数
    Clean_up_parameters
    break
fi
#电量差大于30，整理
if [ $Poor_battery -ge 30 ];then
    #计算时间差
    calculating_time=$(($(date +%s) - $(date +%s -d "${cat_Time_before_statistics}")))
    #小时
    diff_hour=$(($calculating_time/3600))
    #分钟
    remainder_hour=$(($calculating_time%3600))
    diff_minute=$(($remainder_hour/60))
    #秒
    remainder_minute=$(($remainder_hour%60))
    #放电时间
    Statistics_Time="${diff_hour}:${diff_minute}:${remainder_minute}"
    #充电时系统参数为负数改成正数整理
    if [ $cat_battery_volume -lt 0 ];then
        cat_battery_volume="$((cat_battery_volume*-1))"
    fi
    #放电容量
    statistics_capacity=$(($cat_battery_volume*calculating_time/1000/3600/$cat_Calculation_times))
    #电池健康程度
    Battery_Life=$(($statistics_capacity*1000*100*100/$Poor_battery/$charge_full))
    #平均放电功耗/小时
    Average_current=$(($statistics_capacity*3600/$calculating_time))
    #合计参数
    Total_parameters="$(echo -e "当前时间\t$(date "+%F %T")\n统计过程\t${cat_Electricity_before_statistics}->${capacity}\n统计时间\t$Statistics_Time\n统计容量\t${statistics_capacity}毫安时\n统计电量\t${Poor_battery}%
健康程度\t${Battery_Life}%\n平均电流\t${Average_current}ma/h")"
    #写入参数
    if [ -z "$Recharge_type" ];then
        echo "$Total_parameters" > $Discharge_file
    else
        echo "$Total_parameters" > $Recharge_file
    fi
    #清理参数
    Clean_up_parameters
else
    #清理参数
    Clean_up_parameters
fi

}

#电池记录
battery_recording(){
#放电
if [ "$Charging_judgment" = "0" ];then
    #判断文件不存在
    if [ ! -f "$battery_type_path" -a $capacity -gt 40 ];then
        #写入类型
        echo "Discharge" > $battery_type_path
        #写入统计开始参数
        Statistics_start
    #判断文件存在
    elif [ -f "$battery_type_path" ];then
        #放电统计
        if [ "$cat_battery_type" = "Discharge" ];then
            #电量
            if [ $capacity -gt 10 ];then
                #电流计算
                Current_calculation
            else
                #整理参数
                Arrange_parameters
            fi
        #充电统计
        elif [ "$cat_battery_type" = "Recharge" ];then
            #整理参数
            Arrange_parameters
        fi
    fi
#充电
elif [ "$Charging_judgment" = "1" ];then
    #判断文件不存在
    if [ ! -f "$battery_type_path" -a $capacity -lt 60 ];then
        #写入类型
        echo "Recharge" > $battery_type_path
        #写入统计开始参数
        Statistics_start
    elif [ -f "$battery_type_path" ];then
        #充电统计
        if [ "$cat_battery_type" = "Recharge" ];then
            #电量
            if [ $capacity -lt 90 ];then
                #电流计算
                Current_calculation
            else
                #整理参数
                Arrange_parameters
            fi
        #放电统计
        elif [ "$cat_battery_type" = "Discharge" ];then
            #整理参数
            Arrange_parameters
        fi
    fi
fi
}
if [ "$switch" = "Y" ];then
    battery_recording
elif [ "$switch" = "O" ];then
    #清理参数
    Clean_up_parameters
    echo N > "$Battery_calculation/switch"
fi
sleep $waiting_time
done