logcat > /mnt/sdcard/logcat.log &
monkey -p tv.okko.androidtv --pct-touch 0 --pct-motion 0 --pct-nav 70 --pct-majornav 10 --pct-syskeys 10 --pct-appswitch 10 --ignore-security-exceptions --throttle 100  -vv 1000 > /mnt/sdcard/monkey.log
pidof logcat
logcat > /mnt/sdcard/logcat.log &
monkey -p ru.ivi.client --pct-touch 0 --pct-motion 0 --pct-nav 70 --pct-majornav 10 --pct-syskeys 10 --pct-appswitch 10 --ignore-security-exceptions --throttle 100  -vv 1000 > /mnt/sdcard/monkey.log
pidof logcat
logcat > /mnt/sdcard/logcat.log &
monkey -p ru.start.androidtv --pct-touch 0 --pct-motion 0 --pct-nav 70 --pct-majornav 10 --pct-syskeys 10 --pct-appswitch 10 --ignore-security-exceptions --throttle 100  -vv 1000 > /mnt/sdcard/monkey.log
pidof logcat
logcat > /mnt/sdcard/logcat.log &
monkey -p ag.tv.a24h --pct-touch 0 --pct-motion 0 --pct-nav 70 --pct-majornav 10 --pct-syskeys 10 --pct-appswitch 10 --ignore-security-exceptions --throttle 100  -vv 1000 > /mnt/sdcard/monkey.log
pidof logcat
logcat > /mnt/sdcard/logcat.log &
monkey -p ru.rt.video.app.tv --pct-touch 0 --pct-motion 0 --pct-nav 70 --pct-majornav 10 --pct-syskeys 10 --pct-appswitch 10 --ignore-security-exceptions --throttle 100  -vv 1000 > /mnt/sdcard/monkey.log
pidof logcat
