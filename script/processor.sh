#!/system/bin/sh


#处理器控制

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#SOC控制路径
processor="$zdy_path/processor"
#按照gpu温度cpu降频温度
cpu_down_temp="$(cat "$processor/cpu_down_temp")"
#按照电池温度cpu降频阈值
cpu_down_battery_temp="$(cat "$processor/cpu_down_battery_temp")"
#按照gpu温度gpu降频温度
gpu_down_temp="$(cat "$processor/gpu_down_temp")"
#按照电池温度gpu降频阈值
gpu_down_battery_temp="$(cat "$processor/gpu_down_battery_temp")"
#按照gpu温度满血温度
soc_full_temp="$(cat "$processor/soc_full_temp")"
#按照电池温度soc满血阈值
soc_full_battery_temp="$(cat "$processor/soc_full_battery_temp")"

#参考文件参数
soc_parameters="/cache/ZDY/surroundings/soc_parameters"
#参考路径文件
soc_needs_path="/cache/ZDY/surroundings/soc_needs_path"
#gpu温度
gpu_temp="$(cat $(cat $soc_needs_path|grep "gpu_temp="|cut -d= -f2))"
#gpu温度位数
gpu_temp_wcc="$(echo $gpu_temp|wc -c)"
#gpu温度
if [ $gpu_temp_wcc -eq "4" -o $gpu_temp_wcc -eq "6" ];then
    gpu_temp="$(echo $gpu_temp|cut -c -3)"
elif [ $gpu_temp_wcc -eq "5" -o $gpu_temp_wcc -eq "7" ];then
    gpu_temp="$(echo $gpu_temp|cut -c -4)"
fi
#电池温度
Battery_temp="$(cat $(cat $soc_needs_path|grep "Battery_temp_path="|cut -d= -f2))"
#cpu总集数量
vertical_number="$(cat $soc_parameters|grep "vertical_number="|cut -d= -f2)"
#cpu最大频率总闸
cpu_control_freq_path="$(cat $soc_needs_path|grep "cpu_control_freq_path="|cut -d= -f2)"
#gpu最大频率总闸
gpu_max_freq_path="$(cat $soc_needs_path|grep "gpu_max_freq_path="|cut -d= -f2)"
#gpu最大频率
gpu_max_freq="$(cat $soc_parameters|grep "gpu_max_freq="|cut -d= -f2)"
#gpu最小频率
gpu_min_freq="$(cat $soc_parameters|grep "gpu_min_freq="|cut -d= -f2)"
#gpu频率表
gpu_freq_table="$(cat $soc_parameters|grep "gpu_freq_table="|cut -d= -f2)"

#soc满血
if [ $gpu_temp -lt $soc_full_temp -a $Battery_temp -lt $soc_full_battery_temp ];then
    echo 1
    if [ ! -f "$processor/soc_full" ];then
        #cpu满血
        for A in $(seq $vertical_number)
        do
            #cpu当前总集最大频率
            vertical_core_max_freq="$(cat $soc_parameters|grep "vertical_core_max_freq_${A}="|cut -d= -f2)"
            #cpu当前总集cpu编号
            vertical_core_number="$(cat $soc_parameters|grep "vertical_core_number_${A}="|cut -d= -f2)"
            #写入CPU满血频率
            cpu_max_freq="$(echo "$vertical_core_number"|sed "s/ /:${vertical_core_max_freq} /g"|sed "s/$/:${vertical_core_max_freq}/g")" 
            chmod 666 $cpu_control_freq_path
            echo $cpu_max_freq > $cpu_control_freq_path
            chmod 444 $cpu_control_freq_path
        done
        #gpu满血
        chmod 666 $gpu_max_freq_path
        echo $gpu_max_freq > $gpu_max_freq_path
        chmod 444 $gpu_max_freq_path
        #标记
        touch "$processor/soc_full"
    fi
fi

#cpu降频
if [ $gpu_temp -ge $cpu_down_temp -o $Battery_temp -ge $cpu_down_battery_temp ];then
    #处理标记
    if [ -f "$processor/soc_full" ];then
        rm -rf "$processor/soc_full"
    fi
    #cpu降频
    for B in $(seq $vertical_number)
    do
        #cpu当前总集最大频率
        cpu_current_max_freq="$(cat $(cat $soc_needs_path|grep "vertical_core_max_freq_path_${B}="|cut -d= -f2))"
        #cpu频率表
        cpu_Freq_table="$(cat $soc_parameters|grep "vertical_core_freq_table_${B}="|cut -d= -f2|sed "s/ /\n/g"|sed "/^$/d"|sort -n|awk '{print FNR "=" $0}')"
        #cpu降频最低频率
        cpu_least_freq="$(cat $soc_parameters|grep "vertical_core_least_freq_${B}="|cut -d= -f2)"
        #cpu当前总集cpu编号
        vertical_core_number="$(cat $soc_parameters|grep "vertical_core_number_${B}="|cut -d= -f2)"
        #当前最大频率位置
        cpu_freq_location="$(echo "$cpu_Freq_table"|grep "$cpu_current_max_freq"|cut -d= -f1)"
        #写入下个频率
        if [ -z "$cpu_freq_location" ];then
            vertical_core_max_freq="$(echo $cpu_Freq_table|awk '{print $NF}'|cut -d= -f2)"
        else
            if [ $cpu_freq_location -le "2" ];then
                vertical_core_max_freq=$cpu_least_freq
            else
                Next_position="$(($cpu_freq_location-1))"
                vertical_core_max_freq="$(echo "$cpu_Freq_table"|grep "${Next_position}="|cut -d= -f2)"
                if [ "$vertical_core_max_freq" -le "$cpu_least_freq" ];then
                    vertical_core_max_freq=$cpu_least_freq
                fi
            fi
        fi
        cpu_max_freq="$(echo "$vertical_core_number"|sed "s/ /:${vertical_core_max_freq} /g"|sed "s/$/:${vertical_core_max_freq}/g")"
        chmod 666 $cpu_control_freq_path
        echo $cpu_max_freq > $cpu_control_freq_path
        chmod 444 $cpu_control_freq_path
    done
fi

#gpu降频
if [ $gpu_temp -ge $gpu_down_temp -o $Battery_temp -ge $gpu_down_battery_temp ];then
    #当前最大频率
    gpu_current_max_freq="$(cat $gpu_max_freq_path)"
    #频率表
    gpu_freq_table="$(echo $gpu_freq_table|sed "s/ /\n/g"|sed "/^$/d"|sort -n|awk '{print FNR "=" $0}')"
    #当前最大频率位置
    gpu_freq_location="$(echo "$gpu_freq_table"|grep "$gpu_current_max_freq"|cut -d= -f1)"
    #写入下个频率
    if [ $gpu_freq_location -le "2" ];then
        gpu_max_freq=$gpu_min_freq
    else
        Next_position="$(($gpu_freq_location-1))"
        gpu_max_freq="$(echo "$gpu_freq_table"|grep "${Next_position}="|cut -d= -f2)"
    fi
    chmod 666 $gpu_max_freq_path
    echo $gpu_max_freq > $gpu_max_freq_path
    chmod 444 $gpu_max_freq_path
fi
sleep 1
done