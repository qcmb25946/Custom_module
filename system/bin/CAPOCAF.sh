#!/system/bin/sh

#杂项，创建文件夹，检测"设置参数"文件是否被删除，跟新文件

while true
do
sleep 1
#时间
date
thermal_engine=/system/vendor/bin/thermal-engine
        #创建文件夹
	    if [ ! -d "/storage/emulated/TC/Result/CTC" ]; then
	        mkdir -p "/storage/emulated/TC/Result/CTC"
	    else
	        echo "/storage/emulated/TC/Result/CTC已存在"
	    fi
		if [ ! -d "/storage/emulated/TC/Result/PTC" ]; then
	        mkdir -p "/storage/emulated/TC/Result/PTC"
	    else
	        echo "'/storage/emulated/TC/Result/PTC'已存在"
	    fi
        if [ ! -d '/storage/emulated/TC/parameter/CTC' ]; then
            mkdir -p '/storage/emulated/TC/parameter/CTC'
        else
            echo "'/storage/emulated/TC/parameter/CTC'已存在"
        fi
        if [ ! -d '/storage/emulated/TC/parameter/PTC' ]; then
            mkdir -p '/storage/emulated/TC/parameter/PTC'
        else
            echo "'/storage/emulated/TC/parameter/PTC'已存在"
        fi
        if [ ! -d '/storage/emulated/TC/script/CTC' ]; then
            mkdir -p '/storage/emulated/TC/script/CTC'
        else
            echo "'/storage/emulated/TC/script/CTC'已存在"
        fi
        if [ ! -d '/storage/emulated/TC/script/PTC' ]; then
            mkdir -p '/storage/emulated/TC/script/PTC'
        else
            echo "'/storage/emulated/TC/script/PTC'已存在"
        fi
        if [ ! -d '/storage/emulated/TC/script/LOG' ]; then
            mkdir -p '/storage/emulated/TC/script/LOG'
        else
            echo "'/storage/emulated/TC/script/LOG'已存在"
        fi
	    if [ ! -e $thermal_engine ]; then
	        echo "温控已被移出继续运行"
            #复制文件
            if [ ! -e '/storage/emulated/TC/设置参数.sh' ]; then
                cp /system/etc/设置参数.sh /storage/emulated/TC/
                sh /storage/emulated/TC/设置参数.sh
                echo '2'
            else
                echo "'设置参数.sh'文件已存在"
                sh /storage/emulated/TC/设置参数.sh
            fi
            if [ ! -e '/storage/emulated/TC/13.txt' ]; then
                rm -rf /storage/emulated/TC/设置参数.sh /storage/emulated/TC/12.txt
                touch '/storage/emulated/TC/13.txt'
                echo '1'
            else
                echo "最新版本"
            fi
        else
            thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
            if [ $thermal_engine_zf -eq 0 ]; then
                echo "成功用空文件顶替温控"
                #复制文件
                if [ ! -e '/storage/emulated/TC/设置参数.sh' ]; then
                    cp /system/etc/设置参数.sh /storage/emulated/TC/
                    sh /storage/emulated/TC/设置参数.sh
                    echo '2'
                else
                    echo "'设置参数.sh'文件已存在"
                    sh /storage/emulated/TC/设置参数.sh
                fi
                if [ ! -e '/storage/emulated/TC/14.txt' ]; then
                    rm -rf /storage/emulated/TC/*
                    touch '/storage/emulated/TC/14.txt'
                    echo '1'
                else
                    echo "最新版本"
                fi
            elif [ $thermal_engine_zf -gt 0 ]; then
                rm -rf '/sbin/.magisk/modules/Delete_temperature_control'
                echo "温控存在停止运行"
            fi
        fi
done