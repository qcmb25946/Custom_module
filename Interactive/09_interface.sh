#!/system/bin/sh


#界面

#主菜单路径
Interaction_path="/data/adb/modules/Custom_module/Interactive/"
#标语路径
slogan_path="/data/adb/modules/Custom_module/parameter/slogan"
#帮助路径
help_path="/data/adb/modules/Custom_module/parameter/help"
#标语总数
total_slogan=$(cat $slogan_path|cut -c1|wc -w)
#随机数
random_number=$((RANDOM%${total_slogan} + 1))

#随机标语
slogan="$(cat $slogan_path|awk '{print FNR "=" $0}'|grep "^${random_number}="|cut -d= -f2)"

#随机标语字数
Word_count="$(echo $slogan|wc -m)"

clear
#时间
date "+%F %T"
echo

#输出标语
sleep 0.5
#
for A in $(seq $Word_count)
    do
        #间隔选择
        #echo $slogan|cut -d" " -f$A
        #字选择
        word=$(echo $slogan|cut -c$A)
        if [ "$word" = " " ];then
            echo
        else
            printf "$word"
        fi
        sleep 0.1
    done
echo

echo
#帮助字段
total_help="$(cat $help_path|wc -w)"
#输出帮助
for B in $(seq $total_help)
    do
        #字
        word="$(cat $help_path|cut -d" " -f$B)"
        if [ "$word" = " " ];then
            echo
        elif [ "$word" = "t" ];then
            printf "\t"
        else
            echo "$word"
        fi
        sleep 0.2
    done
echo