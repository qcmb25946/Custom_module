#!/system/bin/sh


#获取均衡频率

#机型代号
Identify=`getprop ro.board.platform`
#cpu最大频率
soc_parameters="/cache/ZDY/surroundings/soc_parameters"
vertical_number="$(cat $soc_parameters|grep "vertical_number"|cut -d= -f2)"
cpu_max_freq="$(cat $soc_parameters|grep "vertical_core_max_freq_${vertical_number}"|cut -d= -f2)"
#骁龙888 骁龙865系 骁龙855系 天玑1000系 天玑820 天玑800
if [ "$Identify" = "lahaina" -o "$Identify" = "kona" -o "$Identify" = "msmnile" -o "$Identify" = "mt6889" -o "$Identify" = "mt6885" -o "$Identify" = "mt6875" -o "$Identify" = "mt6873" ];then
    Balance_goal_freq=$((1800*1000))
#骁龙845
elif [ "$Identify" = "sdm845" ];then
    Balance_goal_freq=$((2100*1000))
#天玑800U
elif [ "$Identify" = "mt6853" -a $cpu_max_freq -gt $((2100*1000)) ];then
    Balance_goal_freq=$((2000*1000))
#骁龙76x
elif [ "$Identify" = "lito" -a $cpu_max_freq -gt $((2300*1000)) ];then
    Balance_goal_freq=$((2000*1000))
#骁龙750G
elif [ "$Identify" = "lito" -a $cpu_max_freq -lt $((2300*1000)) ];then
    Balance_goal_freq=$((1800*1000))
fi