#!/bin/sh

#处理器温控参数设置

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#cpu频率表
cpu0_Frequency_table=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
cpu1_Frequency_table=/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies
cpu2_Frequency_table=/sys/devices/system/cpu/cpu2/cpufreq/scaling_available_frequencies
cpu3_Frequency_table=/sys/devices/system/cpu/cpu3/cpufreq/scaling_available_frequencies
cpu4_Frequency_table=/sys/devices/system/cpu/cpu4/cpufreq/scaling_available_frequencies
cpu5_Frequency_table=/sys/devices/system/cpu/cpu5/cpufreq/scaling_available_frequencies
cpu6_Frequency_table=/sys/devices/system/cpu/cpu6/cpufreq/scaling_available_frequencies
cpu7_Frequency_table=/sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies
#周围
around=`cat $tc_path/Set_up/colour/Font/around`
#字体
Font=`cat $tc_path/Set_up/colour/Font/Font`
#选项
Option=`cat $tc_path/Set_up/colour/Font/Options`
#模式
Current_mode=`cat $tc_path/parameter/PTC/Current_mode`
if [ $Current_mode = A ]; then
    mode=默认模式
elif [ $Current_mode = B ]; then
    mode=重度模式
fi
#分辨架构
Identify=`getprop ro.board.platform`
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"

#时间
if [ `date +%u` -eq 1 ]; then
    Z='星期一'
elif [ `date +%u` -eq 2 ]; then
    Z='星期二'
elif [ `date +%u` -eq 3 ]; then
    Z='星期三'
elif [ `date +%u` -eq 4 ]; then
    Z='星期四'
elif [ `date +%u` -eq 5 ]; then
    Z='星期五'
elif [ `date +%u` -eq 6 ]; then
    Z='星期六'
elif [ `date +%u` -eq 7 ]; then
    Z='星期日'
