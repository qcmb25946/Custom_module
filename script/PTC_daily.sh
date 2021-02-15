#SOC均衡模式脚本

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
#控制cpu最大频率路径
cpu0_max_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
cpu1_max_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"
cpu2_max_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu4_max_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu6_max_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
#CPU频率表
cpu0_Frequency_table=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
cpu1_Frequency_table=/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
cpu2_Frequency_table=/sys/devices/system/cpu/cpu2/cpufreq/scaling_available_frequencies
cpu3_Frequency_table=/sys/devices/system/cpu/cpu3/cpufreq/scaling_available_frequencies
cpu4_Frequency_table=/sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies
cpu5_Frequency_table=/sys/devices/system/cpu/cpu5/cpufreq/scaling_available_frequencies
cpu6_Frequency_table=/sys/devices/system/cpu/cpu6/cpufreq/scaling_available_frequencies
cpu7_Frequency_table=/sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies
#gpu频率表
gpu_max_freq_file_fixed="/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies"
#控制gpu最大频率路径
gpu_max_freq_file_control="/sys/class/kgsl/kgsl-3d0/max_gpuclk"
gpu_max_freq_file_control_three="/sys/kernel/gpu/gpu_max_clock"
#cpu频率总闸
cpu_max_freq=/sys/module/msm_performance/parameters/cpu_max_freq
#gpu温度传感器
thermal_dir="/sys/class/thermal/thermal_zone10/temp"
Judgments_based=`cat /sys/class/thermal/thermal_zone10/temp |wc -c`
gpu_temp=`cat ${thermal_dir}`
#读取控制gpu最大频率
gpu_max_freq_Read_control=`cat $gpu_max_freq_file_control`
gpu_max_freq_Read_control_three=`cat $gpu_max_freq_file_control_three`
#读取设定参数
small_cpu_Frequency_reduction=/storage/emulated/TC/parameter/PTC/small_cpu_Frequency_reduction
big_cpu_Frequency_reduction=/storage/emulated/TC/parameter/PTC/big_cpu_Frequency_reduction
super_cpu_Frequency_reduction=/storage/emulated/TC/parameter/PTC/super_cpu_Frequency_reduction
gpu_Frequency_reduction=/storage/emulated/TC/parameter/PTC/gpu_Frequency_reduction
Limit_threshold_dir=`cat /storage/emulated/TC/parameter/PTC/Limit_threshold`
Open_threshold_dir=`cat /storage/emulated/TC/parameter/PTC/Open_threshold`
Daily_frequency_of_small_core=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`
Big_core_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`
super_core_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`
Video_card_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`
#识别处理器
Identify=`getprop ro.board.platform`
	#读取温度
	if [ $Judgments_based -eq 4 -o $Judgments_based -eq 6 ]; then
		gpu_temp_dir=`cut -c -3 $thermal_dir`
	elif [ $Judgments_based -eq 5 -o $Judgments_based -eq 7 ]; then
		gpu_temp_dir=`cut -c -4 $thermal_dir`
		fi
	Too_high_1=`echo "$gpu_temp_dir $Limit_threshold_dir"|awk '{print $1/$2}'|cut -d. -f1`
	Too_high_2=`echo "$gpu_temp_dir $Open_threshold_dir"|awk '{print $1/$2}'|cut -d. -f1`
#执行降频或满血
	mode=0
	if [  $Too_high_1 -ge 1 ]; then
	    mode=1
