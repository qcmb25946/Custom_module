#!/system/bin/sh


#游戏优化和破解画质

while true
do
date
#参数路径
zdy_path="/cache/ZDY"
#游戏设置路径
game="$zdy_path/game"

#王者荣耀优化
#王者荣耀优化文件路径
king_glory_file="/data/data/com.tencent.tmgp.sgame/shared_prefs/com.tencent.tmgp.sgame.v2.playerprefs.xml"
#王者荣耀优化开关
king_glory_switch="$(cat "$game/king_glory_switch")"
#王者荣耀参考路径
king_glory_path="/data/data/com.tencent.tmgp.sgame/files/"
#O3T
#判断王者荣耀是否存在
if [ -d "$king_glory_path" ];then
    #判断王者荣耀优化文件
    if [ -f "$king_glory_file" ];then
        #O3T
        EnableGLES3="$(cat "$king_glory_file"|grep "EnableGLES3"|cut -d\" -f4)"
        #VT
        EnableVulkan="$(cat "$king_glory_file"|grep "EnableVulkan"|cut -d\" -f4)"
        #多线程
        EnableMTR="$(cat "$king_glory_file"|grep "EnableMTR"|cut -d\" -f4)"
        #O3T优化
        if [ "$king_glory_switch" = "G" ];then
            #O3T
            if [ ! -z "$EnableGLES3" ];then
                if [ "$EnableGLES3" != "1" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableGLES3".*/    <int name="EnableGLES3" value="1" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi
            #VT
            if [ ! -z "$EnableVulkan" ];then
                echo $EnableVulkan
                if [ "$EnableVulkan" != "3" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableVulkan".*/    <int name="EnableVulkan" value="3" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi
            #多线程
            if [ ! -z "$EnableMTR" ];then
                if [ "$EnableMTR" != "1" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableMTR".*/    <int name="EnableMTR" value="1" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi
            echo $king_glory_file
        #VT优化
        elif [ "$king_glory_switch" = "V" ];then
            #O3T
            if [ ! -z "$EnableGLES3" ];then
                if [ "$EnableGLES3" != "3" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableGLES3".*/    <int name="EnableGLES3" value="3" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi

            #VT
            if [ ! -z "$EnableVulkan" ];then
                if [ "$EnableVulkan" != "1" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableVulkan".*/    <int name="EnableVulkan" value="1" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi
            #多线程
            if [ ! -z "$EnableMTR" ];then
                if [ "$EnableMTR" != "1" ];then
                    chattr -i "$king_glory_file"
                    sed -i 's/.*"EnableMTR".*/    <int name="EnableMTR" value="1" \/>/g' "$king_glory_file"
                    chattr +i "$king_glory_file"
                fi
            fi
        #关闭优化
        elif [ "$king_glory_switch" = "O" ];then
            chattr -i "$king_glory_file"
            rm -rf "$king_glory_file"
            echo N > "$game/king_glory_switch"
        fi
    fi
#对卸载残余文件进行处理
else
    if [ -f "$king_glory_file" ];then
        chattr -i "$king_glory_file"
    fi
    rm -rf "/data/data/com.tencent.tmgp.sgame/"
fi
#王者荣耀前瞻版
#王者荣耀优化文件路径
king_glory_foresight_file="/data/data/com.tencent.tmgp.sgamece/shared_prefs/com.tencent.tmgp.sgamece.v2.playerprefs.xml"
#王者荣耀优化开关
king_glory_foresight_switch="$(cat "$game/king_glory_foresight_switch")"
#王者荣耀参考路径
king_glory_foresight_path="/data/data/com.tencent.tmgp.sgamece/files/"
#O3T
#判断王者荣耀是否存在
if [ -d "$king_glory_foresight_path" ];then
    #判断王者荣耀优化文件
    if [ -f "$king_glory_foresight_file" ];then
        #O3T
        EnableGLES3="$(cat "$king_glory_foresight_file"|grep "EnableGLES3"|cut -d\" -f4)"
        #VT
        EnableVulkan="$(cat "$king_glory_foresight_file"|grep "EnableVulkan"|cut -d\" -f4)"
        #多线程
        EnableMTR="$(cat "$king_glory_foresight_file"|grep "EnableMTR"|cut -d\" -f4)"
        #O3T优化
        if [ "$king_glory_foresight_switch" = "G" ];then
            #O3T
            if [ ! -z "$EnableGLES3" ];then
                if [ "$EnableGLES3" != "1" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableGLES3".*/    <int name="EnableGLES3" value="1" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
            #VT
            if [ ! -z "$EnableVulkan" ];then
                if [ "$EnableVulkan" != "3" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableVulkan".*/    <int name="EnableVulkan" value="3" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
            #多线程
            if [ ! -z "$EnableMTR" ];then
                if [ "$EnableMTR" != "1" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableMTR".*/    <int name="EnableMTR" value="1" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
        #VT优化
        elif [ "$king_glory_foresight_switch" = "V" ];then
            #O3T
            if [ ! -z "$EnableGLES3" ];then
                if [ "$EnableGLES3" != "3" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableGLES3".*/    <int name="EnableGLES3" value="3" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
            #VT
            if [ ! -z "$EnableVulkan" ];then
                if [ "$EnableVulkan" != "1" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableVulkan".*/    <int name="EnableVulkan" value="1" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
            #多线程
            if [ ! -z "$EnableMTR" ];then
                if [ "$EnableMTR" != "1" ];then
                    chattr -i "$king_glory_foresight_file"
                    sed -i 's/.*"EnableMTR".*/    <int name="EnableMTR" value="1" \/>/g' "$king_glory_foresight_file"
                    chattr +i "$king_glory_foresight_file"
                fi
            fi
        #关闭优化
        elif [ "$king_glory_foresight_switch" = "O" ];then
            chattr -i "$king_glory_foresight_file"
            rm -rf "$king_glory_foresight_file"
            echo N > "$game/king_glory_foresight_switch"
        fi
    fi
#对卸载残余文件进行处理
else
    if [ -f "$king_glory_foresight_file" ];then
        chattr -i "$king_glory_foresight_file"
    fi
    rm -rf "/data/data/com.tencent.tmgp.sgamece/"
fi

#和平精英
#和平精英破解画质开关
peace_elite_switch="$(cat "$game/peace_elite_switch")"
#和平精英路径
peace_elite_path="/sdcard/Android/data/com.tencent.tmgp.pubgmhd/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Config/Android"
#和平精英优化文件
peace_elite_file="$peace_elite_path/EnjoyCJZC.ini"
#判断和平精英是否存在
if [ -d "$peace_elite_path" ];then
    #有话开关
    if [ "$peace_elite_switch" = "Y" ];then
        if [ ! -f "$peace_elite_file" ];then
            echo "[FansSwitcher]
+CVars=r.PUBGMaxSupportQualityLevel=3
+CVars=r.PUBGDeviceFPSLow=6
+CVars=r.PUBGDeviceFPSMid=6
+CVars=r.PUBGDeviceFPSHigh=6
+CVars=r.PUBGDeviceFPSHDR=6
+CVars=r.PUBGDeviceFPSDef=6
+CVars=r.PUBGMSAASupport=1
+CVars=r.PUBGLDR=1" > "$peace_elite_file"
        fi
    elif [ "$peace_elite_switch" = "O" ];then
        chattr -i $peace_elite_file
        rm -rf $peace_elite_file
        echo N > "$game/peace_elite_switch"
    fi
fi
sleep 3
done