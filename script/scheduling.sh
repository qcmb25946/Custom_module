#!/system/bin/sh


#调度

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#调度参数路径
scheduling="$zdy_path/scheduling"
#cpu满血
soc_full="$zdy_path/processor/soc_full"
#调度开关
switch="$(cat "$scheduling/switch")"
#调度文件夹
file="$(cat "$scheduling/file")"

#当前运行app
Foreground_operation=$(echo $(dumpsys window|grep "mCurrentFocus"|sed 's/{/ /g'|sed 's/}/ /g'|sed 's/\// /g')|cut -d" " -f4)
#参数
soc_file="$scheduling/${file}"
#模式
mode="$(cat "$soc_file/mode")"
if [ "$mode" = "A" -o -z "$Foreground_operation" ];then
    mode=default
else
    method="$(cat "$soc_file/type"|grep "=${Foreground_operation}="|cut -d= -f1)"
    if [ -z "$method" ];then
        mode=default
    else
        mode=$method
    fi
    
fi
#调度路径
parameter_path="$soc_file/default/$mode"
#转大核心负载
vertical_core_transfer_big_core="$(cat "$parameter_path"|grep "vertical_core_transfer_big_core"|cut -d= -f2)"
#转小核心负载
vertical_core_transfer_small_core="$(cat "$parameter_path"|grep "vertical_core_transfer_small_core"|cut -d= -f2)"
#前台负载
vertical_core_front="$(cat "$parameter_path"|grep "vertical_core_front="|cut -d= -f2)"
#前台界面负载
vertical_core_front_interface="$(cat "$parameter_path"|grep "vertical_core_front_interface="|cut -d= -f2)"
#后台负载
vertical_core_Background="$(cat "$parameter_path"|grep "vertical_core_Background"|cut -d= -f2)"
#系统后台负载
vertical_core_system_background="$(cat "$parameter_path"|grep "vertical_core_system_background"|cut -d= -f2)"

#参数路径
soc_needs_path="/cache/ZDY/surroundings/soc_needs_path"
#转大核心负载路径
sched_upmigrate="$(cat "$soc_needs_path"|grep "sched_upmigrate"|cut -d= -f2)"
#转小核心负载路径
sched_downmigrate="$(cat "$soc_needs_path"|grep "sched_downmigrate"|cut -d= -f2)"
#前台负载路径
foreground="$(cat "$soc_needs_path"|grep "foreground="|cut -d= -f2)"
#前台界面负载路径
top_app="$(cat "$soc_needs_path"|grep "top_app="|cut -d= -f2)"
#后台负载路径
background="$(cat "$soc_needs_path"|grep "^background="|cut -d= -f2)"
#系统后台负载路径
system_background="$(cat "$soc_needs_path"|grep "system_background="|cut -d= -f2)"

#参考文件参数
soc_parameters="/cache/ZDY/surroundings/soc_parameters"
#cpu总集数量
vertical_number="$(cat $soc_parameters|grep "vertical_number="|cut -d= -f2)"