fi
Dynamic_time=`date +"%Y-%m-%d %H:%M:%S $Z"`
#处理器温控菜单
CO_PTC(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整SOC温控参数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.调整降频满血温度            \t\e[${around}m*
\t*\t\e[${Font}m2.调整频率和档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mh.帮助(开发中)                \t\e[${around}m*
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)Temperature_control_temperature
;;
2)Frequency_reduction_and_frequency
;;
h)Z_prompt
CO_PTC
;;
m)sh $path/A_menu.sh
;;
r)sh $path/B_menu.sh B_menu_Parameter_adjustment
;;
q)exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
CO_PTC
;;
esac
}
#调整降频满血温度
Temperature_control_temperature(){
Limit_threshold=`echo "$(cat $tc_path/parameter/PTC/Limit_threshold) 10" | awk '{print $1/$2}'`
Open_threshold=`echo "$(cat $tc_path/parameter/PTC/Open_threshold) 10" | awk '{print $1/$2}'`
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整SOC降频满血温度        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前设置温度阈值            \t\e[${around}m*
\t*\t\e[${Font}m充电保护温度：$Limit_threshold度       \t\e[${around}m*
\t*\t\e[${Font}m充电满血温度：$Open_threshold度        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：79.5 64.5\t\e[${around}m*
\t*\t\e[${Font}m注1：参考传感器：gpu       \t\e[${around}m*
\t*\t\e[${Font}m注2：第一个是降频温度      \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个是满血温度      \t\e[${around}m*
\t*\t\e[${Font}m注4：第一个数大于第二个数\t\e[${around}m*
\t*\t\e[${Font}m注5：不要设置过多小数一般一位\t\e[${around}m*
\t*\t\e[${Font}m小数即可                \t\e[${around}m*
\t*\t\e[${Font}m注6：不要过分设置过高的温度\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请按格式输入："
read Options
Options_1=`echo $Options|awk '{print $1}'`
Options_2=`echo $Options|awk '{print $2}'`
judgment_1=`echo $Options_1|cut -c1|sed 's/[0-9]//g'|sed "s/ //g"`
judgment_2=`echo $Options_2|cut -c1|sed 's/[0-9]//g'|sed "s/ //g"`
if [ -z $Options_2 ];then
    case $Options in
    m)sh $path/A_menu.sh;;
    r)CO_PTC;;
    q)exit;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Temperature_control_temperature;;
    esac
else
    judgment_3=`echo $Options|sed 's/[0-9.]//g'|sed "s/ //g"`
    if [ -z $judgment_1 ];then
        if [ -z $judgment_2 ];then
            if [ -z $judgment_3 ];then
                awk_Options_10_2=`echo "$Options_2 10"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_10_1=`echo "$Options_1 10"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_100_1=`echo "$Options_1 100"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_100_2=`echo "$Options_2 100"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options=`echo "$Options_1 $Options_2"|awk '{print $1/$2}'|cut -d. -f1`
                if [ $awk_Options_10_1 -lt 1 -o $awk_Options_10_2 -lt 1 -o $awk_Options_100_1 -ge 1 -o $awk_Options_100_2 -ge 1 -o $awk_Options -lt 1 ];then
                    echo -e "\t\e[31m输入有误，重新输入(不能设置过高的温度阈值，不能满血温度高于降频温度)"
                    sleep 1
                    Temperature_control_temperature
                else
                    echo "OK"
                    Limit_threshold=`echo "$Options_1 10"|awk '{print $1*$2}'`
                    Open_threshold=`echo "$Options_2 10"|awk '{print $1*$2}'`
                    echo $Limit_threshold > $tc_path/parameter/PTC/Limit_threshold
                    echo $Open_threshold > $tc_path/parameter/PTC/Open_threshold
                    Z_Countdown
                    echo "设置成功"
                    sleep 1
                    CO_PTC
                fi
            fi
        fi
    fi
fi
echo -e "\t\e[31m输入有误，重新输入(除了数字和小数点其他不能输入)"
sleep 1
Temperature_control_temperature
}
#设置降频和频率
Frequency_reduction_and_frequency(){
clear
if [ $Current_mode = 'A' ];then
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整频率档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前模式：$mode         \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.调整降频档位              \t\e[${around}m*
\t*\t\e[${Font}m2.均衡模式频率调整         \t\e[${around}m*
\t*\t\e[${Font}m3.熄屏模式频率调整          \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请选择："
    read Options
    case $Options in
    1)Frequency_reduction_gear
    ;;
    2)Equalization_mode_frequency
    ;;
    3)Off-screen_mode_menu
    ;;
    m)sh $path/A_menu.sh
    ;;
    r)CO_PTC
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Frequency_reduction_and_frequency
    ;;
    esac
else
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整频率档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前模式：$mode         \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.调整降频档位               \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请选择："
    read Options
    case $Options in
    1)Frequency_reduction_gear
    ;;
    m)sh $path/A_menu.sh
    ;;
    r)CO_PTC
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Frequency_reduction_and_frequency
    ;;
    esac
fi
}
#降频档位
Frequency_reduction_gear(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    small_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/small_cpu_Frequency_reduction`
    big_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/big_cpu_Frequency_reduction`
    super_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/super_cpu_Frequency_reduction`
    gpu_Frequency_reduction=`cat $tc_path/parameter/PTC/gpu_Frequency_reduction`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整频率档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核降频档位：$small_cpu_Frequency_reduction     \t\e[${around}m*
\t*\t\e[${Font}m当前大核降频档位：$big_cpu_Frequency_reduction      \t\e[${around}m*
\t*\t\e[${Font}m当前超大核降频档位：$super_cpu_Frequency_reduction    \t\e[${around}m*
\t*\t\e[${Font}m当前GPU降频档位：$gpu_Frequency_reduction      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：1 1 1 1或1 1 1\e[${around}m*
\t*\t\e[${Font}m注1：1代表降低一档频率     \t\e[${around}m*
\t*\t\e[${Font}m注2：默认最低为一档     \t\e[${around}m*
\t*\t\e[${Font}m注3：cpu最高为5档 gpu为3档 \t\e[${around}m*
\t*\t\e[${Font}m注4：根据cpu频率表排序进行降频\t\e[${around}m*
\t*\t\e[${Font}m注3：第一个数代表小核心     \t\e[${around}m*
\t*\t\e[${Font}m注5：第二个数代表大核心     \t\e[${around}m*
\t*\t\e[${Font}m注6：第三个数代表超大核心   \t\e[${around}m*
\t*\t\e[${Font}m注7：第四个数代表GPU       \t\e[${around}m*
\t*\t\e[${Font}m注8：重度模式另外再加一档或两档\t\e[${around}m*
\t*\t\e[${Font}m注9：重度模式GPU不加档位    \t\e[${around}m*
\t*\t\e[${Font}m注10：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_2=`echo $Options|awk '{print $3}'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    Options_5=`echo $Options|awk '{print $4}'|sed 's/ //g'`
    if [ ! -z $Options_5 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge 0 -a $Options_2 -lt 5 -a $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 -a $Options_5 -ge 0 -a $Options_5 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/big_cpu_Frequency_reduction
                echo $Options_2 > $tc_path/parameter/PTC/super_cpu_Frequency_reduction
                echo $Options_5 > $tc_path/parameter/PTC/gpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    elif [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge 0 -a $Options_2 -lt 5 -a $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/big_cpu_Frequency_reduction
                echo $Options_2 > $tc_path/parameter/PTC/super_cpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Frequency_reduction_and_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Frequency_reduction_gear
    ;;
    esac
elif [ -e $cpu7_max_freq_file_control ]; then
    small_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/small_cpu_Frequency_reduction`
    super_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/super_cpu_Frequency_reduction`
    gpu_Frequency_reduction=`cat $tc_path/parameter/PTC/gpu_Frequency_reduction`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整频率档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核降频档位：$small_cpu_Frequency_reduction     \t\e[${around}m*
\t*\t\e[${Font}m当前大核降频档位：$super_cpu_Frequency_reduction    \t\e[${around}m*
\t*\t\e[${Font}m当前GPU降频档位：$gpu_Frequency_reduction      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：1 1 1或1 1\e[${around}m*
\t*\t\e[${Font}m注1：1代表降低一档频率     \t\e[${around}m*
\t*\t\e[${Font}m注2：默认最低为一档     \t\e[${around}m*
\t*\t\e[${Font}m注3：cpu最高为5档 gpu为3档 \t\e[${around}m*
\t*\t\e[${Font}m注4：根据cpu频率表排序进行降频\t\e[${around}m*
\t*\t\e[${Font}m注3：第一个数代表小核心     \t\e[${around}m*
\t*\t\e[${Font}m注5：第二个数代表大核心     \t\e[${around}m*
\t*\t\e[${Font}m注6：第三个数代表超大核心   \t\e[${around}m*
\t*\t\e[${Font}m注7：第四个数代表GPU       \t\e[${around}m*
\t*\t\e[${Font}m注8：重度模式另外再加一档或两档\t\e[${around}m*
\t*\t\e[${Font}m注9：重度模式GPU不加档位    \t\e[${around}m*
\t*\t\e[${Font}m注10：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_2=`echo $Options|awk '{print $3}'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge 0 -a $Options_2 -lt 5 -a $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/super_cpu_Frequency_reduction
                echo $Options_2 > $tc_path/parameter/PTC/gpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    elif [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/super_cpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Frequency_reduction_and_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Frequency_reduction_gear
    ;;
    esac

elif [ -e $cpu3_max_freq_file_control ]; then
    small_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/small_cpu_Frequency_reduction`
    big_cpu_Frequency_reduction=`cat $tc_path/parameter/PTC/big_cpu_Frequency_reduction`
    gpu_Frequency_reduction=`cat $tc_path/parameter/PTC/gpu_Frequency_reduction`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整频率档位              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核降频档位：$small_cpu_Frequency_reduction     \t\e[${around}m*
\t*\t\e[${Font}m当前大核降频档位：$big_cpu_Frequency_reduction      \t\e[${around}m*
\t*\t\e[${Font}m当前GPU降频档位：$gpu_Frequency_reduction      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：1 1 1或1 1\e[${around}m*
\t*\t\e[${Font}m注1：1代表降低一档频率     \t\e[${around}m*
\t*\t\e[${Font}m注2：默认最低为一档     \t\e[${around}m*
\t*\t\e[${Font}m注3：cpu最高为5档 gpu为3档 \t\e[${around}m*
\t*\t\e[${Font}m注4：根据cpu频率表排序进行降频\t\e[${around}m*
\t*\t\e[${Font}m注3：第一个数代表小核心     \t\e[${around}m*
\t*\t\e[${Font}m注5：第二个数代表大核心     \t\e[${around}m*
\t*\t\e[${Font}m注6：第三个数代表超大核心   \t\e[${around}m*
\t*\t\e[${Font}m注7：第四个数代表GPU       \t\e[${around}m*
\t*\t\e[${Font}m注8：重度模式另外再加一档或两档\t\e[${around}m*
\t*\t\e[${Font}m注9：重度模式GPU不加档位    \t\e[${around}m*
\t*\t\e[${Font}m注10：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_2=`echo $Options|awk '{print $3}'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge 0 -a $Options_2 -lt 5 -a $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/big_cpu_Frequency_reduction
                echo $Options_2 > $tc_path/parameter/PTC/gpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    elif [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge 0 -a $Options_3 -lt 5 -a $Options_4 -ge 0 -a $Options_4 -lt 5 ];then
                echo ok
                echo $Options_4 > $tc_path/parameter/PTC/small_cpu_Frequency_reduction
                echo $Options_3 > $tc_path/parameter/PTC/big_cpu_Frequency_reduction
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Frequency_reduction_and_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Frequency_reduction_gear
    ;;
    esac
fi
}
#均衡模式菜单
Equalization_mode_frequency(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m均衡模式频率最高上线        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.CPU最高频率                \t\e[${around}m*
\t*\t\e[${Font}m2.GPU最高频率                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)CPU_equalization_frequency
;;
2)GPU_equalization_frequency
;;
m)sh $path/A_menu.sh
;;
r)Frequency_reduction_and_frequency
;;
q)exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
Equalization_mode_frequency
;;
esac
}
#cpu均衡频率
CPU_equalization_frequency(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    Daily_frequency_of_small_core=`cat $tc_path/parameter/PTC/Daily_frequency_of_small_core`
    Big_core_daily_frequency=`cat $tc_path/parameter/PTC/Big_core_daily_frequency`
    super_core_daily_frequency=`cat $tc_path/parameter/PTC/super_core_daily_frequency`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整均衡模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Daily_frequency_of_small_core     \t\e[${around}m*
\t*\t\e[${Font}m当前大核频率：$Big_core_daily_frequency      \t\e[${around}m*
\t*\t\e[${Font}m当前超大核频率：$super_core_daily_frequency    \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：15000 18000 20000\t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率前五位即可以\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注4：第三个输入是超大核CPU \t\e[${around}m*
\t*\t\e[${Font}m注5：15000代表1.5G频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_2=`echo $Options|awk '{print $3}'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge 10000 -a $Options_2 -lt 31000 -a $Options_3 -ge 10000 -a $Options_3 -lt 31000 -a $Options_4 -ge 10000 -a $Options_4 -lt 31000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Daily_frequency_of_small_core
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/Big_core_daily_frequency
                echo $(($Options_2*100)) > $tc_path/parameter/PTC/super_core_daily_frequency
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Equalization_mode_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
elif [ -e $cpu7_max_freq_file_control ]; then
    Daily_frequency_of_small_core=`cat $tc_path/parameter/PTC/Daily_frequency_of_small_core`
    super_core_daily_frequency=`cat $tc_path/parameter/PTC/super_core_daily_frequency`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整均衡模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Daily_frequency_of_small_core     \t\e[${around}m*
\t*\t\e[${Font}m当前超大核频率：$super_core_daily_frequency    \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：15000 20000  \t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率前五位即可以  \t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注5：15000代表1.5G频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge 10000 -a $Options_3 -lt 31000 -a $Options_4 -ge 10000 -a $Options_4 -lt 31000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Daily_frequency_of_small_core
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/super_core_daily_frequency
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Equalization_mode_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
elif [ -e $cpu3_max_freq_file_control ]; then
    Daily_frequency_of_small_core=`cat $tc_path/parameter/PTC/Daily_frequency_of_small_core`
    Big_core_daily_frequency=`cat $tc_path/parameter/PTC/Big_core_daily_frequency`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整均衡模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Daily_frequency_of_small_core     \t\e[${around}m*
\t*\t\e[${Font}m当前大核频率：$Big_core_daily_frequency      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：15000 20000\t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率前五位即可以\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注5：15000代表1.5G频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge 10000 -a $Options_3 -lt 31000 -a $Options_4 -ge 10000 -a $Options_4 -lt 31000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Daily_frequency_of_small_core
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/Big_core_daily_frequency
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Equalization_mode_frequency
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
fi
}
#gpu均衡频率
GPU_equalization_frequency(){
clear
Video_card_daily_frequency=`cat $tc_path/parameter/PTC/Video_card_daily_frequency`
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整均衡模式下的GPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mGPU频率：$Video_card_daily_frequency\t\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：45000  \t\e[${around}m*
\t*\t\e[${Font}m注1：低于1G频率的输入前5位\t\e[${around}m*
\t*\t\e[${Font}m注2：45000代表均衡模式低于450mhz\e[${around}m*
\t*\t\e[${Font}m注3：取值范围10000-100000\t\e[${around}m*
\t*\t\e[${Font}m注4：禁止设置小数          \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请按格式输入："
read Options
Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
if [ ! -z $Options ];then
    if [ -z $Options_1 ];then
        Options_1_1=`echo "$Options 30000"|awk '{print $1/$2}'|cut -d. -f1`
        Options_60_1=`echo "$Options 100000"|awk '{print $1/$2}'|cut -d. -f1`
        if [ $Options_1_1 -ge 1 -a $Options_60_1 -lt 1 ];then
            echo ok
            echo $(($Options*10000)) > $tc_path/parameter/PTC/Video_card_daily_frequency
            Z_Countdown
            echo "设置完成"
            sleep 1
            CO_PTC
        fi
    fi
fi
case $Options in
m)sh $path/A_menu.sh
;;
r)Equalization_mode_frequency
;;
q)exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
GPU_equalization_frequency
;;
esac
}

#熄屏模式菜单
Off-screen_mode_menu(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m熄屏模式频率最高上线        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.CPU 最高频率                \t\e[${around}m*
\t*\t\e[${Font}m2.熄屏延迟执行                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)CPU_screen_off_frequency
;;
2)Screen_off_delay
;;
m)sh $path/A_menu.sh
;;
r)Frequency_reduction_and_frequency
;;
q)exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
Off-screen_mode_menu
;;
esac
}
#CPU熄屏频率
CPU_screen_off_frequency(){
clear
if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
    Small_core_Power_saving=`cat $tc_path/parameter/PTC/Small_core_Power_saving`
    big_core_Power_saving=`cat $tc_path/parameter/PTC/big_core_Power_saving`
    super_core_Power_saving=`cat $tc_path/parameter/PTC/super_core_Power_saving`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整熄屏模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Small_core_Power_saving     \t\e[${around}m*
\t*\t\e[${Font}m当前大核频率：$big_core_Power_saving      \t\e[${around}m*
\t*\t\e[${Font}m当前超大核频率：$super_core_Power_saving    \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：5000 6000 9000\t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率除以100的结果即可\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注4：第三个输入是超大核CPU \t\e[${around}m*
\t*\t\e[${Font}m注5：5000代表500M频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*\t\e[${Font}m注7：取值范围为1.2g以内     \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_2=`echo $Options|awk '{print $3}'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_2 -ge $(($(cat $cpu7_Frequency_table|awk '{print $1}')/100)) -a $Options_2 -lt 12000 -a $Options_3 -ge $(($(cat $cpu6_Frequency_table|awk '{print $1}')/100)) -a $Options_3 -lt 12000 -a $Options_4 -ge $(($(cat $cpu0_Frequency_table|awk '{print $1}')/100)) -a $Options_4 -lt 12000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Small_core_Power_saving
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/big_core_Power_saving
                echo $(($Options_2*100)) > $tc_path/parameter/PTC/super_core_Power_saving
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Off-screen_mode_menu
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
elif [ -e $cpu7_max_freq_file_control ]; then
    Small_core_Power_saving=`cat $tc_path/parameter/PTC/Small_core_Power_saving`
    super_core_Power_saving=`cat $tc_path/parameter/PTC/super_core_Power_saving`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整熄屏模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Small_core_Power_saving     \t\e[${around}m*
\t*\t\e[${Font}m当前超大核频率：$super_core_Power_saving    \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：5000 9000  \t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率除以100的结果即可\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注4：第三个输入是超大核CPU \t\e[${around}m*
\t*\t\e[${Font}m注5：5000代表500M频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*\t\e[${Font}m注7：取值范围为1.2g以内     \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_2 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge $(($(cat $cpu7_Frequency_table|awk '{print $1}')/100)) -a $Options_3 -lt 12000 -a $Options_4 -ge $(($(cat $cpu0_Frequency_table|awk '{print $1}')/100)) -a $Options_4 -lt 12000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Small_core_Power_saving
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/super_core_Power_saving
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Off-screen_mode_menu
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
elif [ -e $cpu5_max_freq_file_control ]; then
    Small_core_Power_saving=`cat $tc_path/parameter/PTC/Small_core_Power_saving`
    big_core_Power_saving=`cat $tc_path/parameter/PTC/big_core_Power_saving`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整熄屏模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Small_core_Power_saving     \t\e[${around}m*
\t*\t\e[${Font}m当前大核频率：$big_core_Power_saving      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：5000 9000  \t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率除以100的结果即可\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注5：5000代表500M频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*\t\e[${Font}m注7：取值范围为1.2g以内     \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入：$(($(cat $cpu2_Frequency_table|awk '{print $1}')/100))"
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge $(($(cat $cpu5_Frequency_table|awk '{print $1}')/100)) -a $Options_3 -lt 12000 -a $Options_4 -ge $(($(cat $cpu0_Frequency_table|awk '{print $1}')/100)) -a $Options_4 -lt 12000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Small_core_Power_saving
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/big_core_Power_saving
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Off-screen_mode_menu
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
elif [ -e $cpu3_max_freq_file_control ]; then
    Small_core_Power_saving=`cat $tc_path/parameter/PTC/Small_core_Power_saving`
    big_core_Power_saving=`cat $tc_path/parameter/PTC/big_core_Power_saving`
    echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整熄屏模式下的CPU最高频率\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前小核频率：$Small_core_Power_saving     \t\e[${around}m*
\t*\t\e[${Font}m当前大核频率：$big_core_Power_saving      \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m按格式输入如：5000 9000  \t\e[${around}m*
\t*\t\e[${Font}m注1：输入频率除以100的结果即可\t\e[${around}m*
\t*\t\e[${Font}m注2：第一个输入是小核CPU     \t\e[${around}m*
\t*\t\e[${Font}m注3：第二个输入是大核CPU   \t\e[${around}m*
\t*\t\e[${Font}m注5：5000代表500M频率      \t\e[${around}m*
\t*\t\e[${Font}m注6：禁止小数                \t\e[${around}m*
\t*\t\e[${Font}m注7：取值范围为1.2g以内     \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
    echo -ne "\t\e[${Option}m请按格式输入："
    read Options
    Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
    Options_3=`echo $Options|awk '{print $2}'|sed 's/ //g'`
    Options_4=`echo $Options|awk '{print $1}'|sed 's/ //g'`
    if [ ! -z $Options_3 ];then
        if [ -z $Options_1 ];then
            if [ $Options_3 -ge $(($(cat $cpu2_Frequency_table|awk '{print $1}')/100)) -a $Options_3 -lt 12000 -a $Options_4 -ge $(($(cat $cpu0_Frequency_table|awk '{print $1}')/100)) -a $Options_4 -lt 12000 ];then
                echo ok
                echo $(($Options_4*100)) > $tc_path/parameter/PTC/Small_core_Power_saving
                echo $(($Options_3*100)) > $tc_path/parameter/PTC/big_core_Power_saving
                Z_Countdown
                echo "设置成功"
                sleep 1
                CO_PTC
            fi
        fi
    fi
    case $Options in
    m)sh $path/A_menu.sh
    ;;
    r)Off-screen_mode_menu
    ;;
    q)exit
    ;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    CPU_equalization_frequency
    ;;
    esac
fi
}
Screen_off_delay(){
clear
number=`cat $tc_path/parameter/PTC/number`
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m熄屏执行延迟             \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m执行间隔：$number秒 \t\t\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：10       \t\e[${around}m*
\t*\t\e[${Font}m注1：单位：秒             \t\e[${around}m*
\t*\t\e[${Font}m注2：10代表执行延迟执行10秒\t\e[${around}m*
\t*\t\e[${Font}m注3：禁止设置小数          \t\e[${around}m*
\t*\t\e[${Font}m注4：取值范围10-600          \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mm.返回主菜单                 \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请按格式输入："
read Options
Options_1=`echo $Options|sed 's/[0-9]//g'|sed 's/ //g'`
if [ ! -z $Options ];then
    if [ -z $Options_1 ];then
        Options_1_1=`echo "$Options 10"|awk '{print $1/$2}'|cut -d. -f1`
        Options_60_1=`echo "$Options 600"|awk '{print $1/$2}'|cut -d. -f1`
        if [ $Options_1_1 -ge 1 -a $Options_60_1 -lt 1 ];then
            echo ok
            echo $Options > $tc_path/parameter/PTC/number
            Z_Countdown
            echo "设置完成"
            sleep 1
            CO_PTC
        fi
    fi
fi
case $Options in
m)sh $path/A_menu.sh
;;
r)CO_PTC
;;
q)exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
Screen_off_delay
;;
esac
}
#提示
Z_prompt(){
clear
echo "正在开发中，请耐心等待"
sleep 1
}
#倒计时
Z_Countdown(){
sleep 1
clear
for i in $(seq 3 -1 1)
do
clear
    sleep 1
    echo $i
done
sleep 1
clear
}
#执行菜单
CO_PTC