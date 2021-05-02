#!/system/bin/sh


#开机预备

#清楚老模块参数和模块
if [ -d "/data/TC" ];then
    rm -rf "/data/TC"
fi
if [ -d "/sdcard/TC" ];then
    rm -rf "/sdcard/TC"
fi
if [ -d "/storage/emulated/TC" ];then
    rm -rf "/storage/emulated/TC"
fi
if [ -d "/data/adb/modules/Delete_temperature_control" ];then
    rm -rf "/data/adb/modules/Delete_temperature_control"
fi
if [ -d "/data/adb/modules/Custom_temperature_control" ];then
    rm -rf "/data/adb/modules/Custom_temperature_control"
fi

#关闭骁龙835及一起老soc温控设置
if [ -e '/sys/module/msm_thermal/core_control/enabled' ];then
    if [ "$(cat /sys/module/msm_thermal/core_control/enabled)" != "0" ];then
        chmod 666 "/sys/module/msm_thermal/core_control/enabled"
        echo 0 > "/sys/module/msm_thermal/core_control/enabled"
        chmod 444 "/sys/module/msm_thermal/core_control/enabled"
    fi
fi
if [ -e '/sys/module/msm_thermal/vdd_restriction/enabled' ];then
    if [ "$(cat /sys/module/msm_thermal/vdd_restriction/enabled)" != 'disable' ];then
        chmod 666 "/sys/module/msm_thermal/vdd_restriction/enabled"
        echo 0 > "/sys/module/msm_thermal/vdd_restriction/enabled"
        chmod 444 "/sys/module/msm_thermal/vdd_restriction/enabled"
    fi
fi
if [ -e '/sys/module/msm_thermal/parameters/enabled' ];then
    if [ "$(cat /sys/module/msm_thermal/parameters/enabled)" != 'N' ];then
        chmod 666 "/sys/module/msm_thermal/parameters/enabled"
        echo N > "/sys/module/msm_thermal/parameters/enabled"
        chmod 444"/sys/module/msm_thermal/parameters/enabled"
    fi
fi

#临时文件
cpu_tmp="/cache/ZDY/surroundings/cpu_tmp"
#路径文件
soc_needs_path="/cache/ZDY/surroundings/soc_needs_path"
#SOC参数
soc_parameters="/cache/ZDY/surroundings/soc_parameters"
#soc参数
#cpu调整器
echo "cpu_adjuster=$(cat $(cat $soc_needs_path|grep "cpu_adjuster_path="|cut -d= -f2))" > "$soc_parameters"
##最高编号
kernel_max="$(cat $(cat $soc_needs_path|grep "kernel_max_path="|cut -d= -f2))"
#清理临时文件
if [ -f "$cpu_tmp" ];then
    rm -rf "$cpu_tmp"
fi
for A in $(seq 0 $kernel_max)
do
    cat "/sys/devices/system/cpu/cpu$A/cpufreq/affected_cpus" >> "$cpu_tmp"
done
#cpu总集数
cat "$cpu_tmp"|sort -u|cut -c1|wc -w|sed "s/^/vertical_number=/g" >> "$soc_parameters"
#cpu纵集
cat "$cpu_tmp"|sort -u|cut -c1|awk '{print "vertical_core_" FNR "=" $0}' >> "$soc_parameters"
#cpu总集编号
cat "$cpu_tmp"|sort -u|awk '{print "vertical_core_number_" FNR "=" $0}' >> "$soc_parameters"
rm -rf "$cpu_tmp"
#cpu总集数
vertical_number="$(cat "$soc_parameters"|grep "vertical_number"|cut -d= -f2)"
for B in $(seq $vertical_number)
do

    #cpu编号
    vertical_core="$(cat "$soc_parameters"|grep "vertical_core_${B}"|cut -d= -f2)"
    #最大频率
    echo "vertical_core_max_freq_${B}=$(cat $(cat $soc_needs_path|grep "vertical_core_max_freq_${B}_path"|cut -d= -f2))" >> "$soc_parameters"
    #最小频率
    echo "vertical_core_min_freq_${B}=$(cat $(cat $soc_needs_path|grep "vertical_core_min_freq_${B}_path"|cut -d= -f2))" >> "$soc_parameters"
    #cpu频率表
    echo "vertical_core_freq_table_${B}=$(cat $(cat $soc_needs_path|grep "vertical_core_freq_table_${B}_path"|cut -d= -f2))" >> "$soc_parameters"
    #cpu频率数量
    echo "vertical_core_freq_table_number_${B}=$(cat $(cat $soc_needs_path|grep "vertical_core_freq_table_${B}_path"|cut -d= -f2)|wc -w)" >> "$soc_parameters"
    #cpu频率表
    cpu_freq_table="$(cat "$soc_parameters"|grep "vertical_core_freq_table_${B}"|cut -d= -f2|sed "s/ /\n/g"|sed "/^$/d"|sort -n|awk '{print FNR "=" $0}')"
    #cpu频率数量
    cpu_freq_number="$(cat "$soc_parameters"|grep "vertical_core_freq_table_number_${B}"|cut -d= -f2)"
    #降频最低频率设置
    for C in $(seq $cpu_freq_number)
    do
        #对频率表进行分割
        cpu_Target_freq="$(echo "$cpu_freq_table"|grep "^${C}="|cut -d= -f2)"
        #打印大于小于目标频率
        if [ $cpu_Target_freq -lt $((1000*1000)) ];then
            cpu_small_freq=$cpu_Target_freq
        else
            cpu_big_freq=$cpu_Target_freq
            break
        fi
    done
    #选择目标频率
    if [ -z "$cpu_small_freq" ];then
        #没有小于目标频率 选择大于频率
        cpu_least_freq=$cpu_big_freq
    else
        #计算
        cpu_Calculation=$((($cpu_small_freq - (1000*1000))+($cpu_big_freq - (1000*1000))))
        if [ $cpu_Calculation -le 0 ];then
            cpu_least_freq=$cpu_big_freq
        else
            cpu_least_freq=$cpu_small_freq
        fi
    fi
    if [ ! -z "$cpu_least_freq" ];then
        echo "vertical_core_least_freq_${B}=$cpu_least_freq" >> "$soc_parameters"
    fi