#cpu0
		if [ -e $cpu0_max_freq_file_control ]; then
			cpu0_digital=`cat $cpu0_Frequency_table|wc -w`
			cpu0_Frequency_reduction=`cat $small_cpu_Frequency_reduction`
			cpu0_max_freq_file_control_Read=`cat $cpu0_max_freq_file_control`
			cpu0_Frequency_arrangement=`cat $cpu0_Frequency_table|sed "s/ /\n/g"| grep -n "$cpu0_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $cpu0_Frequency_reduction -lt 1 ];then
				cpu0_Frequency_reduction=1
			elif [ $cpu0_Frequency_reduction -gt 4 ];then
				cpu0_Frequency_reduction=4
			fi
			cpu0_Operation=$(($cpu0_Frequency_arrangement-$cpu0_Frequency_reduction))
			if [ $cpu0_Operation -lt 2 ];then
			    cpu0_Operation=2
			fi
			cpu0_max_freq=`cat $cpu0_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0_Operation`
		fi
#1+n+n架构cpu6
		if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			cpu6_digital=`cat $cpu6_Frequency_table|wc -w`
			cpu6_Frequency_reduction=`cat $big_cpu_Frequency_reduction`
			cpu6_max_freq_file_control_Read=`cat $cpu6_max_freq_file_control`
			cpu6_Frequency_arrangement=`cat $cpu6_Frequency_table|sed "s/ /\n/g"| grep -n "$cpu6_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $cpu6_Frequency_reduction -lt 1 ];then
				cpu6_Frequency_reduction=1
			elif [ $cpu6_Frequency_reduction -gt 4 ];then
				cpu6_Frequency_reduction=4
			fi
			cpu6_Operation=$(($cpu6_Frequency_arrangement-$cpu6_Frequency_reduction))
			if [ $cpu6_Operation -lt 2 ];then
			    cpu6_Operation=2
			fi
			cpu6_max_freq=`cat $cpu6_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu6_Operation`
		fi
#1+n+n/2+6/4+4架构cpu7
        if [ -e $cpu7_max_freq_file_control ]; then
			cpu7_digital=`cat $cpu7_Frequency_table|wc -w`
			cpu7_Frequency_reduction=`cat $super_cpu_Frequency_reduction`
			cpu7_max_freq_file_control_Read=`cat $cpu7_max_freq_file_control`
			cpu7_Frequency_arrangement=`cat $cpu7_Frequency_table|sed "s/ /\n/g"| grep -n "$cpu7_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $cpu7_Frequency_reduction -lt 1 ];then
				cpu7_Frequency_reduction=1
			elif [ $cpu7_Frequency_reduction -gt 4 ];then
				cpu7_Frequency_reduction=4
			fi
			cpu7_Operation=$(($cpu7_Frequency_arrangement-$cpu7_Frequency_reduction))
			if [ $cpu7_Operation -lt 2 ];then
			    cpu7_Operation=2
			fi
			cpu7_max_freq=`cat $cpu7_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu7_Operation`
#2+4架构cpu5
		elif [ -e $cpu5_max_freq_file_control ]; then
			cpu5_digital=`cat $cpu5_Frequency_table|wc -w`
 			cpu5_Frequency_reduction=`cat $super_cpu_Frequency_reduction`
			cpu5_max_freq_file_control_Read=`cat $cpu5_max_freq_file_control`
			cpu5_Frequency_arrangement=`cat $cpu5_Frequency_table|sed "s/ /\n/g"| grep -n "$cpu5_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $cpu5_Frequency_reduction -lt 1 ];then
				cpu5_Frequency_reduction=1
			elif [ $cpu5_Frequency_reduction -gt 4 ];then
				cpu5_Frequency_reduction=4
			fi
			cpu5_Operation=$(($cpu5_Frequency_arrangement-$cpu5_Frequency_reduction))
			if [ $cpu5_Operation -lt 2 ];then
			    cpu5_Operation=2
			fi
			cpu5_max_freq=`cat $cpu5_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu5_Operation`

