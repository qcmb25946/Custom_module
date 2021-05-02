#!/system/bin/sh


#快速寻找

while true
do
date
#快速寻找开关
#参数路径
zdy_path="/cache/ZDY"
#快速寻找
search="$zdy_path/search"
#开关
switch="$(cat "$search/switch")"
#参考路径
fast_search="/data/adb/modules/Custom_module/parameter/fast_search"
#快速寻找脚本
find_scripts_quickly="$search/find_scripts_quickly.sh"
#快速寻找路径
fast_search_path="/cache/快速寻找"
fast_search_path_1="\/cache\/快速寻找\/"
#已存在路径
if [ -d "$fast_search_path" ];then
    existing_path=$(find "$fast_search_path" -type l)
fi
#开启快速寻找
if [ "$switch" = "Y" ];then
    #创建快速寻找路径
    if [ ! -d "$fast_search_path" ];then
        mkdir -p "$fast_search_path"
    fi
    #创建快速寻找脚本
    if [ ! -f "$find_scripts_quickly" ];then
        cat "$fast_search"|awk -F"=" '{print $2 "#1" $1 "#2" $2 "#3" $1 "#4" $1 "#5" $1}'|sed "s/^/if [ -d \"/g"|sed "s/#1/\" ];then#0#9if \[ ! -L \"$fast_search_path_1/g"|sed "s/#2/\" ];then#0#9#9ln -s \"/g"|sed "s/#3/\" \"$fast_search_path_1/g"|sed "s/#4/\"#0#9fi#0else#9#0#9if [ -L \"$fast_search_path_1/g"|sed "s/#5/\" ];then#0#9#9rm -rf \"$fast_search_path_1/g"|sed "s/$/\"#0#9fi#0fi/g"|sed "s/#0/\n/g"|sed "s/#9/    /g" > $find_scripts_quickly
        chattr +i "$find_scripts_quickly"
    fi
    if [ ! -f "$fast_search_path/注意事项" ];then
        echo "注意事项：
1.禁止更改文件夹名字
2.可以在文件夹寻找自己需要文件可以当成一般文件操作就行
" > "$fast_search_path/注意事项"
    fi
    #执行脚本
    . $find_scripts_quickly
#关闭快速寻找
elif [ "$switch" = "O" ];then
    #清除软连接
    if [ -d "$fast_search_path" ];then
        rm -rf $fast_search_path
    fi
    #清除脚本
    if [ -f "$find_scripts_quickly" ];then
        chattr -i "$find_scripts_quickly"
        rm -rf "$find_scripts_quickly"
    fi
    echo N > "$search/switch"
fi
sleep 3
done
