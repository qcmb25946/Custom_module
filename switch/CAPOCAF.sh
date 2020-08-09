#!/system/bin/sh

#杂项，创建文件夹，检测"设置参数"文件是否被删除，跟新文件

#路径
tc_path=/storage/emulated/TC/
while true
do
sleep 1
#时间
date
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
#版本更新检测
#创建文件夹
	    if [ ! -d "/storage/emulated/TC" ]; then
	        mkdir -p "/storage/emulated/TC"
	    fi
#版本更新检测
        if [ ! -e '/storage/emulated/TC/2020-08-07_21:37' ]; then
            rm -rf /storage/emulated/TC/*
            touch '/storage/emulated/TC/2020-08-07_21:37'
        fi
        #创建文件夹
	    if [ ! -d "/storage/emulated/TC/Result/CTC" ]; then
	        mkdir -p "/storage/emulated/TC/Result/CTC"
	    fi
		if [ ! -d "/storage/emulated/TC/Result/PTC" ]; then
	        mkdir -p "/storage/emulated/TC/Result/PTC"
	    fi
        if [ ! -d '/storage/emulated/TC/parameter/CTC' ]; then
            mkdir -p '/storage/emulated/TC/parameter/CTC'
        fi
        if [ ! -d '/storage/emulated/TC/parameter/PTC' ]; then
            mkdir -p '/storage/emulated/TC/parameter/PTC'
        fi
        if [ ! -d '/storage/emulated/TC/Set_up/colour/Font' ];then
            mkdir -p '/storage/emulated/TC/Set_up/colour/Font'
        fi
        #温控开关
        if [ ! -e "${tc_path}parameter/switch" ];then
            echo K > ${tc_path}parameter/switch
        fi

        #模式
        if [ ! -e "${tc_path}parameter/PTC/Current_mode" ];then
            echo A > ${tc_path}parameter/PTC/Current_mode
        fi
#移植参数
        if [ `cat $switch` = 'K' ];then
	        if [ ! -e $thermal_engine ]; then
	            echo "温控已被移出继续运行"
                sh /data/adb/modules/Custom_temperature_control/Transit/Parameter_passing.sh
            else
                thermal_engine_zf=`wc -m $thermal_engine | cut -c -1`
                if [ $thermal_engine_zf -eq 0 ]; then
                    echo "成功用空文件顶替温控"
                    sh /data/adb/modules/Custom_temperature_control/Transit/Parameter_passing.sh
#停止运行
                elif [ $thermal_engine_zf -gt 0 ]; then
                    echo "温控存在停止运行"
                fi
            fi
        fi
done