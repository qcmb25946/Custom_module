#!/system/bin/sh
{
while true
do
#执行脚本间隔
sleep 1
#时间
date
#电流路径
recharging_current_freq_file="/sys/class/power_supply/battery/constant_charge_current"
recharging_current_freq_file_max="/sys/class/power_supply/battery/constant_charge_current_max"
current_temp=`cat ${recharging_current_freq_file}`
#当前电流
Charge=`cat /sys/class/power_supply/bms/current_now`
#电池温度
battery_temp_dir=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
#读取设定参数
Minimum_current_dir=`cat /sdcard/TC/parameter/CTC/Minimum_current`
Maximum_current_dir=`cat /sdcard/TC/parameter/CTC/Maximum_current`
Increase_current_threshold_dir=`cat /sdcard/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold_dir=`cat /sdcard/TC/parameter/CTC/Lower_current_threshold`
Reduce_current_size_dir=`cat /sdcard/TC/parameter/CTC/Reduce_current_size`
charge_time=`cat /sdcard/TC/parameter/CTC/charge_time`
#计算`
Reduce_current_size=`expr $Reduce_current_size_dir \* 1000`
Minimum_current=`expr $Minimum_current_dir \* 1000`
Maximum_current=`expr $Maximum_current_dir \* 1000`
fast_charging=`expr $Maximum_current_dir \* 900`
battery_temp=`echo $battery_temp_dir 1000000|awk '{print $1*$2}'`
Lower_current_threshold=`echo $Lower_current_threshold_dir 1000000|awk '{print $1*$2}'`
Increase_current_threshold=`echo $Increase_current_threshold_dir 1000000|awk '{print $1*$2}'`
#检查温控
thermal_engine="/system/vendor/bin/thermal-engine"
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
	if [ ! -d $thermal_engine -o $thermal_engine_zf -eq 0 ]; then
	    echo "温控已被移出继续运行"
	    if [ $Charge -ge 0 ]; then
	        echo "没充电"
			echo "没充电" > /sdcard/TC/Result/CTC/battery_present.log
		elif [ $Charge -lt 0 ]; then
	        echo "正在充电"
	        echo "正在充电" > /sdcard/TC/Result/CTC/battery_present.log
	        sleep $charge_time
	       	#判断是否减少或增加电流
		    change_mode=false
		    if [ $Increase_current_threshold -le $battery_temp ]; then
			    change_mode=true
			    mode=`expr $current_temp - $Reduce_current_size`
			    echo "温度过高，正在降低充电功率"
			    echo "温度过高，正在降低充电功率" > /sdcard/TC/Result/CTC/current_present.log
		    elif [ $Lower_current_threshold -ge $battery_temp ]; then
			    change_mode=true
			    mode=$Maximum_current
			    echo "温度恢复正常，满血充电"
			    echo "温度恢复正常，满血充电" > /sdcard/TC/Result/CTC/current_present.log
			fi
			#纠正上面超范围计算
			if [ $mode -le $Minimum_current ]; then
			    mode=$Minimum_current
			fi
			#执行计算好电流
		    if [[ $change_mode == true ]]; then
 			    chmod 0777 $recharging_current_freq_file_max
                echo $mode > $recharging_current_freq_file_max
                chmod 0555 $recharging_current_freq_file_max
                chmod 0777 $recharging_current_freq_file
                echo $mode > $recharging_current_freq_file
                chmod 0555 $recharging_current_freq_file
	    	fi
	    	#日志
	    	if [ $Charge -gt -$Minimum_current -a $Charge -lt 0 ]; then
	    		echo "正在慢速充电"
			    echo "正在慢速充电" > /sdcard/TC/Result/CTC/current_present_mode.log
			elif [ $Charge -le -$Minimum_current -a $current_temp -gt -$fast_charging ]; then
			    echo "正在快速充电"
			    echo "正在快速充电" > /sdcard/TC/Result/CTC/current_present_mode.log
			elif [ $Charge -le -$fast_charging ]; then
			    echo "正在极速充电"
			    echo "正在极速充电" > /sdcard/TC/Result/CTC/current_present_mode.log
			fi
	    fi
    elif [ $thermal_engine_zf -gt 0 ]; then
        echo "温控存在停止运行"
    fi
done
}