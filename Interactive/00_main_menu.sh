#!/system/bin/sh


#主菜单

echo -e "\e[32m"
#菜单路径
Interaction_path="/data/adb/modules/Custom_module/Interactive/"

#第一屏
Introduction(){
#界面
. "$Interaction_path/09_interface.sh"
sleep 5
main_menu
}
#主菜单
main_menu(){
#文本编号
serial_number=0001
#输出菜单
. "$Interaction_path/10_Output_menu.sh"
echo -n "请选择："
read transfer
case $transfer in
    #soc参数
    1)
        sh "$Interaction_path/01_soc_parameter.sh" soc_menu
    
    ;;
    #充电参数
    2)
        sh "$Interaction_path/02_Charging_parameters.sh"
    ;;
    #快速寻找
    3)
        sh "$Interaction_path/03_Find_quickly.sh"
    ;;
    #游戏调整
    4)
        sh "$Interaction_path/04_Game_adjustment.sh"
    ;;
    #系统调整
    5)
        sh "$Interaction_path/05_System_adjustment.sh"
    ;;
    #电池估算
    6)
        sh "$Interaction_path/06_Estimate_battery.sh"
    ;;
    #双扬声器
    7)
        sh "$Interaction_path/07_Dual_speakers.sh"
    ;;
    #查看日志
    8)
        sh "$Interaction_path/08_View_log.sh"
    ;;
    #退出
    e)
        exit
    ;;
    #错误输入
    *)

        echo -e "\e[31m超范围输入重新输入"
        sleep 1
        main_menu
    
    ;;
esac
}

$1
Introduction