#!/system/bin/sh

#安装脚本

#默认不动
SKIPMOUNT=false
#如果想启用system.prop的参数，则改为true
PROPFILE=false
#开机前执行的命令，想启用则改为true
POSTFSDATA=false
#开机后执行的命令，想启用则改为true
LATESTARTSERVICE=true
#模块介绍
Module_introduction(){
echo "欢迎使用自定义模块"
echo "日期：$(date "+%Y-%m-%d %H:%M:%S")"
echo "作者：千城墨白"
}
#创建环境
Create_environment(){
#清楚未找到文件路径
Path_not_found="/cache/未找到路径"
if [ -f "$Path_not_found" ];then
    rm -rf "$Path_not_found"
fi
#判断是否创建环境
if [ ! -f "/cache/ZDY/surroundings/ZDY-2020.04.01" ];then
    echo "该手机没有创建环境"
    echo "开始为脚本创建环境"
    #判断是否创建环境文件夹
    surroundings="/cache/ZDY/surroundings"
    if [ ! -d "$surroundings" ];then
        mkdir -p $surroundings
    fi
    #充电
    #充电速度控制文件路径
    Charging_control_path="$(find "/sys/class/power_supply/battery/" -type f|egrep "charge_current|current_max"|sort -u)"
    if [ ! -z "$Charging_control_path" ];then
        echo "$Charging_control_path"|sed "s/^/cat \"/g"|sed "s/$/\"/g" > "$surroundings/View_current_limit.sh"
        echo "$Charging_control_path"|sed "s/^/chmod 666 \"/g"|sed "s/$/\"/g" > "$surroundings/Write_current_limit.sh"
        echo "$Charging_control_path"|sed "s/^/echo \$current_max \> \"/g"|sed "s/$/\"/g" >> "$surroundings/Write_current_limit.sh"
        echo "$Charging_control_path"|sed "s/^/chmod 444 \"/g"|sed "s/$/\"/g" >> "$surroundings/Write_current_limit.sh"
    else
        echo "充电控制路径未找到" > "$Path_not_found"
    fi
    #电池温度路径
    if [ -f "/sys/class/power_supply/battery/temp" ];then
        echo "Battery_temp_path=/sys/class/power_supply/battery/temp" > "$surroundings/Charge_control_needs_path"
        echo "Battery_temp_path=/sys/class/power_supply/battery/temp" > "$surroundings/soc_needs_path"
    elif [ -f "/sys/class/power_supply/bms/temp" ];then
        echo "Battery_temp_path=/sys/class/power_supply/bms/temp" > "$surroundings/Charge_control_needs_path"
        echo "Battery_temp_path=/sys/class/power_supply/bms/temp" > "$surroundings/soc_needs_path"
    else
        echo "电池温度路径未找到" >> "$Path_not_found"
    fi
    #电池电量路径
    if [ -f "/sys/class/power_supply/battery/capacity" ];then
        echo "Battery_path=/sys/class/power_supply/battery/capacity" >> "$surroundings/Charge_control_needs_path"
    elif [ -f "/sys/class/power_supply/bms/capacity" ];then
        echo "Battery_path=/sys/class/power_supply/bms/capacity" >> "$surroundings/Charge_control_needs_path"
    else
        echo "电池电量路径未找到" >> "$Path_not_found"
    fi
    #电池总容量路径
    if [ -f "/sys/class/power_supply/battery/charge_full" ];then
        echo "Total_battery_capacity_path=/sys/class/power_supply/battery/charge_full" >> "$surroundings/Charge_control_needs_path"
    elif [ -f "/sys/class/power_supply/bms/charge_full" ];then
        echo "Total_battery_capacity_path=/sys/class/power_supply/bms/charge_full" >> "$surroundings/Charge_control_needs_path"
    else
        echo "电池总容量路径未找到" >> "$Path_not_found"
    fi
    #电池充短电路径
    if [ -f "/sys/class/power_supply/battery/input_suspend" ];then
        echo "Battery_breaking_path=/sys/class/power_supply/battery/input_suspend" >> "$surroundings/Charge_control_needs_path"
        echo "Battery_guide=0" >> "$surroundings/Charge_control_needs_path"
    elif [ -f "/sys/class/power_supply/battery/battery_charging_enabled" ];then
        echo "Battery_breaking_path=/sys/class/power_supply/battery/battery_charging_enabled" >> "$surroundings/Charge_control_needs_path"
        echo "Battery_guide=1" >> "$surroundings/Charge_control_needs_path"
    else
        echo "电池充断电路径未找到" >> "$Path_not_found"
    fi
    #充电提示路径
    if [ -f "/sys/class/power_supply/usb/present" ];then
        echo "Charging_judgment_path=/sys/class/power_supply/usb/present" >> "$surroundings/Charge_control_needs_path"
    elif [ -f "/sys/class/power_supply/usb/online" ];then
        echo "Charging_judgment_path=/sys/class/power_supply/usb/online" >> "$surroundings/Charge_control_needs_path"
    else
        echo "充电提示路径未找到" >> "$Path_not_found"
    fi
    #分断充电路径
    if [ -f "/sys/class/power_supply/battery/step_charging_enabled" ];then
        echo "Break_charging_path=/sys/class/power_supply/battery/step_charging_enabled" >> "$surroundings/Charge_control_needs_path"
    fi
    #当前电流路径
    if [ -f "/sys/class/power_supply/battery/current_now" ];then
        echo "Current_battery_path=/sys/class/power_supply/battery/current_now" >> "$surroundings/Charge_control_needs_path"
    elif [ -f "/sys/class/power_supply/bms/current_now" ];then
        echo "Current_battery_path=/sys/class/power_supply/bms/current_now" >> "$surroundings/Charge_control_needs_path"
    else
        echo "当前电流路径未找到" >> "$Path_not_found"
    fi
    #处理器
    #CPU调整器路径
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ];then
        echo "cpu_adjuster_path=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" >> "$surroundings/soc_needs_path"
    else
        echo "cpu调整器路径未找到" >> "$Path_not_found"
    fi
    #cpu控制频率路径
    if [ -f "/sys/module/msm_performance/parameters/cpu_max_freq" ];then
        echo "cpu_control_freq_path=/sys/module/msm_performance/parameters/cpu_max_freq" >> "$surroundings/soc_needs_path"
    else
        echo "cpu控制频率路径未找到" >> "$Path_not_found"
    fi
    #gpu温度路径
    if [ -f "/sys/class/thermal/thermal_zone10/temp" ];then
        echo "gpu_temp=/sys/class/thermal/thermal_zone10/temp" >> "$surroundings/soc_needs_path"
    else
        echo "gpu温度路径未找到" >> "$Path_not_found"
    fi
    #cpu当前频率路径
    if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq" ];then
        echo "cpu_Current_schedule_path_${B}=/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq" >> "$surroundings/soc_needs_path"
    else
        echo "cpu当前频率未找到" >> "$Path_not_found"
    fi
    #CPU最高编号
    if [ -f "/sys/devices/system/cpu/kernel_max" ];then
        echo "kernel_max_path=/sys/devices/system/cpu/kernel_max" >> "$surroundings/soc_needs_path"
        kernel_max="$(cat /sys/devices/system/cpu/kernel_max)"
    else
        echo "cpu最高编号路径未找到" >> "$Path_not_found"
    fi
    #CPU转小核心负载路径
    if [ -f "/proc/sys/kernel/sched_downmigrate" ];then
        echo "sched_downmigrate=/proc/sys/kernel/sched_downmigrate" >> "$surroundings/soc_needs_path"
    else
        echo "cpu转小核心负载路径未找到" >> "$Path_not_found"
    fi
    #CPU转大核心负载路径
    if [ -f "/proc/sys/kernel/sched_upmigrate" ];then
        echo "sched_upmigrate=/proc/sys/kernel/sched_upmigrate" >> "$surroundings/soc_needs_path"
    else
        echo "cpu转大核心负载路径未找到" >> "$Path_not_found"
    fi
    #CPUS前台界面路径
    if [ -f "/dev/cpuset/top-app/cpus" ];then
        echo "top_app=/dev/cpuset/top-app/cpus" >> "$surroundings/soc_needs_path"
    else
        echo "cpus前台界面路径未找到" >> "$Path_not_found"
    fi
    #CPUS前台路径
    if [ -f "/dev/cpuset/foreground/cpus" ];then
        echo "foreground=/dev/cpuset/foreground/cpus" >> "$surroundings/soc_needs_path"
    else
        echo "cpus前台路径未找到" >> "$Path_not_found"
    fi
    #CPUS后台路径
    if [ -f "/dev/cpuset/background/cpus" ];then
        echo "background=/dev/cpuset/background/cpus" >> "$surroundings/soc_needs_path"
    else
        echo "cpus后台路径未找到" >> "$Path_not_found"
    fi
    #CPUS系统后台路径
    if [ -f "/dev/cpuset/system-background/cpus" ];then
        echo "system_background=/dev/cpuset/system-background/cpus" >> "$surroundings/soc_needs_path"
    else
        echo "cpus系统后台路径未找到" >> "$Path_not_found"
    fi
    #对CPU进行分析
    if [ ! -z "$kernel_max" ];then
        if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus" ];then
            if [ -f "$surroundings/cpu_tmp" ];then
                rm -rf "$surroundings/cpu_tmp"
            fi
            for A in $(seq 0 $kernel_max)
            do
                cat "/sys/devices/system/cpu/cpu$A/cpufreq/affected_cpus" >> "$surroundings/cpu_tmp"
            done
            #cpu总集数
            vertical_number="$(cat "$surroundings/cpu_tmp"|sort -u|cut -c1|wc -w)"
            #cpu纵集
            vertical="$(cat "$surroundings/cpu_tmp"|sort -u|cut -c1)"
            rm -rf "$surroundings/cpu_tmp"
            for B in $(seq $vertical_number)
            do
                #cpu编号
                vertical_core="$(echo $vertical|cut -d" " -f${B})"
                #cpu最大频率路径
                if [ -f "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/cpuinfo_max_freq" ];then
                    echo "vertical_core_max_freq_${B}_path=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/cpuinfo_max_freq" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu_max_freq_${vertical_core}未找到" >> "$Path_not_found"
                fi
                #cpu最小频率路径
                if [ -f "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/cpuinfo_min_freq" ];then
                    echo "vertical_core_min_freq_${B}_path=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/cpuinfo_min_freq" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu_min_freq_${vertical_core}未找到" >> "$Path_not_found"
                fi
                #cpu频率表路径
                if [ -f "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_available_frequencies" ];then
                    echo "vertical_core_freq_table_${B}_path=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_available_frequencies" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu_freq_table_${vertical_core}未找到" >> "$Path_not_found"

                fi
                #cpu控制最大频率路径
                if [ -f "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_max_freq" ];then
                    echo "vertical_core_max_freq_path_${B}=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_max_freq" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu_max_freq_path_${vertical_core}未找到" >> "$Path_not_found"
                fi
                #cpu控制最小频率路径
                if [ -f "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_min_freq" ];then
                    echo "vertical_core_min_freq_path_${B}=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_min_freq" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu_min_freq_path_${vertical_core}未找到" >> "$Path_not_found"
                fi
                #cpu当前频率
                if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" ];then
                    echo "vertical_core_Current_adjuster_path_${B}=/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor" >> "$surroundings/soc_needs_path"
                else
                    echo "cpu当前频率_${vertical_core}未找到" >> "$Path_not_found"
                fi
                #cpu调度
                if [ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ];then
                    cpu_adjuster=$(cat "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors")
                    #ondemand调度参数
                    if [ ! -z "$(echo "$cpu_adjuster"|grep "ondemand")" ];then
                        chmod 666 "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        echo "ondemand" > "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        chmod 444 "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        sleep 1
                        if [ -d "/sys/devices/system/cpu/cpufreq/policy${vertical_core}/ondemand" ];then
                            echo "vertical_core_ondemand_up_threshold_path_${B}=/sys/devices/system/cpu/cpufreq/policy${vertical_core}/ondemand/up_threshold" >> "$surroundings/soc_needs_path"
                        elif [ -d "/sys/devices/system/cpu/cpufreq/ondemand" ];then
                            echo "vertical_core_ondemand_up_threshold_path_${B}=/sys/devices/system/cpu/cpufreq/ondemand/up_threshold" >> "$surroundings/soc_needs_path"
                        else
                            ondemand="cpu_${vertical_core}ondemand路径未找到"
                            echo "/sys/devices/system/cpu/cpufreq/policy${vertical_core}/ondemand"
                        fi
                    fi
                    #schedutil调度参数
                    if [ ! -z "$(echo "$cpu_adjuster"|grep "schedutil")" ];then
                        chmod 666 "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        echo "schedutil" > "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        chmod 444 "/sys/devices/system/cpu/cpu${vertical_core}/cpufreq/scaling_governor"
                        sleep 1
                        if [ -d "/sys/devices/system/cpu/cpufreq/policy${vertical_core}/schedutil" ];then
                            echo "vertical_core_schedutil_hispeed_load_path_${B}=/sys/devices/system/cpu/cpufreq/policy${vertical_core}/schedutil/hispeed_load" >> "$surroundings/soc_needs_path"
                            echo "vertical_core_schedutil_hispeed_freq_path_${B}=/sys/devices/system/cpu/cpufreq/policy${vertical_core}/schedutil/hispeed_freq" >> "$surroundings/soc_needs_path"
                            echo "vertical_core_schedutil_boost_freq_path_${B}=/sys/devices/system/cpu/cpufreq/policy${vertical_core}/schedutil/rtg_boost_freq" >> "$surroundings/soc_needs_path"
                        elif [ -d "/sys/devices/system/cpu/cpufreq/schedutil" ];then
                            echo "vertical_core_schedutil_hispeed_load_path_${B}=/sys/devices/system/cpu/cpufreq/schedutil/hispeed_load" >> "$surroundings/soc_needs_path"
                            echo "vertical_core_schedutil_hispeed_freq_path_${B}=/sys/devices/system/cpu/cpufreq/schedutil/hispeed_freq" >> "$surroundings/soc_needs_path"
                            echo "vertical_core_schedutil_boost_freq_path_${B}=/sys/devices/system/cpu/cpufreq/schedutil/rtg_boost_freq" >> "$surroundings/soc_needs_path"
                        else
                            schedutil="cpu_${vertical_core}_schedutil路径未找到"
                            echo "/sys/devices/system/cpu/cpufreq/policy${vertical_core}/schedutil"
                        fi
                    fi
                    if [ -z "$(echo "$cpu_adjuster"|grep "ondemand")" -a ! -z "$(echo "$cpu_adjuster"|grep "schedutil")" ];then
                        echo "当前暂时不支持cpu_${vertical_core}调度" > "$Path_not_found"
                    fi
                    if [ ! -z "$ondemand" -a ! -z "$schedutil" ];then
                        echo $ondemand $schedutil
                        echo "cpu_${vertical_core}调度路径未找到" >> "$Path_not_found"
                    fi
                else
                    echo "cpu_${vertical_core}调整器路径未找到" >> "$Path_not_found"
                fi
            done
        fi
    fi
    #gpu调整器路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/available_governors" ];then
        echo "gpu_adjuster_path=/sys/class/kgsl/kgsl-3d0/devfreq/available_governors" >> "$surroundings/soc_needs_path"
    else
        echo "gpu调整器路径未找到" >> "$Path_not_found"
    fi
    #gpu频率表路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies" ];then
        echo "gpu_freq_table_path=/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies" >> "$surroundings/soc_needs_path"
    else
        echo "gpu频率表路径未找到" >> "$Path_not_found"
    fi
    #gpu频率最大控制路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/max_freq" ];then
        echo "gpu_max_freq_path=/sys/class/kgsl/kgsl-3d0/devfreq/max_freq" >> "$surroundings/soc_needs_path"
    else
        echo "gpu频率最大控制路径未找到" >> "$Path_not_found"
    fi
    #gpu频率最小控制路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/min_freq" ];then
        echo "gpu_min_freq_path=/sys/class/kgsl/kgsl-3d0/devfreq/min_freq" >> "$surroundings/soc_needs_path"
    else
        echo "gpu频率最小控制路径未找到" >> "$Path_not_found"
    fi
    #gpu当前调整器路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ];then
        echo "gpu_Current_regulator_path=/sys/class/kgsl/kgsl-3d0/devfreq/governor" >> "$surroundings/soc_needs_path"
    else
        echo "gpu当前调整器路径未找到" >> "$Path_not_found"
    fi
    #gpu当前频率路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/cur_freq" ];then
        echo "gpu_Current_freq_path=/sys/class/kgsl/kgsl-3d0/devfreq/cur_freq" >> "$surroundings/soc_needs_path"
    else
        echo "gpu当前频率路径未找到" >> "$Path_not_found"
    fi
    #gpu当前频率百分比路径
    if [ -f "/sys/class/kgsl/kgsl-3d0/devfreq/gpu_load" ];then
        echo "gpu_Current_freq_occupation_path=/sys/class/kgsl/kgsl-3d0/devfreq/gpu_load" >> "$surroundings/soc_needs_path"
    else
        echo "gpu当前频率百分比路径未找到" >> "$Path_not_found"
    fi
    #联系作者解决问题
    if [ -f "$Path_not_found" ];then
        rm -rf "/cache/ZDY/"
        echo "有未找到的文件路径"
        echo "请将'${Path_not_found}'转交给作者"
        echo "请用一下方式联系作者解决问题"
        echo "1.QQ：501674112"
        echo "2.QQ群：910560489"
        echo "3.VX：c501674112"
        exit
    fi
    echo "环境搞定"
    #创建标志防止反复创建环境
    if [ ! -f "$surroundings/ZDY-2020.04.01" ];then
        touch "$surroundings/ZDY-2020.04.01"
    fi
