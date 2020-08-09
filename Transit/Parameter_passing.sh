#!/system/bin/sh

#参数

#路径
tc_path=/storage/emulated/TC/
#模式切换
Current_mode=${tc_path}parameter/PTC/Current_mode
#识别处理器
Identify=`getprop ro.board.platform`
#分辨机型
Identify_models=`getprop ro.product.device`
#cpu固定最大频率
cpu3_max_freq_file_fixed="/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq"
cpu7_max_freq_file_fixed="/sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"
#CPU频率表
cpu0_Frequency_table=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
cpu1_Frequency_table=/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
cpu2_Frequency_table=/sys/devices/system/cpu/cpu2/cpufreq/scaling_available_frequencies
cpu3_Frequency_table=/sys/devices/system/cpu/cpu3/cpufreq/scaling_available_frequencies
cpu4_Frequency_table=/sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies
cpu5_Frequency_table=/sys/devices/system/cpu/cpu5/cpufreq/scaling_available_frequencies
cpu6_Frequency_table=/sys/devices/system/cpu/cpu6/cpufreq/scaling_available_frequencies
cpu7_Frequency_table=/sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies
#控制cpu最大频率路径
cpu0_max_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
cpu1_max_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"
cpu2_max_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu4_max_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu6_max_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
#控制cpu最小频率路径
cpu0_min_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
cpu1_min_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq"
cpu2_min_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq"
cpu3_min_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq"
cpu4_min_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq"
cpu5_min_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq"
cpu6_min_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq"
cpu7_min_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq"
#cpu控制频率
#温控设置
if [ -e '/sys/module/msm_thermal/core_control/enabled' ];then
    if [ ! `cat /sys/module/msm_thermal/core_control/enabled` -eq 0 ];then
        echo 0 > /sys/module/msm_thermal/core_control/enabled
    fi
fi
if [ -e '/sys/devices/soc/soc:qcom,bcl/mode' ];then
    if [ ! `cat /sys/devices/soc/soc:qcom,bcl/mode` = 'disable' ];then
        echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
    fi
fi
if [ -e '/sys/module/msm_thermal/parameters/enabled' ];then
    if [ ! `cat /sys/module/msm_thermal/parameters/enabled` = 'N' ];then
        echo N > /sys/module/msm_thermal/parameters/enabled
    fi
fi
#最小频率
chmod 666 /sys/module/msm_performance/parameters/cpu_min_freq
echo 0 > /sys/module/msm_performance/parameters/cpu_min_freq
chmod 444 /sys/module/msm_performance/parameters/cpu_min_freq
#默认参数
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
#字体颜色
#周围
if [ ! -e "${tc_path}Set_up/colour/Font/around" ];then
    echo 33 > ${tc_path}Set_up/colour/Font/around
fi
#字体
if [ ! -e "${tc_path}Set_up/colour/Font/Font" ];then
    echo 32 > ${tc_path}Set_up/colour/Font/Font
fi
#选项
if [ ! -e "${tc_path}Set_up/colour/Font/Options" ];then
    echo 32 > ${tc_path}Set_up/colour/Font/Options
fi
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
#降频温度
if [ ! -e "${tc_path}parameter/PTC/Limit_threshold" ];then
    echo 800 > ${tc_path}parameter/PTC/Limit_threshold
fi
#满血温度
if [ ! -e "${tc_path}parameter/PTC/Open_threshold" ];then
    echo 650 > ${tc_path}parameter/PTC/Open_threshold
fi

#GPU
#gpu降频档位
if [ ! -e "${tc_path}parameter/PTC/gpu_Frequency_reduction" ];then
    echo 0 > ${tc_path}parameter/PTC/gpu_Frequency_reduction
fi
#均衡gpu频率
if [ ! -e "${tc_path}parameter/PTC/Video_card_daily_frequency" ];then
    echo 450000000 > ${tc_path}parameter/PTC/Video_card_daily_frequency
fi
#熄屏gpu频率
if [ ! -e "${tc_path}parameter/PTC/gpu_Power_saving" ];then
	gpu_max_freq_file_fixed="/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies"
	gpu_digital=`cat $gpu_max_freq_file_fixed|wc -w`
    cat $gpu_max_freq_file_fixed|sed "s/ /:/g"|cut -d: -f$gpu_digital > ${tc_path}parameter/PTC/gpu_Power_saving
fi

#CPU
#小核心降频档位
if [ ! -e "${tc_path}parameter/PTC/small_cpu_Frequency_reduction" ];then
    echo 0 > ${tc_path}parameter/PTC/small_cpu_Frequency_reduction
fi
#大核心降频档位
if [ ! -e "${tc_path}parameter/PTC/big_cpu_Frequency_reduction" ];then
    echo 0 > ${tc_path}parameter/PTC/big_cpu_Frequency_reduction
