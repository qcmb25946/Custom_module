#!/system/bin/sh

#识别处理器

while true
do
sleep 10
cpu0_max_freq_file_fixed="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"
cpu1_max_freq_file_fixed="/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq"
cpu2_max_freq_file_fixed="/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_max_freq"
cpu3_max_freq_file_fixed="/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_max_freq"
cpu4_max_freq_file_fixed="/sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq"
cpu5_max_freq_file_fixed="/sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_max_freq"
cpu6_max_freq_file_fixed="/sys/devices/system/cpu/cpu6/cpufreq/cpuinfo_max_freq"
cpu7_max_freq_file_fixed="/sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"
#识别处理器
Identify=`getprop ro.board.platform`
#骁龙865系
if [ $Identify = 'kona' ];then
    if [ `cat $cpu7_max_freq_file_fixed` -gt 2900000 ];then
        result=骁龙865+
    elif [ `cat $cpu7_max_freq_file_fixed` -lt 2900000 ];then
        result=骁龙865
    fi
#骁龙855系
elif [ $Identify = 'msmnile' ];then
    if [ `cat $cpu7_max_freq_file_fixed` -gt 2900000 ];then
        result=骁龙855+
    elif [ `cat $cpu7_max_freq_file_fixed` -lt 2900000 ];then
        result=骁龙855
    fi
#骁龙845系
elif [ $Identify = 'sm845' ];then
    result=骁龙845
#骁龙835
elif [ $Identify = 'msm8998' ];then
    result=骁龙835
#骁龙82x
elif [ $Identify = 'msm8996' -a `cat $cpu3_max_freq_file_fixed` -lt 2200000 -a `cat $cpu3_max_freq_file_fixed` -gt 1900000 ];then
    result=骁龙820
elif [ $Identify = 'msm8996' -a `cat $cpu3_max_freq_file_fixed` -lt 1900000 ];then
    result=骁龙820节能版
elif [ $Identify = 'msm8996' -a `cat $cpu3_max_freq_file_fixed` -gt 2200000 ];then
    result=骁龙821
elif [ $Identify = 'msm8996pro' ];then
    result=骁龙821
elif [ $Identify = 'msm8996pro' -a `cat $cpu3_max_freq_file_fixed` -lt 2200000 ];then
    result=骁龙821节能版
#骁龙76X
elif [ $Identify = 'lito' -a `cat $cpu7_max_freq_file_fixed` -gt 2700000 ];then
    result=骁龙768G
elif [ $Identify = 'lito' -a `cat $cpu7_max_freq_file_fixed` -lt 2700000 -a `cat $cpu7_max_freq_file_fixed` -gt 2399999 ];then
    result=骁龙765G
elif [ $Identify = 'lito' -a `cat $cpu7_max_freq_file_fixed` -lt 2399999 ];then
    result=骁龙765
#骁龙730G与骁龙675
elif [ $Identify = 'sm6150' -a `cat $cpu7_max_freq_file_fixed` -gt 2100000 ];then
    result=骁龙730G
elif [ $Identify = 'sm6150' -a `cat $cpu7_max_freq_file_fixed` -it 2100000 ];then
    result=骁龙675
#骁龙71X
elif [ $Identify = 'sdm710' ];then
    result=骁龙710
#骁龙660
elif [ $Identify = 'sm660' `cat $cpu7_max_freq_file_fixed -gt 2000000 ];then
    result=骁龙660
elif [ $Identify = 'sm660' `cat $cpu7_max_freq_file_fixed -lt 2000000 ];then
    result=骁龙660节能版
#骁龙65X
elif [ $Identify = 'msm8976' ];then
    result=骁龙652
elif [ $Identify = 'msm8956' ];then
    result=骁龙650
#骁龙636
elif [ $Identify = 'sm636' ];then
    result=骁龙636
#骁龙62X
elif [ $Identify = 'msm8953pro' ];then
    result=骁龙626
elif [ $Identify = 'msm8953' ];then
    result=骁龙625
else
    result=未知(联系群主添加代码)
fi
echo $result > /storage/emulated/TC/Result/SOC
done