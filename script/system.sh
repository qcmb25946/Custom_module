#!/system/bin/sh


#系统设置

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#系统设置开关
system="$zdy_path/system"
#selinux
#selinux开关
selinux="$(cat "$system/selinux")"
#当前查看selinux开关
selinux_current_state="$(getenforce)"
#查看selinux开关
if [ "$selinux" = "Y" ];then
    #当前selinux开关
    if [ "$selinux_current_state" = "Enforcing" ];then
        setenforce 0
    fi
#打开selinux
elif [ "$selinux" = "O" ];then
    if [ "$selinux_current_state" = "Permissive" ];then
        setenforce 1
    fi
    echo N > "$system/selinux"
fi

#zram
#zram开关
zram_switch="$(cat "$system/zram_switch")"
#zram容量
zram_capacity="$(cat "$system/zram_capacity")"
#当前zram容量
zram_current_capacity="$(echo $(free -m|grep -i "swap")|cut -d" " -f2)"
#zram计算
zram_calculation="$(echo "$(($zram_capacity-$zram_current_capacity))")"
if [ "$zram_calculation" -lt "0" ];then
    zram_calculation_results="$(($zram_calculation*-1))"
else
    zram_calculation_results=$zram_calculation
fi
#zram调整开关
if [ "$zram_switch" = "Y" ];then
    if [ "$zram_current_capacity" = "0" ];then
        echo 1 > "/sys/block/zram0/reset"
        echo "${zram_capacity}m" > "/sys/block/zram0/disksize"
        mkswap "/dev/block/zram0"
        swapon "/dev/block/zram0"
    else
        if [ "$zram_calculation_results" -ge "3" ];then
            echo "" > "$system/zram_process"
            swapoff "/dev/block/zram0"
            echo 1 > "/sys/block/zram0/reset"
            echo "${zram_capacity}m" > "/sys/block/zram0/disksize"
            mkswap "/dev/block/zram0"
            swapon "/dev/block/zram0"
            rm -rf "$system/zram_process"
        fi
    fi
#关闭zram
elif [ "$zram_switch" = "O" ];then
    if [ "$zram_current_capacity" != "0" ];then
        echo "" > "$system/zram_process"
        swapoff "/dev/block/zram0"
        rm -rf "$system/zram_process"
    fi
fi
#网络更新时间

sleep 3
done