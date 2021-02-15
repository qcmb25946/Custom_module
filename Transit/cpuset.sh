#任务分配机制

#参考路径
kernel_max=`cat /sys/devices/system/cpu/kernel_max`
Rows=`cat /storage/emulated/TC/Result/CPUS/Vertical_collection|wc -l`
the_first=`cat /storage/emulated/TC/Result/CPUS/Vertical_collection|cut -c1`
#分纵集
if [ ! -e "/storage/emulated/TC/Result/CPUS/Vertical_collection" ];then
    for i in $(seq 0 $kernel_max)
    do
        affected_cpus=`cat /sys/devices/system/cpu/cpu$i/cpufreq/affected_cpus`
        affected_cpus_wc=`cat /sys/devices/system/cpu/cpu$i/cpufreq/affected_cpus|wc -w`
        if [ $affected_cpus_wc -eq 1 ];then
            echo $affected_cpus >> /storage/emulated/TC/Result/CPUS/process
        else
            echo $affected_cpus|awk '{print $1,$NF}'|sed 's/ /-/g' >> /storage/emulated/TC/Result/CPUS/process
        fi
    done
    uniq /storage/emulated/TC/Result/CPUS/process > /storage/emulated/TC/Result/CPUS/Vertical_collection
    rm -rf /storage/emulated/TC/Result/CPUS/process
fi
#最小频率
for i in $(seq 0 $kernel_max)
do
    cpu_min_freq=`cat /sys/module/msm_performance/parameters/cpu_min_freq|cut -d" " -f$(($i+1))|cut -d: -f2`
    if [ $cpu_min_freq -ne `cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_min_freq` ];then
        chmod 666 /sys/module/msm_performance/parameters/cpu_min_freq
        echo "$i:`cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_min_freq`" > /sys/module/msm_performance/parameters/cpu_min_freq
        chmod 444 /sys/module/msm_performance/parameters/cpu_min_freq
    fi
done
#后台任务
if [ -f '/dev/cpuset/background/cpus' ];then
    if [ ! `cat /dev/cpuset/background/cpus` = `awk 'NR<2' /storage/emulated/TC/Result/CPUS/Vertical_collection` ];then
        chmod 666 /dev/cpuset/background/cpus
        awk 'NR<2' /storage/emulated/TC/Result/CPUS/Vertical_collection > /dev/cpuset/background/cpus
        chmod 444 /dev/cpuset/background/cpus
    fi
fi
#系统后台任务
if [ -f '/dev/cpuset/system-background/cpus' ];then
    if [ ! `cat /dev/cpuset/system-background/cpus` = `awk 'NR<2' /storage/emulated/TC/Result/CPUS/Vertical_collection` ];then
        chmod 666 /dev/cpuset/system-background/cpus
        awk 'NR<2' /storage/emulated/TC/Result/CPUS/Vertical_collection > /dev/cpuset/system-background/cpus
        chmod 444 /dev/cpuset/system-background/cpus
    fi
fi
#前台界面任务
if [ -f '/dev/cpuset/top-app/cpus' ];then
    if [ ! `cat /dev/cpuset/top-app/cpus` = "0-$kernel_max" ];then
        chmod 666 /dev/cpuset/top-app/cpus
        echo "0-$kernel_max" > /dev/cpuset/top-app/cpus
        chmod 444 /dev/cpuset/top-app/cpus
    fi
fi
#前台任务
if [ -f '/dev/cpuset/foreground/boost/cpus' ];then
    if [ ! `cat /dev/cpuset/foreground/boost/cpus` = "0-$kernel_max" ];then
        chmod 666 /dev/cpuset/foreground/boost/cpus
        echo "0-$kernel_max" > /dev/cpuset/foreground/boost/cpus
        chmod 444 /dev/cpuset/foreground/boost/cpus
    fi
fi
if [ -f '/dev/cpuset/foreground/cpus' ];then
    if [ ! `cat /dev/cpuset/foreground/cpus` = "0-$kernel_max" ];then
        chmod 666 /dev/cpuset/foreground/cpus
        echo "0-$kernel_max" > /dev/cpuset/foreground/cpus
        chmod 444 /dev/cpuset/foreground/cpus
    fi
fi