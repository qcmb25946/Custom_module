#一级菜单

#路径
path=/data/adb/modules/Custom_temperature_control/parameter
tc_path=/storage/emulated/TC
#字体
Font=`cat $tc_path/Set_up/Font/Font`
#检测是否运行
switch_mode=`cat $tc_path/parameter/switch`
#时间
Dynamic_time=`date +"%Y-%m-%d %H:%M:%S"`
#一级菜单
A_menu(){
clear
if [ $switch_mode = 'K' ];then
    echo -e "
\t\t\e[${Font}m    欢迎使用 自定义温控
\t\t    $Dynamic_time

\t\t       1）温控开关
\t\t       2）模式切换
\t\t       3）参数调整

\t\t       4）查看参数

\t\t       7）颜色调整
\t\t       0）退出
" 
    echo -ne "\t\t    请选择："
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
    7)sh $path/B_menu.sh B_menu_Color_adjustment
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m    输入有误重新输入"
    sleep 0.1
    sh $path/A_menu.sh
    ;;
    esac
else
    echo -e "
\t\t\e[${Font}m    欢迎使用 自定义温控
\t\t    $Dynamic_time

\t\t       1）温控开关

\t\t       7）颜色调整
\t\t       0）退出
"
    echo -ne "\t\t    请选择："
    read Options
    case $Options in
    1)sh $path/B_menu.sh B_menu_thermal_control
    ;;
    7)sh $path/B_menu.sh B_menu_Color_adjustment
    ;;
    0)exit
    ;;
    *)echo -e "\t\t\e[31m    输入有误重新输入"
    sleep 0.1
    sh $path/A_menu.sh
    ;;
    esac
fi
}


#开始
A_menu