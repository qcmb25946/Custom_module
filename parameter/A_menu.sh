#!/system/bin/sh

#一级菜单

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
#一级菜单
A_menu_A(){
clear
echo -e "\t\e[${around}m*****************************************
\t*                                       *
\t*\t\e[${Font}m欢迎使用全机型自定义温控2.0\t\e[${around}m*
\e[${around}m\t*\t\e[${Font}m$Dynamic_time\t\e[${around}m*
\e[${around}m\t*                                       *
\t*\t\e[${Font}m1.温控开关              \t\e[${around}m*
\t*\t\e[${Font}m2.模式切换              \t\e[${around}m*
\t*\t\e[${Font}m3.参数调整              \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}m4.查看温控参数          \t\e[${around}m*
\t*                                       *
\t*\t\e[${Font}mh.帮助(开发中)           \t\e[${around}m*
\t*\t\e[${Font}mq.退出                   \t\e[${around}m*
\t*                                       *
\t*****************************************"
echo -ne "\e[${Option}m\t请选择："
read Options
case $Options in
1)sh $path/B_menu.sh B_menu_thermal_control
;;
2)sh $path/B_menu.sh B_menu_Mode_switch
;;
3)sh $path/B_menu.sh B_menu_Parameter_adjustment
;;
4)sh $path/parameter.sh
;;
h) Z_prompt
sh $path/A_menu.sh;;
q) exit
;;
*)echo -e "\t\e[31m输入有误重新输入"
sleep 1
sh $path/A_menu.sh
;;
esac
}



#帮助
B_menu_help(){
Z_prompt
A_menu_A
}
#提示
Z_prompt(){
clear
echo "正在开发中，请耐心等待"
sleep 1
}

#开始
A_menu_A