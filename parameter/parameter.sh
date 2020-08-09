#参数或日志路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC/
#周围
around=`cat $tc_path/Set_up/colour/Font/around`
#字体
Font=`cat $tc_path/Set_up/colour/Font/Font`
#选项
Option=`cat $tc_path/Set_up/colour/Font/Options`
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
#减小满血温度阈值
Open_threshold=`cat /storage/emulated/TC/parameter/PTC/Open_threshold`
Limit_threshold=`cat /storage/emulated/TC/parameter/PTC/Limit_threshold`
#小核心降频档位
small_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/small_cpu_Frequency_reduction`
#大核心降频档位
big_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/big_cpu_Frequency_reduction`
#超大核心降频档位
super_cpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/super_cpu_Frequency_reduction`
#gpu降频档位
gpu_Frequency_reduction=`cat ${tc_path}parameter/PTC/gpu_Frequency_reduction`
#充电减小满血温度阈值
Increase_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
#每次减少电流阈值
Reduce_current_size=/storage/emulated/TC/parameter/CTC/Reduce_current_size
#充电最大最小电流
Minimum_current=/storage/emulated/TC/parameter/CTC/Minimum_current
Maximum_current=/storage/emulated/TC/parameter/CTC/Maximum_current
#控制cpu最大频率路径
cpu0_max_freq_file_control="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
cpu1_max_freq_file_control="/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq"
cpu2_max_freq_file_control="/sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq"
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
cpu4_max_freq_file_control="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
cpu5_max_freq_file_control="/sys/devices/system/cpu/cpu5/cpufreq/scaling_max_freq"
cpu6_max_freq_file_control="/sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq"
cpu7_max_freq_file_control="/sys/devices/system/cpu/cpu7/cpufreq/scaling_max_freq"
#识别处理器
Identify=`getprop ro.board.platform`
#当前模式
Current_mode=`cat /storage/emulated/TC/parameter/PTC/Current_mode`
        if [ $Current_mode = A ]; then
            mode=默认模式
        elif [ $Current_mode = B ]; then
            mode=重度模式
        fi
        clear
        if [ $Current_mode = A ]; then
            if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m均衡模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`  \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`        \t\t\e[${around}m*
*\t\e[${Font}m超大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`   \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m熄屏模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`       \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/big_core_Power_saving`         \t\t\e[${around}m*
*\t\e[${Font}m超大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`      \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$big_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m超大核心降频档位=$super_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            elif [ -e $cpu7_max_freq_file_control ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m均衡模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`  \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`   \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m熄屏模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`       \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`       \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$super_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            elif [ -e $cpu3_max_freq_file_control ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m均衡模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`  \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`        \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m熄屏模式                       \t\t\e[${around}m*
*\t\e[${Font}m小核心最大频率=`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`       \t\t\e[${around}m*
*\t\e[${Font}m大核心最大频率=`cat /storage/emulated/TC/parameter/PTC/big_core_Power_saving`         \t\t\e[${around}m*
*\t\e[${Font}mGPU最大频率=`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`      \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$big_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            fi
        else
            if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$big_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m超大核心降频档位=$super_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            elif [ -e $cpu7_max_freq_file_control ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$super_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            elif [ -e $cpu3_max_freq_file_control ]; then
                echo "\e[${around}m*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\t\e[${around}m*
*\t\e[${Font}m`date +"%Y-%m-%d %H:%M:%S $Z"`\t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前处理器参数               \t\t\e[${around}m*
*\t\e[${Font}m当前设置模式：$mode        \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m处理器降频温度=`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m处理器满血温度=`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃        \t\t\e[${around}m*
*\t\e[${Font}m小核心降频档位=$small_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}m大核心降频档位=$big_cpu_Frequency_reduction           \t\t\e[${around}m*
*\t\e[${Font}mGPU降频档位=$gpu_Frequency_reduction                 \t\t\e[${around}m*
*\t\t\t\t\t\t*
*\t\e[${Font}m当前充电参数               \t\t\e[${around}m*
*\t\e[${Font}m降低充电速度温度=`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃      \t\t\e[${around}m*
*\t\e[${Font}m满血充电速度温度=`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃       \t\t\e[${around}m*
*\t\e[${Font}m最大充电电流档位=`cat $Maximum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m最小充电电流档位=`cat $Minimum_current`毫安     \t\t\e[${around}m*
*\t\e[${Font}m阶梯减少充电阈值=`cat $Reduce_current_size`毫安    \t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************
*\t\t\t\t\t\t*
*\t\e[${Font}mm.返回主菜单    \t\t\t\e[${around}m*
*\t\e[${Font}mr.返回设置参数  \t\t\t\e[${around}m*
*\t\e[${Font}mq.退出     \t\t\t\t\e[${around}m*
*\t\t\t\t\t\t*
*************************************************"
                echo -ne "\e[${Option}m请选择："
                read Options
                case $Options in
                m)sh $path/A_menu.sh;;
                r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                q)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 1
                sh $path/parameter.sh;;
                esac
            fi
        fi