#cpu调度
cpu_scheduling(){
#转大核心负载
if [ "$vertical_core_transfer_big_core" != "$(echo $(cat $sched_upmigrate))" ];then
    echo $vertical_core_transfer_big_core > $sched_upmigrate
fi
#转小核心负载
if [ "$vertical_core_transfer_small_core" != "$(echo $(cat $sched_downmigrate))" ];then
    echo $vertical_core_transfer_small_core > $sched_downmigrate
fi
#前台负载
if [ "$vertical_core_front" != "$(echo $(cat $foreground))" ];then
    chmod 666 $foreground
    echo $vertical_core_front > $foreground
    chmod 444 $foreground
fi
#前台界面负载
if [ "$vertical_core_front_interface" != "$(echo $(cat $top_app))" ];then
    chmod 666 $top_app
    echo $vertical_core_front_interface > $top_app
    chmod 444 $top_app
fi
#后台负载
if [ "$vertical_core_Background" != "$(echo $(cat $background))" ];then
    chmod 666 $background
    echo $vertical_core_Background > $background
    chmod 444 $background
fi
#系统后台负载
if [ "$vertical_core_system_background" != "$(echo $(cat $system_background))" ];then
    chmod 666 $system_background
    echo $vertical_core_system_background > $system_background
    chmod 444 $system_background
fi
for A in $(seq $vertical_number)
do
    #调整器
    cpu_adjuster="$(cat "$parameter_path"|grep "vertical_core_adjuster_${A}"|cut -d= -f2)"
    #升频负载
    cpu_hispeed_load="$(cat "$parameter_path"|grep "vertical_core_hispeed_load_${A}"|cut -d= -f2)"
    #升频频率
    cpu_hispeed_freq="$(cat "$parameter_path"|grep "vertical_core_hispeed_freq_${A}"|cut -d= -f2)"
    #加速频率
    cpu_boost_freq="$(cat "$parameter_path"|grep "vertical_core_boost_freq_${A}"|cut -d= -f2)"
    #最高频率
    cpu_max_freq="$(cat "$parameter_path"|grep "vertical_core_max_freq_${A}"|cut -d= -f2)"
    #最低频率
    cpu_min_freq="$(cat "$parameter_path"|grep "vertical_core_min_freq_${A}"|cut -d= -f2)"
    
    #调整器路径
    cpu_adjuster_path="$(cat "$soc_needs_path"|grep "^vertical_core_Current_adjuster_path_${A}="|cut -d= -f2)"
    #升频负载路径
    cpu_up_threshold_path="$(cat "$soc_needs_path"|grep "^vertical_core_ondemand_up_threshold_path_${A}="|cut -d= -f2)"
    cpu_hispeed_load_path="$(cat "$soc_needs_path"|grep "^vertical_core_schedutil_hispeed_load_path_${A}="|cut -d= -f2)"
    #升频频率路径
    cpu_hispeed_freq_path="$(cat "$soc_needs_path"|grep "^vertical_core_schedutil_hispeed_freq_path_${A}="|cut -d= -f2)"
    #加速频率路径
    cpu_boost_freq_path="$(cat "$soc_needs_path"|grep "^vertical_core_schedutil_boost_freq_path_${A}="|cut -d= -f2)"
    #最高频率路径
    cpu_max_freq_path="$(cat "$soc_needs_path"|grep "^vertical_core_max_freq_path_${A}="|cut -d= -f2)"
    #最低频率路径
    cpu_min_freq_path="$(cat "$soc_needs_path"|grep "^vertical_core_min_freq_path_${A}="|cut -d= -f2)"
    #调整器
    if [ "$cpu_adjuster" != "$(cat $cpu_adjuster_path)" ];then
        chmod 666 $cpu_adjuster_path
        echo $cpu_adjuster > $cpu_adjuster_path
        chmod 444 $cpu_adjuster_path
    fi
    #调度
    if [ "$(cat $cpu_adjuster_path)" = "schedutil" ];then
        #升频负载
        if [ "$cpu_hispeed_load" != "$(cat $cpu_hispeed_load_path)" ];then
            chmod 666 $cpu_hispeed_load_path
            echo $cpu_hispeed_load > $cpu_hispeed_load_path
            chmod 444 $cpu_hispeed_load_path
        fi
        #升频频率
        if [ "$cpu_hispeed_freq" != "$(cat $cpu_hispeed_freq_path)" ];then
            chmod 666 $cpu_hispeed_freq_path
            echo $cpu_hispeed_freq > $cpu_hispeed_freq_path
            chmod 444 $cpu_hispeed_freq_path
        fi
        #加速频率
        if [ "$cpu_boost_freq" != "$(cat $cpu_boost_freq_path)" ];then
            echo $cpu_boost_freq $(cat $cpu_boost_freq_path)
            chmod 666 $cpu_boost_freq_path
            echo $cpu_boost_freq > $cpu_boost_freq_path
            chmod 444 $cpu_boost_freq_path
        fi
    elif [ "$(cat $cpu_adjuster_path)" = "ondemand" ];then
        #升频频率
        if [ "$cpu_hispeed_load" != "$(cat $cpu_up_threshold_path)" ];then
            chmod 666 $cpu_up_threshold_path
            echo $cpu_hispeed_load > $cpu_up_threshold_path
            chmod 444 $cpu_up_threshold_path
        fi
    fi
    #最高频率
    if [ "$cpu_max_freq" != "$(cat $cpu_max_freq_path)" ];then
        chmod 666 $cpu_max_freq_path
        echo $cpu_max_freq > $cpu_max_freq_path
        chmod 444 $cpu_max_freq_path
    fi
    #最低频率
    if [ "$cpu_min_freq" != "$(cat $cpu_min_freq_path)" ];then
        chmod 666 $cpu_min_freq_path
        echo $cpu_min_freq > $cpu_min_freq_path
        chmod 444 $cpu_min_freq_path
    fi
done
}

#执行脚本条件
if [ -f "$soc_full" ];then
    if [ "$switch" = "Y" ];then
        cpu_scheduling
    fi
fi
sleep 1
done