fi
#超大核心降频档位
if [ ! -e "${tc_path}parameter/PTC/super_cpu_Frequency_reduction" ];then
    echo 0 > ${tc_path}parameter/PTC/super_cpu_Frequency_reduction
fi
#小核心均衡频率
if [ ! -e "${tc_path}parameter/PTC/Daily_frequency_of_small_core" ];then
    echo 1600000 > ${tc_path}parameter/PTC/Daily_frequency_of_small_core
fi
#大核心均衡频率
if [ ! -e "${tc_path}parameter/PTC/Big_core_daily_frequency" ];then
    echo 2000000 > ${tc_path}parameter/PTC/Big_core_daily_frequency
fi
#超大核心均衡频率
if [ ! -e "${tc_path}parameter/PTC/super_core_daily_frequency" ];then
    echo 2000000 > ${tc_path}parameter/PTC/super_core_daily_frequency
fi
#小核心熄屏频率
if [ ! -e "${tc_path}parameter/PTC/Small_core_Power_saving" ];then
    echo 1000000 > ${tc_path}parameter/PTC/Small_core_Power_saving
fi
#大核心熄屏频率
if [ ! -e "${tc_path}parameter/PTC/big_core_Power_saving" ];then
    echo 1000000 > ${tc_path}parameter/PTC/big_core_Power_saving
fi
#超大核心熄屏频率
if [ ! -e "${tc_path}parameter/PTC/super_core_Power_saving" ];then
    echo 1000000 > ${tc_path}parameter/PTC/super_core_Power_saving
fi
#电池温度
if [ ! -e "${tc_path}parameter/PTC/protect_yourself" ];then
    echo 500 > ${tc_path}parameter/PTC/protect_yourself
fi
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
#充电
#保护温度
if [ ! -e "${tc_path}parameter/CTC/Increase_current_threshold" ];then
    echo 430 > ${tc_path}parameter/CTC/Increase_current_threshold
fi
#满血温度
if [ ! -e "${tc_path}/CTC/Lower_current_threshold" ];then
    echo 410 > ${tc_path}parameter/CTC/Lower_current_threshold
fi
#最大最小电流
if [ ! -e "${tc_path}parameter/CTC/Maximum_current" -o ! -e "${tc_path}parameter/CTC/Minimum_current" ];then
    grep "$Identify_models" /data/adb/modules/Custom_temperature_control/file/model
    if [ $? = 0 ];then
        grep "$Identify_models" /data/adb/modules/Custom_temperature_control/file/model|awk '{print $2}' > ${tc_path}parameter/CTC/Maximum_current
        echo 3000 > ${tc_path}parameter/CTC/Minimum_current
    else
        echo 3950 > ${tc_path}parameter/CTC/Maximum_current
        echo 1600 > ${tc_path}parameter/CTC/Minimum_current
    fi
fi
#调节充电电流
if [ ! -e "${tc_path}parameter/CTC/Reduce_current_size" ];then
    echo $(((`cat ${tc_path}parameter/CTC/Maximum_current`-`cat ${tc_path}parameter/CTC/Minimum_current`)/30))|cut -d. -f1 > ${tc_path}parameter/CTC/Reduce_current_size
fi
#保护
if [ ! -e "${tc_path}parameter/CTC/protection" ];then
    echo 480 > ${tc_path}parameter/CTC/protection
fi
#保护电流
if [ ! -e "${tc_path}parameter/CTC/Protection_value" ];then
    echo 1 > ${tc_path}parameter/CTC/Protection_value
fi
 
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
if [ ! -e "${tc_path}设置参数.sh" ];then
    echo "sh /data/adb/modules/Custom_temperature_control/parameter/A_menu.sh" > ${tc_path}设置参数.sh
fi
#熄屏模式开关
if [ ! -e "${tc_path}parameter/PTC/Screen_extinguishing_switch" ];then
    echo K > ${tc_path}parameter/PTC/Screen_extinguishing_switch
fi
#熄屏模式延时时间
if [ ! -e "${tc_path}parameter/PTC/number" ];then
    echo 60 > ${tc_path}parameter/PTC/number
fi
#限制频率
if [ ! -e "${tc_path}parameter/PTC/Small_core_restrictions" ];then
    echo 1000000 > ${tc_path}parameter/PTC/Small_core_restrictions
fi
if [ ! -e "${tc_path}parameter/PTC/Big_core_limitation" ];then
    echo 1000000 > ${tc_path}parameter/PTC/Big_core_limitation
fi
if [ ! -e "${tc_path}parameter/PTC/Super_core_limit" ];then
    echo 1000000 > ${tc_path}parameter/PTC/Super_core_limit
fi