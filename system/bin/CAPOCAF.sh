#!/system/bin/sh
{
while true
do
sleep 1
#时间
date
thermal_engine=/system/vendor/bin/thermal-engine
thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
        #创建文件夹
	    if [ ! -d "/sbin/TC/Result/CTC" ]; then
	        mkdir -p "/sbin/TC/Result/CTC"
	    else
	        echo "/sbin/TC/Result/CTC已存在"
	    fi
		if [ ! -d "/sbin/TC/Result/PTC" ]; then
	        mkdir -p "/sbin/TC/Result/PTC"
	    else
	        echo "'/sbin/TC/Result/PTC'已存在"
	    fi
        if [ ! -d '/sbin/TC/parameter/CTC' ]; then
            mkdir -p '/sbin/TC/parameter/CTC'
        else
            echo "'/sbin/TC/parameter/CTC'已存在"
        fi
        if [ ! -d '/sbin/TC/parameter/PTC' ]; then
            mkdir -p '/sbin/TC/parameter/PTC'
        else
            echo "'/sbin/TC/parameter/PTC'已存在"
        fi
	    if [ ! -f $thermal_engine -o $thermal_engine_zf -eq 0 ]; then
	        echo "温控已被移出继续运行"
            #复制文件
            if [ ! -f '/sbin/TC/设置参数.sh' ]; then
                cp /system/etc/设置参数.sh /sbin/TC/
                sh /sbin/TC/设置参数.sh
                echo '2'
            else
                echo "'设置参数.sh'文件已存在"
                sh /sbin/TC/设置参数.sh
            fi
            if [ ! -f '/sbin/TC/13.txt' ]; then
                rm -rf /sbin/TC/设置参数.sh /sbin/TC/12.txt
                touch '/sbin/TC/13.txt'
                echo '1'
            else
                echo "最新版本"
            fi
        elif [ $thermal_engine_zf -gt 0 ]; then
            rm -rf '/sbin/.magisk/modules/Delete_temperature_control'
            echo "温控存在停止运行"
        fi
done
}