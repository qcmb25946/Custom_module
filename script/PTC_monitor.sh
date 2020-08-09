#!/system/bin/sh

#SOC删除温控失败，改为日志

#固定最大cpu频率路径
cpu0_max_freq_file_fixed="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
cpu1_max_freq_file_fixed="/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq"
cpu2_max_freq_file_fixed="/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_max_freq"
cpu3_max_freq_file_fixed="/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq"
cpu4_max_freq_file_fixed="/sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq"
cpu5_max_freq_file_fixed="/sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_max_freq"
cpu6_max_freq_file_fixed="/sys/devices/system/cpu/cpu6/cpufreq/cpuinfo_max_freq"
cpu7_max_freq_file_fixed="/sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"
#控制cpu最大频率路径
cpu0_max_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
cpu1_max_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"
cpu2_max_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu4_max_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu6_max_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
#控制gpu最大频率路径
gpu_max_freq_file_control="/sys/class/kgsl/kgsl-3d0/max_gpuclk"
Identify=`getprop ro.board.platform`
	        if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前超大核最大频率=`cat $cpu7_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu7_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu5_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu4_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu3_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu2_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		    fi