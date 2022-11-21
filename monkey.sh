logcat > /mnt/sdcard/logcat.log &
monkey -p com.family.atlas.launcher --pct-touch 15 --pct-motion 20 --pct-nav 15 --pct-majornav 20 --pct-syskeys 15 --pct-appswitch 15 --ignore-security-exceptions --throttle 200  -vv 10000 > /mnt/sdcard/monkey.log
pidof logcat  |while read i; do  echo -n "${i} : ";kill ${i};done
