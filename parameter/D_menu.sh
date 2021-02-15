#四级菜单

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#字体
Font=`cat $tc_path/Set_up/Font/Font`
if [ $Font -eq 31 ];then
    Font_value=红色
elif [ $Font -eq 32 ];then
    Font_value=绿色
elif [ $Font -eq 33 ];then
    Font_value=黄色
elif [ $Font -eq 34 ];then
    Font_value=蓝色
elif [ $Font -eq 35 ];then
    Font_value=紫色
elif [ $Font -eq 36 ];then
    Font_value=青色
elif [ $Font -eq 37 ];then
    Font_value=白色
fi
#检测是否运行
switch_mode=`cat $tc_path/parameter/switch`
#时间
Dynamic_time=`date +"%Y-%m-%d  %H:%M:%S"`
#gpu频率表
gpu_max_freq_file_fixed=$(cat /sys/class/kgsl/kgsl-3d0/gpu_available_frequencies)
#保护
protection=`cat ${tc_path}/parameter/CTC/protection`
#soc满血降频温度
Open_threshold=`cat /storage/emulated/TC/parameter/PTC/Open_threshold`
Limit_threshold=`cat /storage/emulated/TC/parameter/PTC/Limit_threshold`
#小核心降频档位
small_cpu_Frequency_reduction=`cat ${tc_path}/parameter/PTC/small_cpu_Frequency_reduction`
#大核心降频档位
big_cpu_Frequency_reduction=`cat ${tc_path}/parameter/PTC/big_cpu_Frequency_reduction`
#超大核心降频档位
super_cpu_Frequency_reduction=`cat ${tc_path}/parameter/PTC/super_cpu_Frequency_reduction`
#gpu降频档位
gpu_Frequency_reduction=`cat ${tc_path}/parameter/PTC/gpu_Frequency_reduction`
#均衡模式频率
Daily_frequency_of_small_core=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`
Big_core_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`
super_core_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`
Video_card_daily_frequency=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`
#熄屏模式频率
Small_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`
big_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/big_core_Power_saving`
super_core_Power_saving=`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`
gpu_Power_saving=`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`
#cpu频率纵集
Vertical_collection=`cat /storage/emulated/TC/Result/CPUS/Vertical_collection|cut -c -1`
#充电减小满血温度阈值
Increase_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
#每次减少电流阈值
Reduce_current_size=`cat /storage/emulated/TC/parameter/CTC/Reduce_current_size`
#充电最大最小电流
Minimum_current=`cat /storage/emulated/TC/parameter/CTC/Minimum_current`
Maximum_current=`cat /storage/emulated/TC/parameter/CTC/Maximum_current`
#soc满血温度
D_menu_Full_blood_temperature(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 满血温度

\t\t   当前满血温度：`echo "$Open_threshold 10"|awk '{print $1/$2}'`℃

\t\t   提示：
\t\t   1.该阈值参考GPU温度
\t\t   2.低于阈值soc满血
\t\t   3.阈值高于50℃
\t\t   4.阈值低于降频温度
\t\t   5.阈值可以设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9.]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断是否大于1
            Options_judgment_2=`echo $Options|cut -c1|sed 's/[0-9]//g'`
            if [ -z $Options_judgment_2 ];then
                #判断数字是不是一位数
                Options_judgment_3=`echo $Options|wc -m`
                if [ $Options_judgment_3 -ge 3 ];then
                    #默认高于50度
                    Options_judgment_4=`echo $Options 50|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_4 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于50度的阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Full_blood_temperature
                    else
                        #低于降频温度
                        Options_judgment_5=`echo $Options $(echo "$Limit_threshold 10"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                        if [ $Options_judgment_5 -ge 1 ];then
                            echo -e "\t\t\e[31m   输入有误，请输入小于处理器降频温度阈值"
                            sleep 0.1
                            sh $path/D_menu.sh D_menu_Full_blood_temperature
                        else
                            echo $Options 10|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Open_threshold
                            echo "\t\t\e[${Font}m   写入成功"
                            sleep 0.1
                            sh $path/C_menu.sh C_menu_Processor_temperature
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_temperature
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Full_blood_temperature
;;
esac
}
#soc降频温度
D_menu_Frequency_reduction_temperature(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       SOC 降频温度

\t\t   当前满血温度：`echo "$Limit_threshold 10"|awk '{print $1/$2}'`℃

\t\t   提示：
\t\t   1.该阈值参考GPU温度
\t\t   2.高于阈值soc降频
\t\t   3.阈值高于满血温度
\t\t   4.阈值低于100℃
\t\t   5.阈值可以设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9.]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断是否大于1
            Options_judgment_2=`echo $Options|cut -c1|sed 's/[0-9]//g'`
            if [ -z $Options_judgment_2 ];then
                #判断数字是不是一位数
                Options_judgment_3=`echo $Options|wc -m`
                if [ $Options_judgment_3 -ge 3 ];then
                    #默认低于100度
                    Options_judgment_4=`echo $Options 100|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_4 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于100度的阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Frequency_reduction_temperature
                    else
                        #高于满血温度
                        Options_judgment_5=`echo $Options $(echo "$Open_threshold 10"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                        if [ $Options_judgment_5 -lt 1 ];then
                            echo -e "\t\t\e[31m   输入有误，请输入大于处理器满血温度阈值"
                            sleep 0.1
                            sh $path/D_menu.sh D_menu_Frequency_reduction_temperature
                        else
                            echo $Options 10|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Limit_threshold
                            echo "\t\t\e[${Font}m   写入成功"
                            sleep 0.1
                            sh $path/C_menu.sh C_menu_Processor_temperature
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_temperature
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Frequency_reduction_temperature
;;
esac
}
#soc小核心降频档位
D_menu_Small_core_downshift(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t      小核心降频档位

\t\t   当前降频档位：$small_cpu_Frequency_reduction

\t\t   提示：
\t\t   1.根据频率表升降频
\t\t   2.降频档位最低为1
\t\t   3.降频档位最高为4
\t\t   4.禁止设置小数
\t\t   5.阈值范围1-4的整数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
case $Options in
[1,2,3,4])echo $Options > ${tc_path}/parameter/PTC/small_cpu_Frequency_reduction
echo "\t\t\e[${Font}m   写入成功"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_downshift
;;
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Small_core_downshift
;;
esac
}
#soc中核心降频档位
D_menu_Mid-core_downshift(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t      中核心降频档位

\t\t   当前降频档位：$big_cpu_Frequency_reduction

\t\t   提示：
\t\t   1.根据频率表升降频
\t\t   2.降频档位最低为1
\t\t   3.降频档位最高为4
\t\t   4.禁止设置小数
\t\t   5.阈值范围1-4的整数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
case $Options in
[1,2,3,4])echo $Options > ${tc_path}/parameter/PTC/big_cpu_Frequency_reduction
echo "\t\t\e[${Font}m   写入成功"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_downshift
;;
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Mid-core_downshift
;;
esac
}
#soc大核心降频档位
D_menu_Big_core_downshift(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t      大核心降频档位

\t\t   当前降频档位：$super_cpu_Frequency_reduction

\t\t   提示：
\t\t   1.根据频率表升降频
\t\t   2.降频档位最低为1
\t\t   3.降频档位最高为4
\t\t   4.禁止设置小数
\t\t   5.阈值范围1-4的整数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
case $Options in
[1,2,3,4])echo $Options > ${tc_path}/parameter/PTC/super_cpu_Frequency_reduction
echo "\t\t\e[${Font}m   写入成功"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_downshift
;;
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Big_core_downshift
;;
esac
}
#socGPU降频档位
D_menu_GPU_downshift(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t      G P U 降频档位

\t\t   当前降频档位：$gpu_Frequency_reduction

\t\t   提示：
\t\t   1.根据频率表升降频
\t\t   2.降频档位最低为1
\t\t   3.降频档位最高为4
\t\t   4.禁止设置小数
\t\t   5.阈值范围1-4的整数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
case $Options in
[1,2,3,4])echo $Options > ${tc_path}/parameter/PTC/gpu_Frequency_reduction
echo "\t\t\e[${Font}m   写入成功"
sleep 0.1
sh $path/C_menu.sh C_menu_Processor_downshift
;;
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_GPU_downshift
;;
esac
}
#均衡小核心频率
D_menu_Balance_small_core_frequency(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     均衡小核最高频率

\t\t   当前最高频率:$Daily_frequency_of_small_core

\t\t   提示：
\t\t   1.该阈值是均衡模式下
\t\t   小核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是小核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入2000000
\t\t   频率，就输入20000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -eq 6 ];then
                #默认高于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -lt 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入大于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Balance_small_core_frequency
                 else
                    #低于小核心最高频率
                    cpu_small_max=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $1}')/cpufreq/cpuinfo_max_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_small_max 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于小核心最高频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Balance_small_core_frequency
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Balanced_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Balance_small_core_frequency
;;
esac
}
#均衡中核心频率
D_menu_Core_frequency_in_equalization(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     均衡中核最高频率

\t\t   当前最高频率:$Big_core_daily_frequency

\t\t   提示：
\t\t   1.该阈值是均衡模式下
\t\t   中核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入2000000
\t\t   频率，就输入20000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -eq 6 ];then
                #默认高于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -lt 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入大于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Core_frequency_in_equalization
                 else
                    #低于中核心最高频率
                    cpu_max=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $2}')/cpufreq/cpuinfo_max_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_max 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于中核心最高频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Core_frequency_in_equalization
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Balanced_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Core_frequency_in_equalization
;;
esac
}
#均衡大核心频率
D_menu_Balance_large_core_frequency(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     均衡大核最高频率

\t\t   当前最高频率:$super_core_daily_frequency

\t\t   提示：
\t\t   1.该阈值是均衡模式下
\t\t   中核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入2000000
\t\t   频率，就输入20000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -eq 6 ];then
                #默认高于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -lt 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入大于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Balance_large_core_frequency
                 else
                    #低于大核心最高频率
                    cpu_max=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $NF}')/cpufreq/cpuinfo_max_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_max 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于大核心最高频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Balance_large_core_frequency
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/super_core_daily_frequency
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Balanced_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Balance_large_core_frequency
;;
esac
}
#均衡GPU频率
D_menu_Balance_GPU_frequency(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     均衡GPU 最高频率

\t\t   当前最高频率:$Video_card_daily_frequency

\t\t   提示：
\t\t   1.该阈值是均衡模式下
\t\t   中核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   10000，如想输入
\t\t   200000000频率，
\t\t   就输入20000即可
\t\t   5.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -eq 6 ];then
                #高于GPU最低频率
                judgment_1=$(echo $gpu_max_freq_file_fixed|awk '{print $NF}')
                Options_judgment_4=`echo "$Options $(echo "$judgment_1 10000"|awk '{print $1/$2}')"|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -lt 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入大于GPU最低频率阈值"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Balance_GPU_frequency
                 else
                    #低于GPU最高频率
                    judgment_2=$(echo $gpu_max_freq_file_fixed|awk '{print $1}')
                    Options_judgment_5=`echo "$Options $(echo "$judgment_2 10000"|awk '{print $1/$2}')"|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于GPU最高频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Balance_GPU_frequency
                    else
                        echo $Options 10000|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Balanced_mode
                    fi
                fi
            fi
        fi
    fi
