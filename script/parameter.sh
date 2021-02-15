#!/system/bin/sh


#参数脚本

while true
do
date
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#文件夹路径

#参数路径
zdy_path="/cache/ZDY"
#充电控制路径
recharge="$zdy_path/recharge"
if [ ! -d "$recharge" ];then
    mkdir -p "$recharge"
fi
#SOC控制路径
processor="$zdy_path/processor"
if [ ! -d "$processor" ];then
    mkdir -p "$processor"
fi
#游戏设置路径
game="$zdy_path/game"
if [ ! -d "$game" ];then
    mkdir -p "$game"
fi
#系统设置开关
system="$zdy_path/system"
if [ ! -d "$system" ];then
    mkdir -p "$system"
fi
#快速寻找
search="$zdy_path/search"
if [ ! -d "$search" ];then
    mkdir -p "$search"
fi
#调度参数路径
scheduling="$zdy_path/scheduling"
if [ ! -d "$scheduling" ];then
    mkdir -p "$scheduling"
fi
#调度参数路径
Battery_calculation="$zdy_path/Battery_calculation"
if [ ! -d "$Battery_calculation" ];then
    mkdir -p "$Battery_calculation"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#充电参数

#分段式充电路径
Segmented_charging="$(cat "/cache/ZDY/surroundings/Charge_control_needs_path"|grep "Break_charging_path=")"
#降低电流温度
if [ ! -f "$recharge/current_reduce_temp" ];then
    echo 430 > "$recharge/current_reduce_temp"
fi
#增加电流温度
if [ ! -f "$recharge/current_increase_temp" ];then
    echo 410 > "$recharge/current_increase_temp"
fi
#停止充电温度
if [ ! -f "$recharge/stop_charging_temp" ];then
    echo 470 > "$recharge/stop_charging_temp"
fi
#调整充电电流
if [ ! -f "$recharge/adjust_charging_current" ];then
    echo $((100*1000)) > "$recharge/adjust_charging_current"
fi
#充电最低电流
if [ ! -f "$recharge/Lowest_current" ];then
    #机型代号
    model_code="$(getprop ro.product.device)"
    #最低电流
    Lowest_current="$(cat "/data/adb/modules/Custom_module/parameter/lowest_current"|grep "=${model_code}="|cut -d= -f3)"
    if [ -z "$Lowest_current" ];then
        echo $((1000*1000)) > "$recharge/Lowest_current"
    else
        echo $Lowest_current > "$recharge/Lowest_current"
    fi
fi
#涓流充电开关
if [ ! -f "$recharge/trickle_switch" ];then
    echo N > "$recharge/trickle_switch"
fi
#涓流充电电量
if [ ! -f "$recharge/trickle_power" ];then
    echo 90 > "$recharge/trickle_power"
fi
#涓流充电电流
if [ ! -f "$recharge/trickle_current" ];then
    echo $((200*1000)) > "$recharge/trickle_current"
fi
#处理异常开关
if [ ! -f "$recharge/abnormal_switch" ];then
    echo N > "$recharge/abnormal_switch"
fi
#异常次数处理
if [ ! -f "$recharge/abnormal_freq" ];then
    echo 10 > "$recharge/abnormal_freq"
fi
#异常充电电流
if [ ! -f "$recharge/abnormal_current" ];then
    echo $((200*1000)) > "$recharge/abnormal_current"
fi
#分段式充电开关
if [ ! -z "$Segmented_charging" ];then
    if [ ! -f "$recharge/disconnect_charging_switch" ];then
        echo N > "$recharge/disconnect_charging_switch"
    fi
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#soc控制参数

#按照cpu温度cpu降频温度
if [ ! -f "$processor/cpu_down_temp" ];then
    echo 750 > "$processor/cpu_down_temp"
fi
#按照电池温度cpu降频阈值
if [ ! -f "$processor/cpu_down_battery_temp" ];then
    echo 470 > "$processor/cpu_down_battery_temp"
fi
#按照gpu温度gpu降频温度
if [ ! -f "$processor/gpu_down_temp" ];then
    echo 800 > "$processor/gpu_down_temp"
fi
#按照电池温度gpu降频阈值
if [ ! -f "$processor/gpu_down_battery_temp" ];then
    echo 480 > "$processor/gpu_down_battery_temp"
fi
#按照gpu温度满血温度
if [ ! -f "$processor/soc_full_temp" ];then
    echo 650 > "$processor/soc_full_temp"
fi
#按照电池温度soc满血阈值
if [ ! -f "$processor/soc_full_battery_temp" ];then
    echo 430 > "$processor/soc_full_battery_temp"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#游戏优化破解画质

#王者荣耀游戏优化
if [ ! -f "$game/king_glory_switch" ];then
    echo N > "$game/king_glory_switch"
fi
#王者荣耀前瞻版游戏优化
if [ ! -f "$game/king_glory_foresight_switch" ];then
    echo N > "$game/king_glory_foresight_switch"
fi
#和平精英破解画质
if [ ! -f "$game/peace_elite_switch" ];then
    echo N > "$game/peace_elite_switch"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#系统设置开关

#selinux
if [ ! -f "$system/selinux" ];then
    echo N > "$system/selinux"
fi
#zram开关
if [ ! -f "$system/zram_switch" ];then
    echo N > "$system/zram_switch"
fi
#zram容量
if [ ! -f "$system/zram_capacity" ];then
    echo 0 > "$system/zram_capacity"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#快速寻找

