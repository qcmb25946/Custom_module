#!/system/bin/sh

#二级菜单

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
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
else
    mode=重度模式
fi
#检测是否运行
switch_mode=`cat $tc_path/parameter/switch`
if [ $switch_mode = K ]; then
    switch=开
else
    switch=关
fi
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
#温控开关
B_menu_thermal_control(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m温控开关                     \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前状态：$switch            \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.开                          \t\e[${around}m*
\t*\t\e[${Font}m2.关                           \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mh.帮助(开发中)                \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)
clear
echo "正在启动自定义温控"
echo "K" > $tc_path/parameter/switch
Z_Countdown
echo "成功启动自定义温控"
sleep 1
sh $path/A_menu.sh
;;
2)
clear
echo "正在关闭自定义温控"
echo "G" > $tc_path/parameter/switch
Z_Countdown
echo "成功关闭自定义温控"
sleep 1
sh $path/A_menu.sh
;;
h)
Z_prompt
sh $path/CO.sh B_menu_thermal_control
;;
r) sh $path/A_menu.sh
;;
q) exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
sh $path/B_menu.sh B_menu_thermal_control;;
esac
}
#模式切换
B_menu_Mode_switch(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m模式切换                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m当前模式：$mode        \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.默认模式                    \t\e[${around}m*
\t*\t\e[${Font}m2.重度模式                    \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mh.帮助(开发中)                \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)
clear
echo "正在切换为默认模式"
echo "A" > $tc_path/parameter/PTC/Current_mode
Z_Countdown
echo "成功切换默认模式"
sleep 1
sh $path/A_menu.sh
;;
2)
clear
echo "正在切换为重度模式"
echo "B" > $tc_path/parameter/PTC/Current_mode
sleep 1
Z_Countdown
echo "成功切换重度模式"
sleep 1
sh $path/A_menu.sh
;;
h)
Z_prompt
sh $path/B_menu.sh B_menu_Mode_switch
;;
r) sh $path/A_menu.sh
;;
q) exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
sh $path/B_menu.sh B_menu_Mode_switch;;
esac
}
#参数调整
B_menu_Parameter_adjustment(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\t*\t\e[${Font}m$Dynamic_time      \e[${around}m*
\t*\t\e[${Font}m参数调整                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m1.SOC 温控调整              \t\e[${around}m*
\t*\t\e[${Font}m2.充电温控调整                \t\e[${around}m*
\t*\t\e[${Font}m3.查看当前参数                \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mh.帮助(开发中)                \t\e[${around}m*
\t*\t\e[${Font}mr.返回                         \t\e[${around}m*
\t*\t\e[${Font}mq.退出                         \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\t\e[${Option}m请选择："
read Options
case $Options in
1)sh $path/CO_PTC.sh;;
2)sh $path/CO_CTC.sh;;
3)sh $path/parameter.sh;;
h)Z_prompt
sh $path/B_menu.sh B_menu_Parameter_adjustment;;
r) sh $path/A_menu.sh;;
q)exit;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
sh $path/B_menu.sh B_menu_Parameter_adjustment;;
esac
}
#查看当前参数
Z_parameter(){
clear
watch -d 1 'cat $tc_path/parameter/log.log'
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
$1