else
    echo "该手机已创建过环境；跳过"
fi
}
#去除温控
Remove_temp_control(){
Delete_temperature_control=#data#adb#modules_update#Custom_module
#小米手机去除温控
echo "开始去除温控"
if [ `getprop ro.product.brand` = 'Redmi' -o `getprop ro.product.brand` = 'Xiaomi' ];then
    echo "已检测是小米手机正在安装小米方式去除温控"
    if [ ! -f "/data/vendor/thermal" ];then
        if [ ! -d "/data/vendor/thermal" ];then
            echo "干翻温控" > /data/vendor/thermal
            chattr +i /data/vendor/thermal
        else
            rm -rf /data/vendor/thermal
            echo "干翻温控" > /data/vendor/thermal
            chattr +i /data/vendor/thermal
        fi
    fi
fi
    find /system/ -name '*thermal*' > /cache/Delete_temperature_control
    find /system/vendor/ -name '*thermal*' >> /cache/Delete_temperature_control
    if [ `getprop ro.product.brand` = 'asus' ];then
    cat /cache/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v '.so' > /cache/干温控.sh
    elif [ `getprop ro.product.brand` = 'lge' ];then
    cat /cache/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v "/vendor/bin/thermal-engine" > /cache/干温控.sh
    elif [ `getprop ro.product.brand` = 'Coolpad' ];then
    cat /cache/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v "client"|grep -v "ioctl" > /cache/干温控.sh
    else
    cat /cache/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice' > /cache/干温控.sh
    fi
    sed -i "s/^/mkdir -p $Delete_temperature_control/g" /cache/干温控.sh
    sed -i "s/#/\//g" /cache/干温控.sh
    sh /cache/干温控.sh
    sed -i "s/mkdir -p/rm -rf/g" /cache/干温控.sh
    sh /cache/干温控.sh
    sed -i 's/rm -rf/touch/g' /cache/干温控.sh
    sh /cache/干温控.sh
    rm -rf /cache/Delete_temperature_control
    rm -rf /cache/干温控.sh
if [ -f "/system/vendor/etc/perf/perfboostsconfig.xml" ];then
    mkdir -p "$(echo "${Delete_temperature_control}/system/vendor/etc/perf/perfboostsconfig.xml"|sed "s/#/\//g")"
    rm -rf "$(echo "${Delete_temperature_control}/system/vendor/etc/perf/perfboostsconfig.xml"|sed "s/#/\//g")"
    echo "" > "$(echo "${Delete_temperature_control}/system/vendor/etc/perf/perfboostsconfig.xml"|sed "s/#/\//g")"
fi
echo "搞定"
}
#释放文件
Release_file(){
echo "开始释放文件"
unzip -o "$ZIPFILE" 'parameter/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'save_brick/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'script/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'start/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
echo "搞定"
}
#模块介绍
Module_introduction
#创建环境
Create_environment
#去除温控
Remove_temp_control
#释放文件
Release_file