fi

case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Balance_GPU_frequency
;;
esac
}
#小核心熄屏频率
D_menu_Screen_off_small_core_frequency(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     熄屏小核最高频率

\t\t   当前最高频率:$Small_core_Power_saving

\t\t   提示：
\t\t   1.该阈值是熄屏模式下
\t\t   小核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入1000000
\t\t   频率，就输入10000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 5 ];then
                #默认低于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -ge 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Screen_off_small_core_frequency
                 else
                    #高于小核心最低频率
                    cpu_min=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $1}')/cpufreq/cpuinfo_min_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_min 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于小核心最低频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Screen_off_small_core_frequency
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/Small_core_Power_saving
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Off_screen_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Screen_off_small_core_frequency
;;
esac
}
#中核心熄屏频率
D_menu_Core_frequency_in_off_screen(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     熄屏中核最高频率

\t\t   当前最高频率:$big_core_Power_saving

\t\t   提示：
\t\t   1.该阈值是熄屏模式下
\t\t   中核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入1000000
\t\t   频率，就输入10000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 5 ];then
                #默认低于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -ge 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Core_frequency_in_off_screen
                 else
                    #高于中核心最低频率
                    cpu_min=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $2}')/cpufreq/cpuinfo_min_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_min 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于中核心最低频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Core_frequency_in_off_screen
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/big_core_Power_saving
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Off_screen_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Core_frequency_in_off_screen
;;
esac
}
#大核心熄屏频率
D_menu_Screen_off_big_core_frequency(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t     熄屏大核最高频率

\t\t   当前最高频率:$super_core_Power_saving

\t\t   提示：
\t\t   1.该阈值是熄屏模式下
\t\t   中核心最高频率
\t\t   2.阈值最低1G频率
\t\t   3.阈值最高是中核心
\t\t   最高频率
\t\t   4.输入阈值需要除以
\t\t   100，如想输入1000000
\t\t   频率，就输入10000
\t\t   即可
\t\t   5.1Ghz=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 5 ];then
                #默认低于1Ghz
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -ge 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于1Ghz度的阈值，1Ghz=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Screen_off_big_core_frequency
                 else
                    #高于大核心最低频率
                    cpu_min=`cat /sys/devices/system/cpu/cpu$(echo $Vertical_collection|awk '{print $NF}')/cpufreq/cpuinfo_min_freq`
                    Options_judgment_5=`echo $Options $(echo "$cpu_min 100"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于大核心最低频率阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Screen_off_big_core_frequency
                    else
                        echo $Options 100|awk '{print $1*$2}' > /storage/emulated/TC/parameter/PTC/super_core_Power_saving
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Off_screen_mode
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_downshift
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Screen_off_big_core_frequency
;;
esac
}
#充电
#充电增加温度
D_menu_Fast_charge_to_increase_temperature(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       提升快充的温度

\t\t   当前满血温度：`echo "$Lower_current_threshold 10"|awk '{print $1/$2}'`℃

\t\t   提示：
\t\t   1.该阈值参考电池温度
\t\t   2.高于阈值soc降频
\t\t   3.阈值高于增加充电
\t\t   速度的温度
\t\t   4.阈值低于保护温度
\t\t   5.阈值可以设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9.]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断是否大于1
            Options_judgment_2=`echo $Options|cut -c1|sed 's/[0-9]//g'`
            if [ -z $Options_judgment_2 ];then
                #判断数字是不是一位数
                Options_judgment_3=`echo $Options|wc -m`
                if [ $Options_judgment_3 -ge 3 ];then
                    #默认高于50度
                    Options_judgment_4=`echo $Options 20|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_4 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于20度的阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Fast_charge_to_increase_temperature
                    else
                        #低于减小
                        Options_judgment_5=`echo $Options $(echo "$Increase_current_threshold 10"|awk '{print $1/$2}')|awk '{print $1/$2}'|cut -d. -f1`
                        if [ $Options_judgment_5 -ge 1 ];then
                            echo -e "\t\t\e[31m   输入有误，请输入小于降低充电速度的温度阈值。"
                            sleep 0.1
                            sh $path/D_menu.sh D_menu_Fast_charge_to_increase_temperature
                        else
                            echo $Options 10|awk '{print $1*$2}' > /storage/emulated/TC/parameter/CTC/Lower_current_threshold
                            echo "\t\t\e[${Font}m   写入成功"
                            sleep 0.1
                            sh $path/C_menu.sh C_menu_Charging_temperature
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_temperature
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Fast_charge_to_increase_temperature
;;
esac
}
#充电降低温度
D_menu_Reduce_charging_speed(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       降低快充的温度

\t\t   当前满血温度：`echo "$Increase_current_threshold 10"|awk '{print $1/$2}'`℃

\t\t   提示：
\t\t   1.该阈值参考电池温度
\t\t   2.高于阈值soc降频
\t\t   3.阈值高于增加充电
\t\t   速度的温度
\t\t   4.阈值低于保护温度
\t\t   5.阈值可以设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9.]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断是否大于1
            Options_judgment_2=`echo $Options|cut -c1|sed 's/[0-9]//g'`
            if [ -z $Options_judgment_2 ];then
                #判断数字是不是一位数
                Options_judgment_3=`echo $Options|wc -m`
                if [ $Options_judgment_3 -ge 3 ];then
                    #默认低于保护温度
                    Options_judgment_4=`echo "$Options $(echo "$protection 10"|awk '{print $1/$2}')"|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_4 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入小于保护温度的阈值 默认保护温度:$(echo "$protection 10"|awk '{print $1/$2}')℃"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Reduce_charging_speed
                    else
                        #高于增加充电速度的温度
                        Options_judgment_5=`echo "$Options $(echo "$Lower_current_threshold 10"|awk '{print $1/$2}')"|awk '{print $1/$2}'|cut -d. -f1`
                        if [ $Options_judgment_5 -lt 1 ];then
                            echo -e "\t\t\e[31m   输入有误，请输入大于充电增加电流的温度阈值"
                            sleep 0.1
                            sh $path/D_menu.sh D_menu_Reduce_charging_speed
                        else
                            echo "$Options 10"|awk '{print $1*$2}' > /storage/emulated/TC/parameter/CTC/Increase_current_threshold
                            echo "\t\t\e[${Font}m   写入成功"
                            sleep 0.1
                            sh $path/C_menu.sh C_menu_Charging_temperature
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Processor_temperature
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Reduce_charging_speed
;;
esac
}
#充电最大电流
D_menu_Maximum_charging_current(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       最高充电速度

\t\t   当前最高电流:$Maximum_current毫安

\t\t   提示：
\t\t   1.该阈值是充电最高电流
\t\t   2.阈值高于最低电流
\t\t   3.阈值暂时设置低于10A
\t\t   4.输入阈值需要除以
\t\t   1000，如想输入6000000
\t\t   频率，就输入6000
\t\t   即可
\t\t   5.1A=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 5 ];then
                #默认低于10A
                Options_judgment_4=`echo $Options 10000|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -ge 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于10A电流，1A=1000000"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Maximum_charging_current
                 else
                    #高于最小电流
                    Options_judgment_5=`echo $Options $Minimum_current|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于最小电流阈值"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Maximum_charging_current
                    else
                        echo $Options > /storage/emulated/TC/parameter/CTC/Maximum_current
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Charging_speed
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Charging_speed
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Maximum_charging_current
;;
esac
}
#充电最小电流
D_menu_Minimum_charging_current(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       最低充电速度

\t\t   当前最低电流:$Minimum_current毫安

\t\t   提示：
\t\t   1.该阈值是充电最高电流
\t\t   2.阈值低于最高电流
\t\t   3.阈值暂时设置高于1A
\t\t   4.输入阈值需要除以
\t\t   1000，如想输入1000000
\t\t   频率，就输入1000
\t\t   即可
\t\t   5.1A=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 5 ];then
                #默认低于最高电流
                Options_judgment_4=`echo $Options $Maximum_current|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -ge 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于最高电流的阈值"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Minimum_charging_current
                 else
                    #高于最小电流
                    Options_judgment_5=`echo $Options 1000|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -lt 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于1A"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Minimum_charging_current
                    else
                        echo $Options > /storage/emulated/TC/parameter/CTC/Minimum_current
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Charging_speed
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Charging_speed
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Minimum_charging_current
;;
esac
}
#调整充电电流
D_menu_Adjust_the_charging_current(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t       调整充电电流

\t\t   当前最低电流:$Reduce_current_size毫安

\t\t   提示：
\t\t   1.该阈值是调整充电电流
\t\t   2.阈值低于1A
\t\t   3.阈值暂时设置高于0.1A
\t\t   4.输入阈值需要除以
\t\t   1000，如想输入1000000
\t\t   频率，就输入1000
\t\t   即可
\t\t   5.1A=1000000
\t\t   6.禁止设置小数

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请输入："
read Options
if [ ! -z $Options ];then
    #判断数字
    Options_judgment=`echo $Options|sed 's/[0-9]//g'`
    if [ -z $Options_judgment ];then
        #判断是不是只是一个数字
        Options_judgment_1=`echo $Options|awk '{print $2}'`
        if [ -z $Options_judgment_1 ];then
            #判断数字是不是一位数
            Options_judgment_3=`echo $Options|wc -m`
            if [ $Options_judgment_3 -ge 4 ];then
                #默认高于0.1A
                Options_judgment_4=`echo $Options 100|awk '{print $1/$2}'|cut -d. -f1`
                if [ $Options_judgment_4 -lt 1 ];then
                    echo -e "\t\t\e[31m   输入有误，请输入小于最高电流的阈值"
                    sleep 0.1
                    sh $path/D_menu.sh D_menu_Adjust_the_charging_current
                 else
                    #低于1A
                    Options_judgment_5=`echo $Options 1000|awk '{print $1/$2}'|cut -d. -f1`
                    if [ $Options_judgment_5 -ge 1 ];then
                        echo -e "\t\t\e[31m   输入有误，请输入大于1A"
                        sleep 0.1
                        sh $path/D_menu.sh D_menu_Adjust_the_charging_current
                    else
                        echo $Options > /storage/emulated/TC/parameter/CTC/Reduce_current_size
                        echo "\t\t\e[${Font}m   写入成功"
                        sleep 0.1
                        sh $path/C_menu.sh C_menu_Charging_speed
                    fi
                fi
            fi
        fi
    fi
fi
case $Options in
8)sh $path/C_menu.sh C_menu_Charging_speed
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_Adjust_the_charging_current
;;
esac
}
#字体颜色
D_menu_font_color(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         字体颜色

\t\t      当前颜色:$Font_value

\t\t        31）红色
\t\t        32）绿色
\t\t        33）黄色
\t\t        34）蓝色
\t\t        35）紫色
\t\t        36）青色
\t\t        37）白色

\t\t      8）返回上一级
\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
31|32|33|34|35|36|37)echo $Options > $tc_path/Set_up/Font/Font
echo "\t\t\e[${Font}m   写入成功"
sleep 0.1
sh $path/B_menu.sh B_menu_Color_adjustment
;;
8)sh $path/B_menu.sh B_menu_Color_adjustment
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/D_menu.sh D_menu_font_color
;;
esac
}

#调用菜单
$1