done


#gpu调整器
echo "gpu_adjuster=$(cat $(cat $soc_needs_path|grep "gpu_adjuster_path="|cut -d= -f2))" >> "$soc_parameters"
#gpu频率表
echo "gpu_freq_table=$(cat $(cat $soc_needs_path|grep "gpu_freq_table_path="|cut -d= -f2))" >> "$soc_parameters"
#gpu频率数量
echo "gpu_freq_number=$(cat $(cat $soc_needs_path|grep "gpu_freq_table_path="|cut -d= -f2)|wc -w)" >> "$soc_parameters"
#gpu最大频率
echo "gpu_max_freq=$(echo $(cat $(cat $soc_needs_path|grep "gpu_freq_table_path="|cut -d= -f2)|sed "s/ /\n/g"|sed "/^$/d"|sort -r)|cut -d" " -f1)" >> "$soc_parameters"
#gpu最小频率
echo "gpu_min_freq=$(echo $(cat $(cat $soc_needs_path|grep "gpu_freq_table_path="|cut -d= -f2)|sed "s/ /\n/g"|sed "/^$/d"|sort -n)|cut -d" " -f1)" >> "$soc_parameters"

#开机重置脚本
#SOC控制路径
processor="$zdy_path/processor"
if [ -f "$processor/soc_full" ];then
    rm -rf "$processor/soc_full"
fi

#清除电池记录
#参数路径
zdy_path="/cache/ZDY"
#计算电池路径
Battery_calculation="$zdy_path/Battery_calculation"
#电池容量记录
battery_volume="$Battery_calculation/battery_volume"
if [ -f "$battery_volume" ];then
    rm -rf $battery_volume
fi
#记录次数
Calculation_times="$Battery_calculation/Calculation_times"
if [ -f "$Calculation_times" ];then
    rm -rf $Calculation_times
fi
#统计前电量
Electricity_before_statistics="$Battery_calculation/Electricity_before_statistics"
if [ -f "$Electricity_before_statistics" ];then
    rm -rf $Electricity_before_statistics
fi
#统计前时间
Time_before_statistics="$Battery_calculation/Time_before_statistics"
if [ -f "$Time_before_statistics" ];then
    rm -rf $Time_before_statistics
fi
#统计类型
type01="$Battery_calculation/type"
if [ -f "$type01" ];then
    rm -rf $type01
fi

#查看电压
dmesg|grep "add_opp" > "/cache/ZDY/SOC_电压"

#执行脚本路径
#参数
parameter="/data/adb/modules/Custom_module/script/parameter.sh"
sh $parameter > /dev/null 2>&1 &
#充电温控
recharge="/data/adb/modules/Custom_module/script/recharge.sh"
sh $recharge > /dev/null 2>&1 &
#处理器温控
processor="/data/adb/modules/Custom_module/script/processor.sh"
sh $processor > /dev/null 2>&1 &
#游戏调整
game="/data/adb/modules/Custom_module/script/game.sh"
#sh $game > /dev/null 2>&1 &
#系统设置
system="/data/adb/modules/Custom_module/script/system.sh"
sh $system > /dev/null 2>&1 &
#快速寻找
search="/data/adb/modules/Custom_module/script/search.sh"
sh $search > /dev/null 2>&1 &
#写入调度
scheduling="/data/adb/modules/Custom_module/script/scheduling.sh"
sh $scheduling > /dev/null 2>&1 &
#电池记录
Battery_calculation="/data/adb/modules/Custom_module/script/Battery_calculation.sh"
sh $Battery_calculation > /dev/null 2>&1 &