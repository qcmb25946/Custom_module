#!/system/bin/sh

#充电温控脚本

#时间
date
#电流路径
#qc
recharging_current_freq_file="/sys/class/power_supply/battery/constant_charge_current"
#公共
recharging_current_freq_file_max="/sys/class/power_supply/battery/constant_charge_current_max"
#op
recharging_current_freq_file_current_max="/sys/class/power_supply/battery/current_max"
recharging_current_freq_file_current_max_1="/sys/class/power_supply/usb/current_max"
#vooc
recharging_current_freq_file_current_max="/sys/class/power_supply/battery/input_current_max"
recharging_current_freq_file_current_max_1="/sys/class/power_supply/usb/input_current_max"
current_temp=`cat ${recharging_current_freq_file_max}`
#当前电流
Charge=`cat /sys/class/power_supply/bms/current_now`
#电池温度
battery_temp_dir=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
#读取设定参数
Minimum_current_dir=`cat /storage/emulated/TC/parameter/CTC/Minimum_current`
Maximum_current_dir=`cat /storage/emulated/TC/parameter/CTC/Maximum_current`
Increase_current_threshold_dir=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold_dir=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
Reduce_current_size_dir=`cat /storage/emulated/TC/parameter/CTC/Reduce_current_size`
protection=`cat /storage/emulated/TC/parameter/CTC/protection`
Protection_value=`cat /storage/emulated/TC/parameter/CTC/Protection_value`
#计算
Reduce_current_size=`expr $Reduce_current_size_dir \* 1000`
Minimum_current=`expr $Minimum_current_dir \* 1000`
Maximum_current=`expr $Maximum_current_dir \* 1000`
fast_charging=`expr $Maximum_current_dir \* 900`
Too_high_1=`echo $battery_temp_dir $Increase_current_threshold_dir|awk '{print $1/$2}'|cut -d. -f1`
Too_high_2=`echo $battery_temp_dir $Lower_current_threshold_dir|awk '{print $1/$2}'|cut -d. -f1`
Too_high_3=`echo $battery_temp_dir $protection|awk '{print $1/$2}'|cut -d. -f1`

	    if [ $Charge -ge 0 ]; then
	        echo "没充电"
			echo "没充电" > /storage/emulated/TC/Result/CTC/battery_present.log
		elif [ $Charge -lt 0 ]; then
	        echo "正在充电"
	        echo "正在充电" > /storage/emulated/TC/Result/CTC/battery_present.log
	        if [ $Too_high_3 -ge 1 ];then
	            mode=$Protection_value
	            echo "温度超过充电安全范围，停止充电"
			    echo "温度超过充电安全范围，停止充电" > /storage/emulated/TC/Result/CTC/current_present.log
	        else
		        if [ $Too_high_1 -ge 1 ]; then
			        mode=`expr $current_temp - $Reduce_current_size`
			        echo "温度过高，正在降低充电功率"
			        echo "温度过高，正在降低充电功率" > /storage/emulated/TC/Result/CTC/current_present.log
		        elif [ $Too_high_2 -lt 1 ]; then
			        mode=`expr $current_temp + $Reduce_current_size`
			        echo "温度恢复正常，满血充电"
			        echo "温度恢复正常，满血充电" > /storage/emulated/TC/Result/CTC/current_present.log
			    fi
			    #纠正上面超范围计算
			    if [ $mode -le $Minimum_current ]; then
			        mode=$Minimum_current
		    	elif [ $mode -ge $Maximum_current ]; then
			        mode=$Maximum_current
			    fi
			    if [ $Too_high_1 -lt 1 -a $Too_high_2 -ge 1 ];then
			        echo "温度正常，电流不会增减"
			        echo "温度正常，电流不会增减" > /storage/emulated/TC/Result/CTC/current_present.log
		        fi
		    fi
        fi
	    #执行计算好电流
	    if [ -f $recharging_current_freq_file_max ];then
	        chmod 0777 $recharging_current_freq_file_max
            echo $mode > $recharging_current_freq_file_max
            chmod 0555 $recharging_current_freq_file_max
        fi
	    if [ -f $recharging_current_freq_file ];then
            chmod 0777 $recharging_current_freq_file
            echo $mode > $recharging_current_freq_file
            chmod 0555 $recharging_current_freq_file
        fi
        if [ -f $recharging_current_freq_file_current_max ];then
            chmod 0777 $recharging_current_freq_file_current_max
            echo $mode > $recharging_current_freq_file_current_max
            chmod 0555 $recharging_current_freq_file_current_max
        fi
	    if [ -f $recharging_current_freq_file_current_max_1 ];then
            chmod 0777 $recharging_current_freq_file_current_max_1
            echo $mode > $recharging_current_freq_file_current_max_1
            chmod 0555 $recharging_current_freq_file_current_max_1
        fi
        if [ -f $recharging_current_freq_file_current_max ];then
            chmod 0777 $recharging_current_freq_file_current_max
            echo $mode > $recharging_current_freq_file_current_max
            chmod 0555 $recharging_current_freq_file_current_max
        fi
        if [ -f $recharging_current_freq_file_current_max_1 ];then
            chmod 0777 $recharging_current_freq_file_current_max_1
            echo $mode > $recharging_current_freq_file_current_max_1
            chmod 0555 $recharging_current_freq_file_current_max_1
        fi
	    #日志
	    if [ $Charge -gt -$Minimum_current -a $Charge -lt 0 ]; then
	    	echo "正在慢速充电"
			echo "正在慢速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
		elif [ $Charge -le -$Minimum_current -a $current_temp -gt -$fast_charging ]; then
			echo "正在快速充电"
			echo "正在快速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
	    elif [ $Charge -le -$fast_charging ]; then
		    echo "正在极速充电"
	        echo "正在极速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
	    fi