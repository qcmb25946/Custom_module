#杂项，创建文件夹，检测"设置参数"文件是否被删除，跟新文件

#路径
tc_path=/storage/emulated/TC/
while true
do
sleep 3
#时间
date
thermal_engine=/system/vendor/etc/thermal-engine.conf
switch=/storage/emulated/TC/parameter/switch
IMEI=`service call iphonesubinfo 1|awk '{print $NF}'|grep -v "[()]"|xargs|tr -cd "[0-9]"`
CTC_folder=`find /sdcard/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv/ -name '*自定义温控*'|wc -w`
aaa_folder=`find /sdcard/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv/ -name 'aaa*'|wc -w`
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
        if [ ! -d '/storage/emulated/TC/colour/Font' ];then
            mkdir -p '/storage/emulated/TC/Set_up/Font'
        fi
        if [ ! -d '/storage/emulated/TC/Set_up/background' ];then
            mkdir -p '/storage/emulated/TC/Set_up/background'
        fi
        if [ ! -d '/storage/emulated/TC/Result/CPUS' ];then
            mkdir -p '/storage/emulated/TC/Result/CPUS'
        fi
        #温控开关
        if [ ! -e "${tc_path}parameter/switch" ];then
            echo K > ${tc_path}parameter/switch
        fi
        #模式
        if [ ! -e "${tc_path}parameter/PTC/Current_mode" ];then
            echo A > ${tc_path}parameter/PTC/Current_mode
        fi
        if [ $CTC_folder -ne 0 -o $aaa_folder -ne 0 ];then
            if [ ! -d "/sdcard/自定义温控" ];then
                mkdir /sdcard/自定义温控
            fi
            find /sdcard/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv/ -name '*自定义温控*' > /sdcard/CTC_folder
            find /sdcard/Android/data/com.tencent.mobileqq/Tencent/QQfile_recv/ -name 'aaa*' >> /sdcard/CTC_folder
            sed -i "s/^/mv /g" /sdcard/CTC_folder
            sed -i "s/$/ \/sdcard\/自定义温控\//g" /sdcard/CTC_folder
            sh /sdcard/CTC_folder
            rm -rf /sdcard/CTC_folder
        fi
#移植参数
        if [ `cat $switch` = 'K' ];then
            sh /data/adb/modules/Custom_temperature_control/Transit/Parameter_passing.sh
            sh /data/adb/modules/Custom_temperature_control/Transit/cpuset.sh
        fi
done