#!/system/bin/sh

#执行PTC中转站，由CO_PTC调用

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
#前台app
Foreground_operation=`dumpsys window | grep "mCurrentFocus"|sed 's/{/ /g'|sed 's/}/ /g'|sed 's/\// /g'|awk '{print $4}'`
#模式切换
Current_mode=`cat /storage/emulated/TC/parameter/PTC/Current_mode`
if [ $Current_mode = 'A' ];then
    echo '默认模式'
    if [ -e $cpu7_max_freq_file_fixed ]; then
        if [ `cat $cpu7_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
            if [ -e "/storage/emulated/TC/script/PTC/PTC_daily.sh" -a -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_daily.sh" "/storage/emulated/TC/script/PTC/PTC_daily.sh"
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
           grep "$Foreground_operation" /storage/emulated/TC/parameter/app
            if [ $? -eq 0 ]; then
                sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            else
                sh "/storage/emulated/TC/script/PTC/PTC_daily.sh"
            fi
        else
            if [ -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
            sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            echo "1"
        fi
    elif [ -e $cpu5_max_freq_file_fixed ]; then
        if [ `cat $cpu5_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
            if [ -e "/storage/emulated/TC/script/PTC/PTC_daily.sh" -a -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_daily.sh" "/storage/emulated/TC/script/PTC/PTC_daily.sh"
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
            grep "$Foreground_operation" /storage/emulated/TC/parameter/app
            if [ $? -eq 0 ]; then
                sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            else
                sh "/storage/emulated/TC/script/PTC/PTC_daily.sh"
            fi
        else
            if [ -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
            sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            echo "1"
        fi
    elif [ -e $cpu3_max_freq_file_fixed ]; then
        if [ `cat $cpu3_max_freq_file_fixed` -gt `cat $Big_core_daily_frequency` ]; then
            if [ -e "/storage/emulated/TC/script/PTC/PTC_daily.sh" -a -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_daily.sh" "/storage/emulated/TC/script/PTC/PTC_daily.sh"
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
            grep "$Foreground_operation" /storage/emulated/TC/parameter/app
            if [ $? -eq 0 ]; then
                sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            else
                sh "/storage/emulated/TC/script/PTC/PTC_daily.sh"
            fi
        else
            if [ -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" -a -e "/storage/emulated/TC/parameter/app" ]; then
                echo "soc温控文件存在"
            else
                cp "/system/bin/PTC_Severe.sh" "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
                cp "/system/bin/app" "/storage/emulated/TC/parameter/app"
            fi
            sh "/storage/emulated/TC/script/PTC/PTC_Severe.sh"
            echo "1"
        fi
    fi
elif [ $Current_mode = 'B' ];then
    echo "重度模式"
    if [ -e "/storage/emulated/TC/script/PTC/PTC_Severe.sh" ];then
        sh /storage/emulated/TC/script/PTC/PTC_Severe.sh
    else
        cp /system/bin/PTC_Severe.sh /storage/emulated/TC/script/PTC/
        sh /storage/emulated/TC/script/PTC/
    fi
fi