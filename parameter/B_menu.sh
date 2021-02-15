#二级菜单

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#字体
Font=`cat $tc_path/Set_up/Font/Font`
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
Dynamic_time=`date +"%Y-%m-%d  %H:%M:%S"`
#温控开关
B_menu_thermal_control(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         温控开关

\t\t       当前状态：$switch

\t\t          1）开
\t\t          2）关

\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)echo "K" > $tc_path/parameter/switch
echo "成功启动自定义温控"
sleep 0.1
sh $path/A_menu.sh
;;
2)echo "G" > $tc_path/parameter/switch
echo "成功关闭自定义温控"
sleep 0.1
sh $path/A_menu.sh
;;
9)sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/B_menu.sh B_menu_thermal_control;;
esac
}
#模式切换
B_menu_Mode_switch(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         模式切换

\t\t    当前模式：$mode

\t\t      1）默认模式
\t\t      2）重度模式

\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)echo "A" > $tc_path/parameter/PTC/Current_mode
echo "成功切换默认模式"
sleep 0.1
sh $path/A_menu.sh
;;
2)echo "B" > $tc_path/parameter/PTC/Current_mode
sleep 0.1
echo "成功切换重度模式"
sleep 0.1
sh $path/A_menu.sh
;;
9) sh $path/A_menu.sh
;;
0) exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/B_menu.sh B_menu_Mode_switch;;
esac
}
#参数调整
B_menu_Parameter_adjustment(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         参数调整

\t\t      1）SOC 参数
\t\t      2）充电参数
\t\t      3）查看参数

\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/C_menu.sh C_menu_Processor_parameter_adjustment
;;
2)sh $path/C_menu.sh C_menu_Charging_parameter_adjustment
;;
3)sh $path/parameter.sh
;;
9) sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/B_menu.sh B_menu_Parameter_adjustment
;;
esac
}

#颜色调整
B_menu_Color_adjustment(){
clear
echo -e "
\t\t\e[${Font}m   欢迎 使用自定义 温控
\t\t   $Dynamic_time
\t\t         颜色调整

\t\t      1）字体颜色
\t\t      2）背景颜色(开发中)

\t\t      9）返回主菜单
\t\t      0）退出
"
echo -ne "\t\t   请选择："
read Options
case $Options in
1)sh $path/D_menu.sh D_menu_font_color
;;
9) sh $path/A_menu.sh
;;
0)exit
;;
*)echo -e "\t\t\e[31m   输入有误重新输入"
sleep 0.1
sh $path/B_menu.sh B_menu_Color_adjustment
;;
esac
}



#调用菜单
$1