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
recharging_current_freq_file_input_current_max="/sys/class/power_supply/battery/input_current_max"
recharging_current_freq_file_input_current_max_1="/sys/class/power_supply/usb/input_current_max"
#小米
recharging_current_freq_file_hw_current_max=/sys/class/power_supply/usb/hw_current_max
recharging_current_freq_file_pd_current_max=/sys/class/power_supply/usb/pd_current_max
recharging_current_freq_file_qc3p5_current_max=/sys/class/power_supply/usb/qc3p5_current_max
#电池温度
battery_temp_dir=`cut -c -3 /sys/class/hwmon/hwmon0/temp1_input`
#当前电流
Charge=`cat /sys/class/power_supply/bms/current_now`
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
        ctc=0
	    if [ $Charge -ge 0 ]; then
	        echo "没充电"
			echo "没充电" > /storage/emulated/TC/Result/CTC/battery_present.log
		elif [ $Charge -lt 0 ]; then
	        echo "正在充电"
	        echo "正在充电" > /storage/emulated/TC/Result/CTC/battery_present.log
	        if [ $Too_high_3 -ge 1 ];then
	            mode=$Protection_value
	            ctc=1
	            echo "温度超过充电安全范围，停止充电"
			    echo "温度超过充电安全范围，停止充电" > /storage/emulated/TC/Result/CTC/current_present.log
	        else
			    if [ -f $recharging_current_freq_file_max ];then
			        if [ `cat $recharging_current_freq_file_max` -le 14000000 ];then
			            cat $recharging_current_freq_file_max > /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file ];then
			        if [ `cat $recharging_current_freq_file` -le 14000000 ];then
			            cat $recharging_current_freq_file >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_current_max ];then
			        if [ `cat $recharging_current_freq_file_current_max` -le 14000000 ];then
			            cat $recharging_current_freq_file_current_max >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_current_max_1 ];then
			        if [ `cat $recharging_current_freq_file_current_max_1` -le 14000000 ];then
			            cat $recharging_current_freq_file_current_max_1 >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_input_current_max_1 ];then
			        if [ `cat $recharging_current_freq_file_input_current_max_1` -le 14000000 ];then
			            cat $recharging_current_freq_file_input_current_max_1 >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_hw_current_max ];then
			        if [ `cat $recharging_current_freq_file_hw_current_max` -le 14000000 ];then
			            cat $recharging_current_freq_file_hw_current_max >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_pd_current_max ];then
			        if [ `cat $recharging_current_freq_file_pd_current_max` -le 14000000 ];then
			            cat $recharging_current_freq_file_pd_current_max >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    if [ -f $recharging_current_freq_file_qc3p5_current_max ];then
			        if [ `cat $recharging_current_freq_file_qc3p5_current_max` -le 14000000 ];then
			            cat $recharging_current_freq_file_qc3p5_current_max >> /storage/emulated/TC/Result/CTC/current_temp
			        fi
			    fi
			    current_temp=`cat /storage/emulated/TC/Result/CTC/current_temp|grep "000"|grep -v "-"|sort -unr|awk 'NR<2'`
		        if [ $Too_high_1 -ge 1 ]; then
		            ctc=1
			        mode=`expr $current_temp - $Reduce_current_size`
			        echo "温度过高，正在降低充电功率"
			        echo "温度过高，正在降低充电功率" > /storage/emulated/TC/Result/CTC/current_present.log
		        elif [ $Too_high_2 -lt 1 ]; then
		            ctc=1
			        mode=`expr $current_temp + $Reduce_current_size`
			        echo "温度恢复正常，满血充电"
			        echo "温度恢复正常，满血充电" > /storage/emulated/TC/Result/CTC/current_present.log
			    fi
			    #纠正上面超范围计算
			    if [ $Too_high_1 -lt 1 -a $Too_high_2 -ge 1 ];then
			        echo "温度正常，电流不会增减"
			        echo "温度正常，电流不会增减" > /storage/emulated/TC/Result/CTC/current_present.log
		        fi
		    fi
        fi
	    #执行计算好电流
	    if [ $ctc -eq 1 ];then
	    	    if [ $mode -le $Minimum_current ]; then
			        mode=$Minimum_current
		    	elif [ $mode -ge $Maximum_current ]; then
			        mode=$Maximum_current
			    fi
	        if [ -f $recharging_current_freq_file_max ];then
	            if [ `cat $recharging_current_freq_file_max` -ne $mode ];then
	                chmod 0666 $recharging_current_freq_file_max
                    echo $mode > $recharging_current_freq_file_max
                    chmod 0444 $recharging_current_freq_file_max
                fi
            fi
	        if [ -f $recharging_current_freq_file ];then
	            if [ `cat $recharging_current_freq_file` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file
                    echo $mode > $recharging_current_freq_file
                    chmod 0444 $recharging_current_freq_file
                fi
            fi
            if [ -f $recharging_current_freq_file_current_max ];then
	            if [ `cat $recharging_current_freq_file_current_max` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_current_max
                    echo $mode > $recharging_current_freq_file_current_max
                    chmod 0444 $recharging_current_freq_file_current_max
                fi
            fi
	        if [ -f $recharging_current_freq_file_current_max_1 ];then
	            if [ `cat $recharging_current_freq_file_current_max_1` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_current_max_1
                    echo $mode > $recharging_current_freq_file_current_max_1
                    chmod 0444 $recharging_current_freq_file_current_max_1
                fi
            fi
            if [ -f $recharging_current_freq_file_input_current_max ];then
	            if [ `cat $recharging_current_freq_file_input_current_max` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_input_current_max
                    echo $mode > $recharging_current_freq_file_input_current_max
                    chmod 0444 $recharging_current_freq_file_input_current_max
                fi
            fi
            if [ -f $recharging_current_freq_file_input_current_max_1 ];then
	            if [ `cat $recharging_current_freq_file_input_current_max_1` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_input_current_max_1
                    echo $mode > $recharging_current_freq_file_input_current_max_1
                    chmod 0444 $recharging_current_freq_file_input_current_max_1
                fi
            fi
            if [ -f $recharging_current_freq_file_hw_current_max ];then
	            if [ `cat $recharging_current_freq_file_hw_current_max` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_hw_current_max
                    echo $mode > $recharging_current_freq_file_hw_current_max
                    chmod 0444 $recharging_current_freq_file_hw_current_max
                fi
            fi
            if [ -f $recharging_current_freq_file_pd_current_max ];then
	            if [ `cat $recharging_current_freq_file_pd_current_max` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_pd_current_max
                    echo $mode > $recharging_current_freq_file_pd_current_max
                    chmod 0444 $recharging_current_freq_file_pd_current_max
                fi
            fi
            if [ -f $recharging_current_freq_file_qc3p5_current_max ];then
	            if [ `cat $recharging_current_freq_file_qc3p5_current_max` -ne $mode ];then
                    chmod 0666 $recharging_current_freq_file_qc3p5_current_max
                    echo $mode > $recharging_current_freq_file_qc3p5_current_max
                    chmod 0444 $recharging_current_freq_file_qc3p5_current_max
                fi
            fi
        fi
	    #日志
	    if [ $Charge -lt 0 ];then
	        if [ $Charge -gt -$Minimum_current ]; then
	    	    echo "正在慢速充电"
			    echo "正在慢速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
		    elif [ $Charge -le -$Minimum_current -a $current_temp -gt -$fast_charging ]; then
			    echo "正在快速充电"
			    echo "正在快速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
	        elif [ $Charge -le -$fast_charging ]; then
		        echo "正在极速充电"
	            echo "正在极速充电" > /storage/emulated/TC/Result/CTC/current_present_mode.log
	        fi
	    fi