#2+2架构cpu3
		elif [ -e $cpu3_max_freq_file_control ]; then
			cpu3_digital=`cat $cpu3_Frequency_table|wc -w`
 			cpu3_Frequency_reduction=`cat $super_cpu_Frequency_reduction`
			cpu3_max_freq_file_control_Read=`cat $cpu3_max_freq_file_control`
			cpu3_Frequency_arrangement=`cat $cpu3_Frequency_table|sed "s/ /\n/g"| grep -n "$cpu3_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $cpu3_Frequency_reduction -lt 1 ];then
				cpu3_Frequency_reduction=1
			elif [ $cpu3_Frequency_reduction -gt 4 ];then
				cpu3_Frequency_reduction=4
			fi
			cpu3_Operation=$(($cpu3_Frequency_arrangement-$cpu3_Frequency_reduction))
			if [ $cpu3_Operation -lt 2 ];then
			    cpu3_Operation=2
			fi
			cpu3_max_freq=`cat $cpu3_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu3_Operation`
		fi
#gpu
		if [ -e $gpu_max_freq_file_fixed ]; then
			gpu_digital=`cat $gpu_max_freq_file_fixed|wc -w`
 			gpu_Frequency_reduction=`cat $gpu_Frequency_reduction`
			gpu_max_freq_file_control_Read=`cat $gpu_max_freq_file_control`
			gpu_Frequency_arrangement=`cat $gpu_max_freq_file_fixed|sed "s/ /\n/g"| grep -n "$gpu_max_freq_file_control_Read"|grep -v "^$"|cut -d: -f1`
			if [ $gpu_Frequency_reduction -lt 1 ];then
				gpu_Frequency_reduction=1
			elif [ $gpu_Frequency_reduction -gt 3 ];then
				gpu_Frequency_reduction=3
			fi
			gpu_Operation=$(($gpu_Frequency_arrangement+$gpu_Frequency_reduction))
			if [ $gpu_Operation -ge $gpu_digital ];then
			    gpu_Operation=$gpu_digital
			fi
			gpu_max_freq=`cat $gpu_max_freq_file_fixed|sed "s/ /:/g"|cut -d: -f$gpu_Operation`
		fi
		echo "温度过高,正在降频"
		echo "温度过高,正在降频" > /storage/emulated/TC/Result/PTC/soc_present.log
	elif [ $Too_high_2 -lt 1 ]; then
    	mode=1
#cpu0
        if [ -e $cpu0_max_freq_file_control ]; then
			cpu0_digital=`cat $cpu0_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu0_digital)
			do
			cpu0_Different_frequencies=`cat $cpu0_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu0_Different_frequencies -lt $Daily_frequency_of_small_core ];then
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
			if [ $cpu6_Different_frequencies -lt $Big_core_daily_frequency ];then
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
			if [ $cpu7_Different_frequencies -lt $super_core_daily_frequency ];then
				cpu7_max_freq=$cpu7_Different_frequencies
			fi
			done
#2+4架构cpu5
		elif [ -e $cpu5_max_freq_file_control ]; then
			cpu5_digital=`cat $cpu5_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu5_digital)
			do
			cpu5_Different_frequencies=`cat $cpu5_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu5_Different_frequencies -lt $super_core_daily_frequency ];then
				cpu5_max_freq=$cpu5_Different_frequencies
			fi
			done
#2+2架构cpu3
		elif [ -e $cpu3_max_freq_file_control ]; then
			cpu3_digital=`cat $cpu3_Frequency_table|wc -w`
			for cpu0 in $(seq $cpu3_digital)
			do
			cpu3_Different_frequencies=`cat $cpu3_Frequency_table|sed "s/ /:/g"|cut -d: -f$cpu0`
			if [ $cpu3_Different_frequencies -lt $super_core_daily_frequency ];then
				cpu3_max_freq=$cpu3_Different_frequencies
			fi
			done
		fi
#gpu
		if [ -e $gpu_max_freq_file_fixed ]; then
			gpu_max_freq_file_fixed="/sys/class/kgsl/kgsl-3d0/gpu_available_frequencies"
			gpu_digital=`cat $gpu_max_freq_file_fixed|wc -w`
			for gpu in $(seq $gpu_digital -1 1)
			do
			gpu_Different_frequencies=`cat $gpu_max_freq_file_fixed|sed "s/ /:/g"|cut -d: -f$gpu`
			if [ $gpu_Different_frequencies -le $Video_card_daily_frequency ]; then
				gpu_max_freq=$gpu_Different_frequencies
			fi
			done
		fi
		echo "温度正常,当前已恢复满血"
		echo "温度正常,当前已恢复满血" > /storage/emulated/TC/Result/PTC/soc_present.log
	fi
    if [ $mode -eq 1 ];then
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
		echo "均衡模式"
		echo "均衡模式" > /storage/emulated/TC/Result/PTC/mode
	fi