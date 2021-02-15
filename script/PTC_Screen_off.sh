#熄屏模式

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
#gpu频率表
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
#控制cpu最小频率路径
cpu0_min_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
cpu1_min_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq"
cpu2_min_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq"
cpu3_min_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq"
cpu4_min_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq"
cpu5_min_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq"
cpu6_min_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq"
cpu7_min_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq"
#CPU频率表
cpu0_Frequency_table=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
cpu1_Frequency_table=/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
cpu2_Frequency_table=/sys/devices/system/cpu/cpu2/cpufreq/scaling_available_frequencies
cpu3_Frequency_table=/sys/devices/system/cpu/cpu3/cpufreq/scaling_available_frequencies
cpu4_Frequency_table=/sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies
cpu5_Frequency_table=/sys/devices/system/cpu/cpu5/cpufreq/scaling_available_frequencies
cpu6_Frequency_table=/sys/devices/system/cpu/cpu6/cpufreq/scaling_available_frequencies
cpu7_Frequency_table=/sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies
#控制gpu最大频率路径
gpu_max_freq_file_control="/sys/class/kgsl/kgsl-3d0/max_gpuclk"
gpu_min_freq_file_control="/sys/class/kgsl/kgsl-3d0/devfreq/min_freq"
gpu_max_freq_file_control_three="/sys/kernel/gpu/gpu_max_clock"
#cpu频率总闸
cpu_max_freq=/sys/module/msm_performance/parameters/cpu_max_freq
#读取设定参数
Small_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`
big_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/big_core_Power_saving`
super_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`
gpu_Power_saving=`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`
#识别处理器
Identify=`getprop ro.board.platform`
#清空所有后台
am kill-all
#cpu0
        if [ -e $cpu0_max_freq_file_control ]; then
			cpu0_digital=`cat $cpu0_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu0_digital)
			do
			cpu0_Different_frequencies=`cat $cpu0_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu0_Different_frequencies -lt $Small_core_Power_saving ];then
				cpu0_max_freq=$cpu0_Different_frequencies
			fi
			done
		fi
#1+n+n架构cpu6
		if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			cpu6_digital=`cat $cpu6_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu6_digital)
			do
			cpu6_Different_frequencies=`cat $cpu6_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu6_Different_frequencies -lt $big_core_Power_saving ];then
				cpu6_max_freq=$cpu6_Different_frequencies
			fi
			done
		fi
#1+n+n/2+6/4+4架构cpu7
		if [ -e $cpu7_max_freq_file_control ]; then
			cpu7_digital=`cat $cpu7_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu7_digital)
			do
			cpu7_Different_frequencies=`cat $cpu7_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu7_Different_frequencies -lt $super_core_Power_saving ];then
				cpu7_max_freq=$cpu7_Different_frequencies
			fi
			done
#2+4架构cpu5
		elif [ -e $cpu5_max_freq_file_control ]; then
			cpu5_digital=`cat $cpu5_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu5_digital)
			do
			cpu5_Different_frequencies=`cat $cpu5_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu5_Different_frequencies -lt $super_core_Power_saving ];then
				cpu5_max_freq=$cpu5_Different_frequencies
			fi
			done
#2+2架构cpu3
		elif [ -e $cpu3_max_freq_file_control ]; then
			cpu3_digital=`cat $cpu3_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu3_digital)
			do
			cpu3_Different_frequencies=`cat $cpu3_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu3_Different_frequencies -lt $super_core_Power_saving ];then
				cpu3_max_freq=$cpu3_Different_frequencies
			fi
			done
		fi
#gpu
		if [ -e $gpu_max_freq_file_fixed ]; then
            gpu_max_freq=`cat $gpu_max_freq_file_fixed|awk '{print $NF}'`
		fi
		echo "正在以省电模式运行"
		echo "正在以省电模式运行" > /storage/emulated/TC/Result/PTC/soc_present.log
#写入总闸
 	    if [ -e $cpu7_max_freq_file_fixed ]; then
	        if [ $(cat /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus|awk '{print $NF}') -eq 5 ];then
	            if [ $(cat /sys/devices/system/cpu/cpu6/cpufreq/affected_cpus|awk '{print $NF}') -eq 6 ];then
	                if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu6_max_freq_file_control` -ne $cpu6_max_freq -o `cat $cpu7_max_freq_file_control` -ne $cpu7_max_freq ];then
	                    chmod 666 $cpu_max_freq
		                echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu0_max_freq 3:$cpu0_max_freq 4:$cpu0_max_freq 5:$cpu0_max_freq 6:$cpu6_max_freq 7:$cpu7_max_freq" > $cpu_max_freq
		                chmod 444 $cpu_max_freq
		            fi
		        else
	                if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu7_max_freq_file_control` -ne $cpu7_max_freq ];then
		                chmod 666 $cpu_max_freq
		                echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu0_max_freq 3:$cpu0_max_freq 4:$cpu0_max_freq 5:$cpu0_max_freq 6:$cpu7_max_freq 7:$cpu7_max_freq" > $cpu_max_freq
		                chmod 444 $cpu_max_freq
		            fi
		        fi
		    else
		        if [ $(cat /sys/devices/system/cpu/cpu4/cpufreq/affected_cpus|awk '{print $NF}') -eq 6 ];then
	                if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu6_max_freq_file_control` -ne $cpu6_max_freq -o `cat $cpu7_max_freq_file_control` -ne $cpu7_max_freq ];then
		                chmod 666 $cpu_max_freq
		                echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu0_max_freq 3:$cpu0_max_freq 4:$cpu6_max_freq 5:$cpu6_max_freq 6:$cpu6_max_freq 7:$cpu7_max_freq" > $cpu_max_freq
		                chmod 444 $cpu_max_freq
		            fi
		        else
	                if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu7_max_freq_file_control` -ne $cpu7_max_freq ];then
		                chmod 666 $cpu_max_freq
		                echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu0_max_freq 3:$cpu0_max_freq 4:$cpu7_max_freq 5:$cpu7_max_freq 6:$cpu7_max_freq 7:$cpu7_max_freq" > $cpu_max_freq
		                chmod 444 $cpu_max_freq
		            fi
		        fi
		    fi
	    elif [ -e $cpu5_max_freq_file_fixed ]; then
	        if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu5_max_freq_file_control` -ne $cpu5_max_freq ];then
	            chmod 666 $cpu_max_freq
		        echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu0_max_freq 3:$cpu0_max_freq 4:$cpu5_max_freq 5:$cpu5_max_freq" > $cpu_max_freq
		        chmod 444 $cpu_max_freq
		    fi
	    elif [ -e $cpu3_max_freq_file_fixed ]; then
	        if [ `cat $cpu0_max_freq_file_control` -ne $cpu0_max_freq -o `cat $cpu3_max_freq_file_control` -ne $cpu3_max_freq ];then
	            chmod 666 $cpu_max_freq
		        echo "0:$cpu0_max_freq 1:$cpu0_max_freq 2:$cpu3_max_freq 3:$cpu3_max_freq" > $cpu_max_freq
		        chmod 444 $cpu_max_freq
		    fi
	    fi
	    if [ ! `cat $gpu_max_freq_file_control` -eq "$gpu_max_freq" ];then
    	    chmod 666 $gpu_max_freq_file_control
		    echo $gpu_max_freq > $gpu_max_freq_file_control
		    chmod 444 $gpu_max_freq_file_control
		fi
#日志
	if [ Log ]; then
		if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			echo "当前小核最大频率=`cat $cpu1_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前超大核最大频率=`cat $cpu7_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		elif [ -e $cpu7_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu1_max_freq_file_control`
当前大核最大频率=`cat $cpu7_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		elif [ -e $cpu5_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu2_max_freq_file_control`
当前大核最大频率=`cat $cpu3_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		elif [ -e $cpu3_max_freq_file_fixed ]; then
			echo "当前小核最大频率=`cat $cpu1_max_freq_file_control`
当前大核最大频率=`cat $cpu3_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /storage/emulated/TC/Result/PTC/soc_max_freq_Current
		fi
		echo "熄屏模式" > /storage/emulated/TC/Result/PTC/mode
    fi