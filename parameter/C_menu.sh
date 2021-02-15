#三级菜单

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#字体
Font=`cat $tc_path/Set_up/Font/Font`
#分类
Identify=`getprop ro.board.platform`
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
#模式
Current_mode=`cat $tc_path/parameter/PTC/Current_mode`
#检测是否运行
switch_mode=`cat $tc_path/parameter/switch`
#时间
Dynamic_time=`date +"%Y-%m-%d  %H:%M:%S"`
C_menu_Processor_parameter_adjustment(){
clear
if [ $Current_mode = A ]; then
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 参数调整

\t\t     1）SOC 温控参数
\t\t     2）均衡模式参数
\t\t     3）熄屏模式参数

\t\t     8）返回上一级
\t\t     9）返回主菜单
\t\t     0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/C_menu.sh C_menu_Processor_temperature_control
    ;;
    2)sh $path/C_menu.sh C_menu_Balanced_mode
    ;;
    3)sh $path/C_menu.sh C_menu_Off_screen_mode
    ;;
    8)sh $path/B_menu.sh B_menu_Parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    esac
else
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 参数调整

\t\t     1）SOC 温控参数

\t\t     8）返回上一级
\t\t     9）返回主菜单
\t\t     0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/C_menu.sh C_menu_Processor_temperature_control
    ;;
    8)sh $path/B_menu.sh B_menu_Parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    esac
fi
}
#soc温控菜单
C_menu_Processor_temperature_control(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 温控参数

\t\t   1）SOC 降频满血温度
\t\t   2）SOC 降频频率档位

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/C_menu.sh C_menu_Processor_temperature
;;
2)sh $path/C_menu.sh C_menu_Processor_downshift
;;
8)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_temperature_control
;;
esac
}
#soc温度菜单
C_menu_Processor_temperature(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 温控参数

\t\t     1）SOC 满血温度
\t\t     2）SOC 降频温度

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/D_menu.sh D_menu_Full_blood_temperature
;;
2)sh $path/D_menu.sh D_menu_Frequency_reduction_temperature
;;
8)sh $path/C_menu.sh C_menu_Processor_temperature_control
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_temperature
;;
esac
}
#降频档位
C_menu_Processor_downshift(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     SOC 降频频率档位

\t\t    1）小核心降频档位
\t\t    2）中核心降频档位
\t\t    3）大核心降频档位
\t\t    4）G P U 降频档位

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Small_core_downshift
    ;;
    2)sh $path/D_menu.sh D_menu_Mid-core_downshift
    ;;
    3)sh $path/D_menu.sh D_menu_Big_core_downshift
    ;;
    4)sh $path/D_menu.sh D_menu_GPU_downshift
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_temperature_control
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Processor_downshift
    ;;
    esac
else
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     SOC 降低频率档位

\t\t    1）小核心降频档位
\t\t    2）大核心降频档位
\t\t    3）G P U 降频档位

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Small_core_downshift
    ;;
    2)sh $path/D_menu.sh D_menu_Big_core_downshift
    ;;
    3)sh $path/D_menu.sh D_menu_GPU_downshift
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_temperature_control
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Processor_downshift
    ;;
    esac
fi
}
#均衡菜单
C_menu_Balanced_mode(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       均衡模式参数

\t\t    1）小核心最高频率
\t\t    2）中核心最高频率
\t\t    3）大核心最高频率
\t\t    4）G P U 最高频率

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Balance_small_core_frequency
    ;;
    2)sh $path/D_menu.sh D_menu_Core_frequency_in_equalization
    ;;
    3)sh $path/D_menu.sh D_menu_Balance_large_core_frequency
    ;;
    4)sh $path/D_menu.sh D_menu_Balance_GPU_frequency
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Balanced_mode
    ;;
    esac
else
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       均衡模式参数

\t\t    1）小核心最高频率
\t\t    2）大核心最高频率
\t\t    3）G P U 最高频率

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Balance_small_core_frequency
    ;;
    2)sh $path/D_menu.sh D_menu_Balance_large_core_frequency
    ;;
    3)sh $path/D_menu.sh D_menu_Balance_GPU_frequency
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Balanced_mode
    ;;
    esac
fi
}
#熄屏菜单
C_menu_Off_screen_mode(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       熄屏模式参数

\t\t    1）小核心最高频率
\t\t    2）中核心最高频率
\t\t    3）大核心最高频率

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Screen_off_small_core_frequency
    ;;
    2)sh $path/D_menu.sh D_menu_Core_frequency_in_off_screen
    ;;
    3)sh $path/D_menu.sh D_menu_Screen_off_big_core_frequency
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Off_screen_mode
    ;;
    esac
else
    echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       熄屏模式参数

\t\t    1）小核心最高频率
\t\t    2）大核心最高频率

\t\t    8）返回上一级
\t\t    9）返回主菜单
\t\t    0）退出
"
    echo -ne "\t\t   请选择："
    read Options
    case $Options in
    1)sh $path/D_menu.sh D_menu_Screen_off_small_core_frequency
    ;;
    2)sh $path/D_menu.sh D_menu_Screen_off_big_core_frequency
    ;;
    8)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
    ;;
    9)sh $path/A_menu.sh
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m   输入有误重新输入"
    sleep 0.1
    sh $path/C_menu.sh C_menu_Off_screen_mode
    ;;
    esac
fi
}

#充电菜单
C_menu_Charging_parameter_adjustment(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       充电参数调整

\t\t       1）充电温度
\t\t       2）充电速度

\t\t       8）返回上一级
\t\t       9）返回主菜单
\t\t       0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/C_menu.sh C_menu_Charging_temperature
;;
2)sh $path/C_menu.sh C_menu_Charging_speed
;;
8)sh $path/B_menu.sh B_menu_Parameter_adjustment
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/C_menu.sh C_menu_Charging_parameter_adjustment
;;
esac
}
#充电温度菜单
C_menu_Charging_temperature(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         充电温度

\t\t    1）提升快充的温度
\t\t    2）降低快充的温度

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/D_menu.sh D_menu_Fast_charge_to_increase_temperature
;;
2)sh $path/D_menu.sh D_menu_Reduce_charging_speed
;;
8)sh $path/C_menu.sh C_menu_Charging_parameter_adjustment
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/C_menu.sh C_menu_Charging_temperature
;;
esac
}
#充电速度菜单
C_menu_Charging_speed(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         充电速度

\t\t     1）最高充电速度
\t\t     2）最低充电速度
\t\t     3）调整充电电流

\t\t     8）返回上一级
\t\t     9）返回主菜单
\t\t     0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/D_menu.sh D_menu_Maximum_charging_current
;;
2)sh $path/D_menu.sh D_menu_Minimum_charging_current
;;
3)sh $path/D_menu.sh D_menu_Adjust_the_charging_current
;;
8)sh $path/C_menu.sh C_menu_Charging_parameter_adjustment
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/C_menu.sh C_menu_Charging_speed
;;
esac
}

#调用菜单
$1