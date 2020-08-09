#!/system/bin/sh

#充电温控参数设置

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#周围
around=`cat $tc_path/Set_up/colour/Font/around`
#字体
Font=`cat $tc_path/Set_up/colour/Font/Font`
#选项
Option=`cat $tc_path/Set_up/colour/Font/Options`
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
#充电温控菜单
CO_CTC(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整充电温控            \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.调整充电温度                \t\e[${around}m*
\t*\t\e[${Font}m2.调整电流大小                \t\e[${around}m*
\t*\t\e[${Font}m3.电流调节大小                \t\e[${around}m*
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
1)Charging_temperature_setting
;;
2)Charging_current
;;
3)Current_increase_or_decrease
;;
h)Z_prompt
CO_CTC
;;
m)sh $path/A_menu.sh;;
r)sh $path/B_menu.sh B_menu_Parameter_adjustment;;
q)exit;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
sh $path/CO_CTC.sh;;
esac
}
#充电温度
Charging_temperature_setting(){
Increase=`echo "$(cat $tc_path/parameter/CTC/Increase_current_threshold) 10" | awk '{print $1/$2}'`
Lower=`echo "$(cat $tc_path/parameter/CTC/Lower_current_threshold) 10" | awk '{print $1/$2}'`
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整充电温度                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前设置温度阈值            \t\e[${around}m*
\t*\t\e[${Font}m充电保护温度：$Increase度       \t\e[${around}m*
\t*\t\e[${Font}m充电满血温度：$Lower度        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：43.5 41.5\t\e[${around}m*
\t*\t\e[${Font}m注1：参考传感器：电池    \t\e[${around}m*
\t*\t\e[${Font}m注2：第一个是充电保护温度\t\e[${around}m*
\t*\t\e[${Font}m注3：第二个是充电满血温度\t\e[${around}m*
\t*\t\e[${Font}m注4：第一个数大于第二个数\t\e[${around}m*
\t*\t\e[${Font}m注5：不要设置过多小数一般一位\t\e[${around}m*
\t*\t\e[${Font}m小数即可                \t\e[${around}m*
\t*\t\e[${Font}m注6：不要过分设置过高的充电温度\t\e[${around}m*
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
    r)CO_CTC;;
    q)exit;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Charging_temperature_setting;;
    esac
else
    judgment_3=`echo $Options|sed 's/[0-9.]//g'|sed "s/ //g"`
    if [ -z $judgment_1 ];then
        if [ -z $judgment_2 ];then
            if [ -z $judgment_3 ];then
                awk_Options_10_2=`echo "$Options_2 10"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_10_1=`echo "$Options_1 10"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_50_1=`echo "$Options_1 50"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options_50_2=`echo "$Options_2 50"|awk '{print $1/$2}'|cut -d. -f1`
                awk_Options=`echo "$Options_1 $Options_2"|awk '{print $1/$2}'|cut -d. -f1`
                if [ $awk_Options_10_1 -lt 1 -o $awk_Options_10_2 -lt 1 -o $awk_Options_50_1 -ge 1 -o $awk_Options_50_2 -ge 1 -o $awk_Options -lt 1 ];then
                    echo -e "\t\e[31m输入有误，重新输入(除了数字和小数点其他不能输入，不能设置过高的温度阈值。)"
                    sleep 1
                    Charging_temperature_setting
                else
                    echo "OK"
                    Increase_current_threshold=`echo "$Options_1 10"|awk '{print $1*$2}'`
                    Lower_current_threshold=`echo "$Options_2 10"|awk '{print $1*$2}'`
                    echo $Increase_current_threshold > $tc_path/parameter/CTC/Increase_current_threshold
                    echo $Lower_current_threshold > $tc_path/parameter/CTC/Lower_current_threshold
                    Z_Countdown
                    echo "设置成功"
                    sleep 1
                    CO_CTC
                fi
            fi
        fi
    fi
fi
echo -e "\t\e[31m输入有误，重新输入(除了数字和小数点其他不能输入)"
sleep 1
Charging_temperature_setting
}
#充电电流
Charging_current(){
Minimum_current=`cat $tc_path/parameter/CTC/Minimum_current`
Maximum_current=`cat $tc_path/parameter/CTC/Maximum_current`
Decimal=0.9
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m调整充电速度档位           \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前最高充电档位：$Maximum_current毫安\t\e[${around}m*
\t*\t\e[${Font}m当前最低充电档位：$Minimum_current毫安\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：4000 1500\t\e[${around}m*
\t*\t\e[${Font}m注1：单位：毫安           \t\e[${around}m*
\t*\t\e[${Font}m注2：4000代表4000毫安   \t\e[${around}m*
\t*\t\e[${Font}m注3：第一个是最高充电档位\t\e[${around}m*
\t*\t\e[${Font}m注4：第二个是最低充电档位\t\e[${around}m*
\t*\t\e[${Font}m注5：第一个数高于第二个数1.2倍\t\e[${around}m*
\t*\t\e[${Font}m注6：禁止设置小数          \t\e[${around}m*
\t*\t\e[${Font}m注7：不要过分设置过高的充电电流\t\e[${around}m*
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
if [ -z $Options_2 ];then
    case $Options in
    m)sh $path/A_menu.sh;;
    r)CO_CTC;;
    q)exit;;
    *)echo -e "\t\e[31m输入有误重新输入"
    sleep 1
    Charging_current;;
    esac
else
    judgment_3=`echo $Options|sed 's/[0-9]//g'|sed "s/ //g"`
    echo $judgment_3
    if [ -z $judgment_3 ];then
        awk_Options_1000_2=`echo "$Options_2 1000"|awk '{print $1/$2}'|cut -d. -f1`
        awk_Options_1000_1=`echo "$Options_1 1000"|awk '{print $1/$2}'|cut -d. -f1`
        awk_Options_10000_1=`echo "$Options_1 10000"|awk '{print $1/$2}'|cut -d. -f1`
        awk_Options_10000_2=`echo "$Options_2 10000"|awk '{print $1/$2}'|cut -d. -f1`
        awk_Options=`echo "$Options_1 $Options_2 $Decimal"|awk '{print $1/$2*$3}'|cut -d. -f1`
        echo "$awk_Options_1000_2 $awk_Options_1000_1 $awk_Options_10000_1 $awk_Options_10000_2 $awk_Options"
        if [ $awk_Options_1000_1 -lt 1 -o $awk_Options_1000_2 -lt 1 -o $awk_Options_10000_1 -ge 1 -o $awk_Options_10000_2 -ge 1 -o $awk_Options -lt 1 ];then
            echo -e "\t\e[31m输入有误，重新输入(除了数字其他不能输入，不能设置过高的充电电流。)"
            sleep 1
            Charging_temperature_setting
        else
            echo "OK"
            Z_Countdown
            echo $Options_1 > $tc_path/parameter/CTC/Maximum_current
            echo $Options_2 > $tc_path/parameter/CTC/Minimum_current
            clear
            echo "设置成功"
            sleep 1
            CO_CTC
        fi
    fi
fi
                    
echo -e "\t\e[31m输入有误，重新输入(除了数字和小数点其他不能输入)"
sleep 1
}
#电流增减大小
Current_increase_or_decrease(){
Reduce_current_size=`cat $tc_path/parameter/CTC/Reduce_current_size`
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m电流调节大小              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前调节大小：$Reduce_current_size毫安 \t\t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m请按格式输入比如：100     \t\e[${around}m*
\t*\t\e[${Font}m注1：单位：毫安           \t\e[${around}m*
\t*\t\e[${Font}m注2：100代表每次增减100毫安/1秒\t\e[${around}m*
\t*\t\e[${Font}m注3：禁止设置小数          \t\e[${around}m*
\t*\t\e[${Font}m注4：设置区间100-1000毫安\t\e[${around}m*
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
        Options_1_1=`echo "$Options 100"|awk '{print $1/$2}'|cut -d. -f1`
        Options_60_1=`echo "$Options 1000"|awk '{print $1/$2}'|cut -d. -f1`
        if [ $Options_1_1 -ge 1 -a $Options_60_1 -lt 1 ];then
            echo ok
            echo $Options > $tc_path/parameter/CTC/Reduce_current_size
            Z_Countdown
            echo "设置完成"
            sleep 1
            CO_CTC
        fi
    fi
fi
case $Options in
m)sh $path/A_menu.sh;;
r)CO_CTC;;
q)exit;;
*)echo -e "\t\e[31m输入有误，重新输入(除了数字其他不能输入)"
sleep 1
Current_increase_or_decrease;;
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

#调用菜单
CO_CTC