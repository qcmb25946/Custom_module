#!/system/bin/sh
while true
do
#执行脚本间隔
sleep $gpu_time
#时间
date
#固定最大cpu频率路径
cpu0_max_freq_file_fixed="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
cpu1_max_freq_file_fixed="/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq"
cpu2_max_freq_file_fixed="/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_max_freq"
cpu3_max_freq_file_fixed="/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq"
cpu4_max_freq_file_fixed="/sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq"
cpu5_max_freq_file_fixed="/sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_max_freq"
cpu6_max_freq_file_fixed="/sys/devices/system/cpu/cpu6/cpufreq/cpuinfo_max_freq"
cpu7_max_freq_file_fixed="/sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"
#固定最大gpu频率路径
gpu_max_freq_file_fixed="/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies"
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
gpu_max_freq_file_control_three="/sys/kernel/gpu/gpu_max_clock"
#gpu温度传感器
thermal_dir="/sys/class/thermal/thermal_zone10/temp"
Judgments_based=`cat /sys/class/thermal/thermal_zone10/temp |wc -c`
gpu_temp=`cat ${thermal_dir}`
#读取固定最大gpu频率
awk '{print $1}' $gpu_max_freq_file_fixed > /sdcard/TC/parameter/PTC/gpu_max_freq
gpu_max_freq_Read_fixed=`cat /sdcard/TC/parameter/PTC/gpu_max_freq`
#读取控制gpu最大频率
gpu_max_freq_Read_control=`cat $gpu_max_freq_file_control`
gpu_max_freq_Read_control_three=`cat $gpu_max_freq_file_control_three`
#读取设定参数
cpu_Frequency_reduction=`cat /sdcard/TC/parameter/PTC/cpu_Frequency_reduction`
gpu_Frequency_reduction=`cat /sdcard/TC/parameter/PTC/gpu_Frequency_reduction`
Limit_threshold_dir=`cat /sdcard/TC/parameter/PTC/Limit_threshold`
Open_threshold_dir=`cat /sdcard/TC/parameter/PTC/Open_threshold`
gpu_time=`cat /sdcard/TC/parameter/PTC/gpu_time`
#识别处理器
Identify=`getprop ro.board.platform`
#某一个温控路径
thermal_engine=/system/vendor/bin/thermal-engine
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
#检测温控
if [ ! -d $thermal_engine -o $thermal_engine_zf -eq 0 ]; then
    echo "温控已被移出继续运行"
    #读取温度
    if [ $Judgments_based -eq 4 -o $Judgments_based -eq 6 ]; then
        gpu_temp_dir=`cut -c -3 $thermal_dir`
    elif [ $Judgments_based -eq 5 -o $Judgments_based -eq 7 ]; then
        gpu_temp_dir=`cut -c -4 $thermal_dir`
    fi
    Limit_threshold=`echo $Limit_threshold_dir 1000000|awk '{print $1*$2}'`
    Open_threshold=`echo $Open_threshold_dir 1000000|awk '{print $1*$2}'`
    gpu_temp=`echo $gpu_temp_dir 1000000|awk '{print $1*$2}'`
    #执行降频或满血
    if [  $gpu_temp -ge $Limit_threshold ]; then
    	if [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed -a -f $cpu7_max_freq_file_fixed ]; then
    	    cpu0_max_freq_file_control_Read=`cat $cpu0_max_freq_file_control`
    	    cpu6_max_freq_file_control_Read=`cat $cpu6_max_freq_file_control`
    	    cpu7_max_freq_file_control_Read=`cat $cpu7_max_freq_file_control`
		    cpu0_max_freq_expr=`expr $cpu0_max_freq_file_control_Read / 100`
		    cpu6_max_freq_expr=`expr $cpu6_max_freq_file_control_Read / 100`
		    cpu7_max_freq_expr=`expr $cpu7_max_freq_file_control_Read / 100`
		    cpu0_max_freq=`expr $cpu0_max_freq_expr \* $cpu_Frequency_reduction`
		    cpu6_max_freq=`expr $cpu6_max_freq_expr \* $cpu_Frequency_reduction`
		    cpu7_max_freq=`expr $cpu7_max_freq_expr \* $cpu_Frequency_reduction`
		    chmod 666 $cpu0_max_freq_file_control
		    echo $cpu0_max_freq > $cpu0_max_freq_file_control
		    chmod 444 $cpu0_max_freq_file_control
		    chmod 666 $cpu6_max_freq_file_control
		    echo $cpu6_max_freq > $cpu6_max_freq_file_control
		    chmod 444 $cpu6_max_freq_file_control
		    chmod 666 $cpu7_max_freq_file_control
		    echo $cpu7_max_freq > $cpu7_max_freq_file_control
		    chmod 444 $cpu7_max_freq_file_control
	    elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed ]; then
	        cpu0_max_freq_file_control_Read=`cat $cpu0_max_freq_file_control`
    	    cpu4_max_freq_file_control_Read=`cat $cpu4_max_freq_file_control`
		    cpu0_max_freq_expr=`expr $cpu0_max_freq_file_control_Read / 100`
		    cpu4_max_freq_expr=`expr $cpu4_max_freq_file_control_Read / 100`
		    cpu0_max_freq=`expr $cpu0_max_freq_expr \* $cpu_Frequency_reduction`
		    cpu4_max_freq=`expr $cpu4_max_freq_expr \* $cpu_Frequency_reduction`
		    chmod 666 $cpu0_max_freq_file_control
		    echo $cpu0_max_freq > $cpu0_max_freq_file_control
		    chmod 444 $cpu0_max_freq_file_control
		    chmod 666 $cpu4_max_freq_file_control
		    echo $cpu4_max_freq > $cpu4_max_freq_file_control
		    chmod 444 $cpu4_max_freq_file_control
		elif [ -f $cpu3_max_freq_file_fixed ]; then
			cpu0_max_freq_file_control_Read=`cat $cpu0_max_freq_file_control`
    	    cpu2_max_freq_file_control_Read=`cat $cpu2_max_freq_file_control`
		    cpu0_max_freq_expr=`expr $cpu0_max_freq_file_control_Read / 100`
		    cpu2_max_freq_expr=`expr $cpu2_max_freq_file_control_Read / 100`
		    cpu0_max_freq=`expr $cpu0_max_freq_expr \* $cpu_Frequency_reduction`
		    cpu2_max_freq=`expr $cpu2_max_freq_expr \* $cpu_Frequency_reduction`
		    chmod 666 $cpu0_max_freq_file_control
		    echo $cpu0_max_freq > $cpu0_max_freq_file_control
		    chmod 444 $cpu0_max_freq_file_control
		    chmod 666 $cpu2_max_freq_file_control
		    echo $cpu2_max_freq > $cpu2_max_freq_file_control
		    chmod 444 $cpu2_max_freq_file_control
		fi
		if [ -f $gpu_max_freq_file_fixed ]; then
			gpu_max_freq_expr=`expr $gpu_max_freq_Read_control / 100`
			gpu_max_freq=`expr $gpu_max_freq_expr \* $gpu_Frequency_reduction`
			echo $gpu_max_freq
			chmod 666 $gpu_max_freq_file_control
			echo $gpu_max_freq > $gpu_max_freq_file_control
			chmod 444 $gpu_max_freq_file_control
		fi
		echo "温度过高,正在降频"
		echo "温度过高,正在降频" > /sdcard/TC/Result/PTC/soc_present.log
    elif [ $gpu_temp -le $Open_threshold ]; then
		if [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed -a -f $cpu7_max_freq_file_fixed ]; then
			cpu0_max_freq=`cat $cpu0_max_freq_file_fixed`
			cpu6_max_freq=`cat $cpu6_max_freq_file_fixed`
			cpu7_max_freq=`cat $cpu7_max_freq_file_fixed`
			chmod 666 $cpu0_max_freq_file_control
			echo $cpu0_max_freq > $cpu0_max_freq_file_control
			chmod 444 $cpu0_max_freq_file_control
			chmod 666 $cpu6_max_freq_file_control
			echo $cpu6_max_freq > $cpu6_max_freq_file_control
			chmod 444 $cpu6_max_freq_file_control
			chmod 666 $cpu7_max_freq_file_control
			echo $cpu7_max_freq > $cpu7_max_freq_file_control
			chmod 444 $cpu7_max_freq_file_control
		elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed ]; then
			cpu0_max_freq=`cat $cpu0_max_freq_file_fixed`
			cpu4_max_freq=`cat $cpu4_max_freq_file_fixed`
			chmod 666 $cpu0_max_freq_file_control
			echo $cpu0_max_freq > $cpu0_max_freq_file_control
			chmod 444 $cpu0_max_freq_file_control
			chmod 666 $cpu4_max_freq_file_control
			echo $cpu4_max_freq > $cpu4_max_freq_file_control
			chmod 444 $cpu4_max_freq_file_control
		elif [ -f $cpu3_max_freq_file_fixed ]; then
			cpu0_max_freq=`cat $cpu0_max_freq_file_fixed`
			cpu2_max_freq=`cat $cpu2_max_freq_file_fixed`
			chmod 666 $cpu0_max_freq_file_control
			echo $cpu0_max_freq > $cpu0_max_freq_file_control
			chmod 444 $cpu0_max_freq_file_control
			chmod 666 $cpu2_max_freq_file_control
			echo $cpu2_max_freq > $cpu2_max_freq_file_control
			chmod 444 $cpu2_max_freq_file_control
		fi
		if [ -f $gpu_max_freq_file_fixed ]; then
		    echo $gpu_max_freq_Read_fixed
			chmod 666 $gpu_max_freq_file_control
			echo $gpu_max_freq_Read_fixed > $gpu_max_freq_file_control
			chmod 444 $gpu_max_freq_file_control
		fi
		echo "温度正常,当前已恢复满血"
		echo "温度正常,当前已恢复满血" > /sdcard/TC/Result/PTC/soc_present.log
    fi
    #日志
    if [ Log ]; then
	    if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			echo "当前设置小核最大频率=`cat $cpu0_max_freq_file_control`
当前设置大核最大频率=`cat $cpu6_max_freq_file_control`
当前设置超大核最大频率=`cat $cpu7_max_freq_file_control`
当前设置GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed -a -f $cpu7_max_freq_file_fixed ]; then
			echo "当前设置小核最大频率=`cat $cpu0_max_freq_file_control`
当前设置大核最大频率=`cat $cpu6_max_freq_file_control`
当前设置GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed ]; then
			echo "当前设置小核最大频率=`cat $cpu0_max_freq_file_control`
当前设置大核最大频率=`cat $cpu4_max_freq_file_control`
当前设置GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed ]; then
			echo "当前设置小核最大频率=`cat $cpu0_max_freq_file_control`
当前设置大核最大频率=`cat $cpu2_max_freq_file_control`
当前设置GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		fi
    fi
elif [ $thermal_engine_zf -gt 0 ]; then
    sleep 1
    echo "温控存在停止运行"
        #日志
    if [ Log ]; then
	    if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前超大核最大频率=`cat $cpu7_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed -a -f $cpu7_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed -a -f $cpu5_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu4_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		elif [ -f $cpu3_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu2_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		fi
    fi
fi
done

