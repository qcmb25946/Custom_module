#处理器温控总开关，调用PTC_Transit.sh文件

while true
do
#温控文件
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
Current_mode=/storage/emulated/TC/parameter/PTC/Current_mode
#电池温度
battery_temp_dir=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
protect_yourself=`cat /storage/emulated/TC/parameter/PTC/protect_yourself`
#路径
ptc_path=/data/adb/modules/Custom_temperature_control/script/
tc_path=/storage/emulated/TC/
Screen_extinguishing_switch=${tc_path}parameter/PTC/Screen_extinguishing_switch
judge=${tc_path}parameter/PTC/judge
cpu0_max_freq_file_fixed="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
cpu1_max_freq_file_fixed="/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq"
cpu2_max_freq_file_fixed="/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_max_freq"
cpu3_max_freq_file_fixed="/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq"
cpu4_max_freq_file_fixed="/sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq"
cpu5_max_freq_file_fixed="/sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_max_freq"
cpu6_max_freq_file_fixed="/sys/devices/system/cpu/cpu6/cpufreq/cpuinfo_max_freq"
cpu7_max_freq_file_fixed="/sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"
#cpumax频率
Big_core_daily_frequency="/storage/emulated/TC/parameter/PTC/Big_core_daily_frequency"
#判断是否亮屏
screen=`dumpsys window policy | grep "mInputRestricted"|cut -d= -f2`
#模式切换
Current_mode=`cat /storage/emulated/TC/parameter/PTC/Current_mode`

#调用文件
PTC_Transit(){
if [ $Current_mode = 'A' ];then
    if [ `cat $Screen_extinguishing_switch` = "K" ];then
        Mode_switch
    else
        Daily_mode
    fi
elif [ $Current_mode = 'B' ];then
    sh ${ptc_path}PTC_Severe.sh
fi
}
Daily_mode(){
if [ -e $judge ];then
    rm -rf $judge
fi
#判断前台APP
Foreground_operation=`dumpsys window | grep "mCurrentFocus"|sed 's/{/ /g'|sed 's/}/ /g'|sed 's/\// /g'|awk '{print $4}'`
#判断运行模式
search_for=`grep "$Foreground_operation" /data/adb/modules/Custom_temperature_control/file/app|sed 's/ /_/g'`
if [ -e $cpu7_max_freq_file_fixed ]; then
   if [ `cat $cpu7_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
        if [ -z $Foreground_operation ];then
            sh "${ptc_path}PTC_daily.sh"
        else
            if [ -z $search_for ];then
                sh "${ptc_path}PTC_daily.sh"
            else
                sh "${ptc_path}PTC_Severe.sh"
            fi
        fi
    else
        sh "${ptc_path}PTC_Severe.sh"
    fi
elif [ -e $cpu5_max_freq_file_fixed ]; then
    if [ `cat $cpu5_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
        if [ -z $Foreground_operation ];then
            sh "${ptc_path}PTC_daily.sh"
        else
            if [ -z $search_for ];then
                sh "${ptc_path}PTC_daily.sh"
            else
                sh "${ptc_path}PTC_Severe.sh"
            fi
        fi
    else
        sh "${ptc_path}PTC_Severe.sh"
    fi
elif [ -e $cpu3_max_freq_file_fixed ]; then
    if [ `cat $cpu3_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
        if [ -z $Foreground_operation ];then
            sh "${ptc_path}PTC_daily.sh"
        else
            if [ -z $search_for ];then
                sh "${ptc_path}PTC_daily.sh"
            else
                sh "${ptc_path}PTC_Severe.sh"
            fi
        fi
    else
        sh "${ptc_path}PTC_Severe.sh"
    fi
fi
}
Mode_switch(){
if [ $screen = 'false' ];then
    Daily_mode
else
    echo $screen
    if [ ! -e $judge ];then
        number=`cat ${tc_path}parameter/PTC/number`
        for Countdown in $(seq $number)
        do
            sleep 1
            screen=`dumpsys window policy | grep "mInputRestricted"|cut -d= -f2`
            Daily_mode
            if [ $screen = 'false' ];then
                break
            else
                if [ $Countdown -eq $number ];then
                    touch $judge
                fi
            fi
        done
    else
        sh ${ptc_path}PTC_Screen_off.sh
    fi
fi
}
#关闭doze
dumpsys deviceidle disable
#温控总开关
if [ $protect_yourself -gt $battery_temp_dir ];then
    if [ `cat $switch` = 'K' ];then
        PTC_Transit
    fi
elif [ $protect_yourself -le $battery_temp_dir ];then
    if [ `cat $switch` = 'K' -a $Current_mode = 'A' ];then
        sh /data/adb/modules/Custom_temperature_control/script/PTC_protection.sh
    else
        reboot -p
    fi
fi
sleep 1
done