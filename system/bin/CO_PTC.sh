#!/system/bin/sh
while true
do
sleep 1
thermal_engine="/system/vendor/bin/thermal-engine"
if [ ! -e $thermal_engine ]; then
    echo "成功删除温控"
    sh /system/bin/PTC.sh
else
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
    if [ $thermal_engine_zf -eq 0 ]; then
        echo "成功用空文件顶替温控"
        sh /system/bin/PTC.sh
    elif [ $thermal_engine_zf -ne 0 ]; then
        echo "请移出温控"
        if [ Log ]; then
	        if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前超大核最大频率=`cat $cpu7_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu3_max_freq_file_fixed -a -e $cpu5_max_freq_file_fixed -a -e $cpu7_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu6_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu3_max_freq_file_fixed -a -e $cpu5_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu4_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		    elif [ -e $cpu3_max_freq_file_fixed ]; then
			    echo "当前小核最大频率=`cat $cpu0_max_freq_file_control`
当前大核最大频率=`cat $cpu2_max_freq_file_control`
当前GPU最大频率=`cat $gpu_max_freq_file_control`" > /sdcard/TC/Result/PTC/soc_max_freq_Current
		    fi
        fi
    fi
fi
done