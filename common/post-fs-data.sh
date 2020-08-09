#!/system/bin/sh
MODDIR=${0%/*}
Delete_temperature_control=#data#adb#modules#Custom_temperature_control
find /system/ -name '*thermal*' > /data/Delete_temperature_control
find /system/vendor/ -name '*thermal*' >> /data/Delete_temperature_control
echo "/system/vendor/etc/perf/perfboostsconfig.xml" >> /data/Delete_temperature_control
if [ `getprop ro.product.brand` = 'asus' ];then
cat /data/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v '.so' > /data/干温控.sh
elif [ `getprop ro.product.brand` = 'lge' ];then
cat /data/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice'|grep -v "/vendor/bin/thermal-engine" > /data/干温控.sh
else
cat /data/Delete_temperature_control|grep -v '@'|grep -v '.jar'|grep -v '.odex'|grep -v '.vdex'|sort -u|grep -v 'thermalservice' > /data/干温控.sh
fi
sed -i "s/^/mkdir -p $Delete_temperature_control/g" /data/干温控.sh
sed -i "s/#/\//g" /data/干温控.sh
sh /data/干温控.sh
sed -i "s/mkdir -p/rm -rf/g" /data/干温控.sh
sh /data/干温控.sh
sed -i 's/rm -rf/touch/g' /data/干温控.sh
sh /data/干温控.sh
rm -rf /data/Delete_temperature_control
rm -rf /data/干温控.sh
if [ ! -d "/data/vendor/thermal" ];then
    echo "干翻温控" > /data/vendor/thermal
    chattr +i /data/vendor/thermal
else
    rm -rf /data/vendor/thermal
    echo "干翻温控" > /data/vendor/thermal
    chattr +i /data/vendor/thermal
fi