#开关
if [ ! -f "$search/switch" ];then
    echo N > "$search/switch"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#默认调度参数

#调度开关
if [ ! -f "$scheduling/switch" ];then
    echo N > "$scheduling/switch"
fi
#调度文件
if [ ! -f "$scheduling/file" ];then
    echo "default" > "$scheduling/file"
fi
#参考文件参数
soc_parameters="/cache/ZDY/surroundings/soc_parameters"
#cpu总集数量
vertical_number="$(cat $soc_parameters|grep "vertical_number="|cut -d= -f2)"
#cpu最高编号
kernel_max="$(cat "/sys/devices/system/cpu/kernel_max")"
#搜索schedutil
Adjuster="$(cat $soc_parameters|grep "cpu_adjuster="|cut -d= -f2|grep "schedutil")"
#默认调度文件夹
default="$scheduling/default/default"
if [ ! -d "$default" ];then
    mkdir -p "$default"
fi
#调度方式
if [ ! -f "$scheduling/default/mode" ];then
    echo "A" > "$scheduling/default/mode"
fi
#调度文件名
if [ ! -f "$scheduling/default/type" ];then
    echo "" > "$scheduling/default/type"
fi
#调度参数
if [ ! -f "$default/default" ];then
    for A in $(seq $vertical_number)
    do
        #cpu频率表
        cpu_Freq_table="$(cat $soc_parameters|grep "vertical_core_freq_table_${A}="|cut -d= -f2|sed "s/ /\n/g"|sed "/^$/d"|sort -n|awk '{print FNR "=" $0}')"
        #cpu频率数量
        cpu_freq_table_number="$(cat $soc_parameters|grep "vertical_core_freq_table_number_${A}="|cut -d= -f2)"
        #cpu最大频率
        cpu_max_freq="$(cat $soc_parameters|grep "vertical_core_max_freq_${A}="|cut -d= -f2)"
        #cpu最大频率
        cpu_min_freq="$(cat $soc_parameters|grep "vertical_core_min_freq_${A}="|cut -d= -f2)"
        #选择调整器
        if [ -z "$Adjuster" ];then
            echo "vertical_core_adjuster_${A}=ondemand" >> "$default/default"
        else
            echo "vertical_core_adjuster_${A}=schedutil" >> "$default/default"
        fi
        #升频频率schedutil
        rise_freq(){
        for B in $(seq $cpu_freq_table_number)
        do
            #cpu频率
            cpu_freq="$(echo "$cpu_Freq_table"|grep "^${B}="|cut -d= -f2)"
            if [ $cpu_freq -lt $cpu_general_freq ];then
                the_goal_small=$cpu_freq
            else
                hispeed_freq=$cpu_freq
                break
            fi
        done
        #升频频率
        echo "vertical_core_hispeed_freq_${A}=$hispeed_freq" >> "$default/default"
        }
        #cpu升频频率目标
        if [ "$A" = 1 ];then
            cpu_general_freq="$((1000*1000))"
            #升频阈值
            echo "vertical_core_hispeed_load_${A}=85" >> "$default/default"
            #加速频率
            echo "vertical_core_boost_freq_${A}=0" >> "$default/default"
        else
            cpu_general_freq="$((1200*1000))"
            #升频阈值
            echo "vertical_core_hispeed_load_${A}=90" >> "$default/default"
            #加速频率
            echo "vertical_core_boost_freq_${A}=0" >> "$default/default"
        fi
        #升频频率
        rise_freq
        #性能不够的soc默认调度参数
        if [ -z "$Balance_goal_freq" ];then
            #最大频率
            echo "vertical_core_max_freq_${A}=$cpu_max_freq" >> "$default/default"
            #最小频率
            echo "vertical_core_min_freq_${A}=$cpu_min_freq" >> "$default/default"
        fi
    done
    if [ "$vertical_number" = "1" ];then
        #转移大核心负载
        echo "vertical_core_transfer_big_core=100" >> "$default/default"
        #转移小核心负载
        echo "vertical_core_transfer_small_core=100" >> "$default/default"
    elif [ "$vertical_number" = "2" ];then
        #转移大核心负载
        echo "vertical_core_transfer_big_core=85" >> "$default/default"
        #转移小核心负载
        echo "vertical_core_transfer_small_core=75" >> "$default/default"
    elif [ "$vertical_number" = "3" ];then
        #转移大核心负载
        echo "vertical_core_transfer_big_core=85 85" >> "$default/default"
        #转移小核心负载
        echo "vertical_core_transfer_small_core=75 75" >> "$default/default"
    fi
    #前台任务
    echo "vertical_core_front=0-$kernel_max" >> "$default/default"
    #前台界面任务
    echo "vertical_core_front_interface=0-$kernel_max" >> "$default/default"
    #后台任务
    echo "vertical_core_Background=0-$((($kernel_max - 1) / 2))" >> "$default/default"
    #系统后台任务
    echo "vertical_core_system_background=0-$((($kernel_max - 1) / 2))" >> "$default/default"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#统计电池容量

#开关
if [ ! -f "$Battery_calculation/switch" ];then
    echo N > "$Battery_calculation/switch"
fi
#脚本间隔
if [ ! -f "$Battery_calculation/waiting_time" ];then
    echo 1 > "$Battery_calculation/waiting_time"
fi
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
sleep 3
done