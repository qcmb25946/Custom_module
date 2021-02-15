#参数日志

#参数或日志路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC/
#字体
Font=`cat $tc_path/Set_up/Font/Font`
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
#充电减小增加温度阈值
Increase_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Increase_current_threshold`
Lower_current_threshold=`cat /storage/emulated/TC/parameter/CTC/Lower_current_threshold`
#每次减少电流阈值
Reduce_current_size=/storage/emulated/TC/parameter/CTC/Reduce_current_size
#充电最大最小电流
Minimum_current=/storage/emulated/TC/parameter/CTC/Minimum_current
Maximum_current=/storage/emulated/TC/parameter/CTC/Maximum_current
#控制cpu最大频率路径
cpu3_max_freq_file_control="/sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq"
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
                echo "
\t\t\e[${Font}m欢迎 使用自定义 温控
\t\t`date +"%Y-%m-%d  %H:%M:%S"`
\t\t当前处理器参数
\t\t当前设置模式：$mode

\t\t均衡模式                       
\t\tcpu_small_max\t`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`
\t\tcpu_major_max\t`cat /storage/emulated/TC/parameter/PTC/Big_core_daily_frequency`
\t\tcpu_super_max\t`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`
\t\tgpu_max\t\t`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`

\t\t熄屏模式                       
\t\tcpu_small_max\t`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`
\t\tcpu_major_max\t`cat /storage/emulated/TC/parameter/PTC/big_core_Power_saving`
\t\tcpu_super_max\t`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`
\t\tgpu_max\t\t`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`

\t\tSOC温度参数
\t\tdrop\t\t`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃

\t\tSOC降频档位
\t\tcpu_small_gear\t$small_cpu_Frequency_reduction
\t\tcpu_major_gear\t$big_cpu_Frequency_reduction
\t\tcpu_super_gear\t$super_cpu_Frequency_reduction
\t\tgpu_gear\t$gpu_Frequency_reduction

\t\t充电温度参数
\t\tdrop\t\t`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃

\t\t充电电流参数
\t\tcurrent_max\t`cat $Maximum_current`ma
\t\tCurrent_min\t`cat $Minimum_current`ma
\t\tCurrent_adjust\t`cat $Reduce_current_size`ma

\t\t8）返回设置参数
\t\t9）返回主菜单
\t\t0）退出
"
                echo -ne "\t\t请选择："
                read Options
                case $Options in
                9)sh $path/A_menu.sh;;
                8)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                0)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 0.1
                sh $path/parameter.sh;;
                esac
            else
                echo "
\t\t\e[${Font}m欢迎 使用自定义 温控
\t\t`date +"%Y-%m-%d  %H:%M:%S"`
\t\t当前处理器参数
\t\t当前设置模式：$mode

\t\t均衡模式                       
\t\tcpu_small_max\t`cat /storage/emulated/TC/parameter/PTC/Daily_frequency_of_small_core`
\t\tcpu_major_max\t`cat /storage/emulated/TC/parameter/PTC/super_core_daily_frequency`
\t\tgpu_max\t\t`cat /storage/emulated/TC/parameter/PTC/Video_card_daily_frequency`

\t\t熄屏模式                       
\t\tcpu_small_max\t`cat /storage/emulated/TC/parameter/PTC/Small_core_Power_saving`
\t\tcpu_major_max\t`cat /storage/emulated/TC/parameter/PTC/super_core_Power_saving`
\t\tgpu_max\t\t`cat /storage/emulated/TC/parameter/PTC/gpu_Power_saving`

\t\tSOC温度参数
\t\tdrop\t\t`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃

\t\tSOC降频档位
\t\tcpu_small_gear\t$small_cpu_Frequency_reduction
\t\tcpu_major_gear\t$super_cpu_Frequency_reduction
\t\tgpu_gear\t$gpu_Frequency_reduction

\t\t充电温度参数
\t\tdrop\t\t`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃

\t\t充电电流参数
\t\tcurrent_max\t`cat $Maximum_current`ma
\t\tCurrent_min\t`cat $Minimum_current`ma
\t\tCurrent_adjust\t`cat $Reduce_current_size`ma

\t\t8）返回设置参数
\t\t9）返回主菜单
\t\t0）退出
"
                echo -ne "\t\t请选择："
                read Options
                case $Options in
                9)sh $path/A_menu.sh;;
                8)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                0)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 0.1
                sh $path/parameter.sh;;
                esac
            fi
        else
            if [ $Identify = lito -o $Identify = msmnile -o $Identify = kona ]; then
                echo "
\t\t\e[${Font}m欢迎 使用自定义 温控
\t\t`date +"%Y-%m-%d  %H:%M:%S"`
\t\t当前处理器参数
\t\t当前设置模式：$mode

\t\tSOC温度参数
\t\tdrop\t\t`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃

\t\tSOC降频档位
\t\tcpu_small_gear\t$small_cpu_Frequency_reduction
\t\tcpu_major_gear\t$big_cpu_Frequency_reduction
\t\tcpu_super_gear\t$super_cpu_Frequency_reduction
\t\tgpu_gear\t$gpu_Frequency_reduction

\t\t充电温度参数
\t\tdrop\t\t`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃

\t\t充电电流参数
\t\tcurrent_max\t`cat $Maximum_current`ma
\t\tCurrent_min\t`cat $Minimum_current`ma
\t\tCurrent_adjust\t`cat $Reduce_current_size`ma

\t\t8）返回设置参数
\t\t9）返回主菜单
\t\t0）退出
"
                echo -ne "\t\t请选择："
                read Options
                case $Options in
                9)sh $path/A_menu.sh;;
                8)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                0)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 0.1
                sh $path/parameter.sh;;
                esac
            else
                echo "
\t\t\e[${Font}m欢迎 使用自定义 温控
\t\t`date +"%Y-%m-%d  %H:%M:%S"`
\t\t当前处理器参数
\t\t当前设置模式：$mode

\t\tSOC温度参数
\t\tdrop\t\t`echo "$Limit_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Open_threshold 10"|awk '{print ($1/$2)}'`℃

\t\tSOC降频档位
\t\tcpu_small_gear\t$small_cpu_Frequency_reduction
\t\tcpu_major_gear\t$super_cpu_Frequency_reduction
\t\tgpu_gear\t$gpu_Frequency_reduction

\t\t充电温度参数
\t\tdrop\t\t`echo "$Increase_current_threshold 10"|awk '{print ($1/$2)}'`℃
\t\tfull\t\t`echo "$Lower_current_threshold 10"|awk '{print ($1/$2)}'`℃

\t\t充电电流参数
\t\tcurrent_max\t`cat $Maximum_current`ma
\t\tCurrent_min\t`cat $Minimum_current`ma
\t\tCurrent_adjust\t`cat $Reduce_current_size`ma

\t\t8）返回设置参数
\t\t9）返回主菜单
\t\t0）退出
"
                echo -ne "\t\t请选择："
                read Options
                case $Options in
                9)sh $path/A_menu.sh;;
                8)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
                0)exit;;
                *)echo -e "\t\e[31m输入有误重新输入"
                sleep 0.1
                sh $path/parameter.sh;;
                esac
            fi
        fi