#!/system/bin/sh


#充电控制

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#充电控制路径
recharge="$zdy_path/recharge"
#路径参数文件
Charge_control_needs_path="/cache/ZDY/surroundings/Charge_control_needs_path"
#最低电流上限
View_current_limit="$(echo $(sh "/cache/ZDY/surroundings/View_current_limit.sh"|grep "0000"|grep -v '-'|sort -n)|cut -d" " -f1)"
#写入电流上限
Write_current_limit="/cache/ZDY/surroundings/Write_current_limit.sh"
#当前电池状态
Charging_judgment="$(cat $(cat $Charge_control_needs_path|grep "Charging_judgment_path="|cut -d= -f2))"
#当前电池温度
Battery_temp="$(cat $(cat $Charge_control_needs_path|grep "Battery_temp_path="|cut -d= -f2))"
#当前充电情况
Battery_breaking="$(cat $(cat $Charge_control_needs_path|grep "Battery_breaking_path="|cut -d= -f2))"
#充电情况路径
Battery_breaking_path="$(cat $Charge_control_needs_path|grep "Battery_breaking_path="|cut -d= -f2)"
#充电标识
Battery_guide="$(cat "$Charge_control_needs_path"|grep "Battery_guide="|cut -d= -f2)"
#充电情况指示
Charging_sign="$(cat $Charge_control_needs_path|grep "Charging_sign="|cut -d= -f2)"
#当前电池电量
capacity="$(cat $(cat $Charge_control_needs_path|grep "Battery_path="|cut -d= -f2))"
#当前电池电流
Current_battery="$(cat $(cat $Charge_control_needs_path|grep "Current_battery_path="|cut -d= -f2))"
#分断充电路径
Break_charging_path="$(cat $Charge_control_needs_path|grep "Break_charging_path="|cut -d= -f2)"

#降低电流温度
current_reduce_temp="$(cat "$recharge/current_reduce_temp")"
#增加电流温度
current_increase_temp="$(cat "$recharge/current_increase_temp")"
#停止充电温度
stop_charging_temp="$(cat "$recharge/stop_charging_temp")"
#调整充电电流
adjust_charging_current="$(cat "$recharge/adjust_charging_current")"
#充电最低电流
Lowest_current="$(cat "$recharge/Lowest_current")"
#涓流充电开关
trickle_switch="$(cat "$recharge/trickle_switch")"
#涓流充电电量
trickle_power="$(cat "$recharge/trickle_power")"
#涓流充电电流
trickle_current="$(cat "$recharge/trickle_current")"
#处理异常开关
abnormal_switch="$(cat "$recharge/abnormal_switch")"
#异常次数处理
abnormal_freq="$(cat "$recharge/abnormal_freq")"
#异常充电电流
abnormal_current="$(cat "$recharge/abnormal_current")"
#分断充电开关
if [ -f "$recharge/disconnect_charging_switch" ];then
    disconnect_charging_switch="$(cat "$recharge/disconnect_charging_switch")"
fi

#判断是否充电
if [ "$Charging_judgment" = "1" ];then
    #该不该停止充电
    if [ $Battery_temp -ge $stop_charging_temp ];then
        #执行停止充电
        if [ "$Battery_guide" = "0" ];then
            if [ "$Charging_sign" != "1" ];then
                chmod 666 "$Battery_breaking_path"
                echo 1 > "$Battery_breaking_path"
                chmod 444 "$Battery_breaking_path"
            fi
        elif [ "$Battery_guide" = "1" ];then
            if [ "$Charging_sign" != "0" ];then
                chmod 666 "$Battery_breaking_path"
                echo 0 > "$Battery_breaking_path"
                chmod 444 "$Battery_breaking_path"
            fi
        fi
    #继续充电
    else
        #将段充改为继续充电
        if [ "$Battery_guide" = "0" ];then
            if [ "$Charging_sign" != "0" ];then
                chmod 666 "$Battery_breaking_path"
                echo 0 > "$Battery_breaking_path"
                chmod 444 "$Battery_breaking_path"
            fi
        elif [ "$Battery_guide" = "1" ];then
            if [ "$Charging_sign" != "1" ];then
                chmod 666 "$Battery_breaking_path"
                echo 1 > "$Battery_breaking_path"
                chmod 444 "$Battery_breaking_path"
            fi
        fi
        #判断是否充电保护
        if [ "$trickle_switch" = "Y" -a $capacity -ge $trickle_power ];then
            #充电保护电量
            current_max=$trickle_current
        #没有充电保护开始正常增减电流
        else
            #增加降低电流
            if [ $Battery_temp -ge $current_reduce_temp ];then
                current_max=$Lowest_current
            elif [ $Battery_temp -le $current_increase_temp ];then
                current_max=$(($View_current_limit+$adjust_charging_current))
            fi
            #解决充电异常
            if [ "$abnormal_switch" = "Y" -a $(($Current_battery/-1)) -le $abnormal_current -a $capacity -lt 100 ];then
                let freq++
                if [ "$freq" = "$abnormal_freq" ];then
                    freq=0
                    if [ "$Battery_guide" = "0" ];then
                        chmod 666 "$Battery_breaking_path"
                        echo 1 > "$Battery_breaking_path"
                        chmod 444 "$Battery_breaking_path"
                        sleep 1
                        chmod 666 "$Battery_breaking_path"
                        echo 0 > "$Battery_breaking_path"
                        chmod 444 "$Battery_breaking_path"
                    elif [ "$Battery_guide" = "1" ];then
                        chmod 666 "$Battery_breaking_path"
                        echo 0 > "$Battery_breaking_path"
                        chmod 444 "$Battery_breaking_path"
                        sleep 1
                        chmod 666 "$Battery_breaking_path"
                        echo 1 > "$Battery_breaking_path"
                        chmod 444 "$Battery_breaking_path"
                    fi
                fi
            else
                freq=0
            fi
        fi
        #限制最高电流
        if [ -f "$recharge/Maximum_current" ];then
            if [ $current_max -ge $(cat "$recharge/Maximum_current") ];then
                current_max=$(cat "$recharge/Maximum_current")
            fi
        fi
        #写入参数
        if [ ! -z "$current_max" ];then
            if [ "$View_current_limit" != "$current_max" ];then
                . $Write_current_limit
            fi
        fi
        #分段式开关
        if [ ! -z "$Break_charging_path" ];then
            #分断充电情况
            Break_charging="$(cat $(cat $Charge_control_needs_path|grep "Break_charging_path="|cut -d= -f2))"
            if [ "$disconnect_charging_switch" = "Y" ];then
                if [ "$Break_charging" != "0" ];then
                    chmod 666 $Break_charging_path
                    echo 0 > $Break_charging_path
                    chmod 444 $Break_charging_path
                fi
            fi
        fi
    fi
fi
sleep 1
done