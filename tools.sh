#!/usr/bin/env bash

########################################
K_GET_IP="--get_ip"
K_NEW_DAY="--new_day"
K_WIFI="--wifi"
K_DPI="--dpi"
K_PROSHIVOCHKA="--proshivochka"
K_PROVERKA="--proverka"
K_CHECKB="--checkb"
K_MONKEY_FON="--monkey_fon"
K_MONKEY_RESULT="--monkey_result"
K_TETS_FUN="--test_fun"
K_CONNECT="--connect"
K_BIG_BAD_MONKEY="--big_bad_monkey"
K_DISCONNECT="--disconnect"
K_ALL_STORE_TEST="--all_store_test"
K_CONNECT2ALL_SEND_BROADCAST="--connect2all_send_broadcast"
K_GETPROP="--getprop"
K_INSTALL_PAK="--install_pack_apk"
K_LOGCAT="--get_logcat"
K_OPEN_FACT="--open_factory"
K_UNINST="--uninstall_apk"
K_UNINST_PAK="--uninstall_pack_apk"
K_UNINST_DIFF="--uninstall_diff_apk"
K_SEND="--send_broadcast_store_client"
K_STOP_APP="--stop_app"
K_GET_NAME="--get_app_name"
K_SCREEN="--screen"
K_GET_VERS="--get_app_name_version"
K_DIFF_VERSION="--check_apps_version_vs"
K_FIND="--find_on_android"
K_MONKEY="--monkey_test"
K_CLEAR_DATA="--clear_data"
K_RFAV="--readfromapkversion"
K_HELP="--help"
ALL_KEYWORDS=("${K_RFAV}" "${K_GETPROP}" "${K_TETS_FUN}" "${K_GET_IP}" "${K_NEW_DAY}" "${K_PROVERKA}" "${K_CHECKB}" "${K_MONKEY_FON}" "${K_MONKEY_RESULT}" "${K_MONKEY}" "${K_CONNECT}" "${K_BIG_BAD_MONKEY}" "${K_DISCONNECT}" "${K_ALL_STORE_TEST}" "${K_CONNECT2ALL_SEND_BROADCAST}" "${K_INSTALL_PAK}" "${K_LOGCAT}" "${K_OPEN_FACT}" "${K_UNINST}" "${K_UNINST_PAK}" "${K_UNINST_DIFF}" "${K_SEND}" "${K_STOP_APP}" "${K_GET_NAME}" "$K_SCREEN" "${K_GET_VERS}" "${K_DIFF_VERSION}" "${K_CLEAR_DATA}" "${K_FIND}" "${K_HELP}")

###################Проверки темповых файлов#####################

# Проверка наличия папки, создание
  mkdir -p ~/.tool

# Проверка файла, создание
  if ! [  -f  ~/.tool/modules.install ]; then
    touch ~/.tool/modules.install
  fi

# Проверка файла, создание
if ! [  -f  ~/.tool/modules.uninstall ]; then
    touch ~/.tool/modules.uninstall
  fi


# Проверка файла + создание ip лист
  if ! [  -f  ~/.tool/list_ip.txt ]; then
    touch ~/.tool/list_ip.txt
  fi

#####################################################################
WHITELIST=~/.tool/list_ip.txt
IP=$(cat ${WHITELIST})
TOOL=~/.tool/
TEXT_MON=(${TOOL}mon.txt)
MODULES_INSTALL=(${TOOL}modules.install)
MODULES_UNINSTALL=(${TOOL}modules.uninstall)

APKFILES=$(cat ${MODULES_INSTALL})
TEMP_DIFF_NEW_OLD=app_diff_new_old.txt
FIND=su
PKG=store
ACTIVITY=.ui.MainActivity
APPDEF=app_stock.txt
APPCUR=app_updated.txt

showHelp() {
cat << EOF
Usage: $(basename "$0") <commands>
Simple cli helper for android client.
Default: build, install apk and launch main activity.
  ${K_GET_IP}
  ${K_NEW_DAY}
  ${K_WIFI}
  ${K_DPI}
  ${K_PROSHIVOCHKA}
  ${K_PROVERKA}
  ${K_CHECKB}
  ${K_MONKEY_FON}
  ${K_MONKEY_RESULT}
  ${K_TETS_FUN}
  ${K_CONNECT}
  ${K_BIG_BAD_MONKEY}
  ${K_DISCONNECT}
  ${K_ALL_STORE_TEST}
  ${K_CONNECT2ALL_SEND_BROADCAST}
  ${K_GETPROP}
  ${K_INSTALL_PAK}
  ${K_LOGCAT}
  ${K_OPEN_FACT}
  ${K_UNINST}
  ${K_UNINST_PAK}
  ${K_UNINST_DIFF}
  ${K_SEND}
  ${K_STOP_APP}
  ${K_GET_NAME}
  ${K_GET_VERS}
  ${K_DIFF_VERSION}
  ${K_FIND}
  ${K_MONKEY}
  ${K_CLEAR_DATA}
  ${K_RFAV}
  ${K_HELP}            Show this help and exit
EOF
}

get_ip(){
    PS3='В какой сети ищем? '
    choose=("Боевая сеть" "Тестовая сеть" "Произвольная сеть" "Выход")
    select opt in "${choose[@]}"
    do
        case $opt in
            "Боевая сеть")
                cat /dev/null > ${WHITELIST}
                sleep 1
                nmap -p 5555 -n 192.168.0.100-200 --open -oG - | awk '/Up$/{print $2}' >> ${WHITELIST}
                echo "Список ip адресов с открытым портом ${PORT:="5555"}"
                cat ~/.tool/list_ip.txt
                break
            ;;
            "Тестовая сеть")
                cat /dev/null > ${WHITELIST}
                sleep 1
                nmap -p 5555 -n 172.17.10.100-200 --open -oG - | awk '/Up$/{print $2}' >> ${WHITELIST}
                echo "Список ip адресов с открытым портом ${PORT:="5555"}"
                cat ~/.tool/list_ip.txt
                break
            ;;
            "Произвольная сеть")
                echo -n "В какой сети искать?192.168.0.100-200    :"
                read RANGE
                echo -n "Порт?\"5555\"   :"
                read PORT
                cat /dev/null > ${WHITELIST}
                sleep 1
                nmap -p ${PORT:="5555"} -n ${RANGE:=192.168.0.100-200} --open -oG - | awk '/Up$/{print $2}' >> ${WHITELIST}
                echo "Список ip адресов с открытым портом ${PORT:="5555"}"
                cat ~/.tool/list_ip.txt
                break
            ;;
            "Выход")
                break
            ;;
        *) echo "Запрос не распознан $REPLY";;
    esac
done
}

new_day(){
	n=$(date +%x)
	mkdir $n
    ls
}

wifi(){
  echo "starting wi-fi settings"
    adb shell am start -a android.settings.WIFI_SETTINGS
}

dpi(){
  echo "Получение dpi:"
    adb shell getprop |grep -E "(ro.sf.lcd_density)"
# > ~/.tool/${IPS}.txt
}

proshivochka(){
  shum
  echo "Store"
    adb shell dumpsys package abox.store.client| grep -i versionName
  sleep 1
  shum
  echo "Atlas"
    adb shell dumpsys package com.family.atlas.launcher| grep -i versionName
  sleep 1
  shum
    getprop
}

proverka(){
 echo "Введите интервал проверки в секунду"
 read INTERVAL
 clear
  for (( i=0; i<10; ++i)); do
   cat /dev/null >${TEXT_MON}
   monitor >>${TEXT_MON}
   clear
   date
   cat ${TEXT_MON}
  sleep 1
  shum
  echo "Жду ${INTERVAL} секунд"
  shum
  sleep ${INTERVAL}

done
}


checkb(){
 if [ $? -ne 0 ] ; then
        echo "Failed"
        else
        echo "Success"
    fi
}


#манки фон
monkey_fon(){
 #!/usr/bin/env bash
 #adb push /home/enot/.tool/monkey.sh /mnt/sdcard/
 #sleep 5
 #adb shell sh /mnt/sdcard/monkey.sh 2>/dev/null &
 ##########################################################################
 echo -n "Очистка monkey.log : "
 adb shell rm /mnt/sdcard/monkey.log 2>/dev/null
 checkb
 sleep 1
 echo -n "Очистка monkey.sh : "
 adb shell rm /mnt/sdcard/monkey.sh 2>/dev/null
 checkb
 sleep 1
 echo -n "Очистка logcat.log: "
 adb shell rm /mnt/sdcard/logcat.log 2>/dev/null
 checkb
 sleep 1
 echo -n "Версия тестируемого приложения :"
 get_app_name_version |grep "com.family.atlas.launcher"
 echo -n "Sending script :"
 adb push '/home/enot/Рабочий стол/DJUF1N/code/work/monkey.sh' /mnt/sdcard/ 1>/dev/null 2>/dev/null
 checkb
 sleep 1
 echo -n "Фоновой запуск скрипта : "
 adb shell sh /mnt/sdcard/monkey.sh 2>/dev/null &
 checkb
 sleep 1
 #sleep 900
 #adb shell kill $(adb shell pidof com.android.commands.monkey)
 #monkey_result
}


# Определение результата после monkey test
monkey_result(){
 echo -n "TEST RESULT :"
 adb pull /mnt/sdcard/monkey.log
 tail '/home/enot/Рабочий стол/DJUF1N/2022/August/10.08.2022/monkey.log'
}


#тест функция
test_fun(){
    echo "сделай блятский визуал"
}

#подключение adb connect
connect(){
	adb connect
}


#множественный тест мартышкой
big_bad_monkey(){
	PS3='Сделай выбор: '
	options=("Высадка" "Подбор" "Выход")
	select opt in "${options[@]}"
	do
	    case $opt in
 	       "Высадка")
			for IPS in ${IP}; do
          		  adb disconnect 2> /dev/null 1> /dev/null
          		  echo ""
        		    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
        		    sleep 1
        		    if [ $? -ne 0 ] ; then
         		   	sleep 1
				echo "Failed to connect ${IPS}"
			    fi
			    	echo "Connected to ${IPS}"
		        monkey_fon
			done
   			disconnect
     	       ;;
  	       "Подбор")

			for IPS in ${IP}; do
          		  adb disconnect 2> /dev/null 1> /dev/null
          		  echo ""
        		    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
        		    sleep 1
        		    if [ $? -ne 0 ] ; then
         		   	sleep 1
				echo "Failed to connect ${IPS}"
			    fi
			    	echo "Connected to ${IPS}"
			    monkey_result
			done
   			disconnect

	       ;;
	        "Выход")
            break
            ;;
        *) echo "Поясника за $REPLY";;
    esac
done
   }

#Все кейсы теста стора с возможностью выбора оных
all_store_test(){
    PS3='Сделай выбор Нео: '
    options=("Сбор info" "Подготовка устройств" "Кейс 1/4" "Кейс 2" "Выход")
    select opt in "${options[@]}"
    do
        case $opt in
            "Сбор info")
                for IPS in ${IP}; do
                    adb disconnect 2> /dev/null 1> /dev/null
                    echo ""
                    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
                    sleep 1
                    if [ $? -ne 0 ] ; then
            	        sleep 1
		                echo "Failed to connect ${IPS}"
	                fi
	    	            echo "Connected to ${IPS}"
                        ##########################
                        echo -n
                        sleep 1
                        shum
                        sleep 1
                        echo -n "Текущий:"
                        sleep 1
	                    adb shell dumpsys package abox.store.client| grep -i versionName
                        sleep 1
                        echo -n
	                    sleep 1
	                    shum
                        sleep 1
                        getprop
                        sleep 1
                        shum
                        sleep 1
                        echo -n
                        ##########################
                done
                disconnect
                break
                ;;

            "Подготовка устройств")
                for IPS in ${IP}; do
                    adb disconnect 2> /dev/null 1> /dev/null
                    echo ""
                    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
                    sleep 1
                    if [ $? -ne 0 ] ; then
            	        sleep 1
		                echo "Failed to connect ${IPS}"
	                fi
	    	            echo "Connected to ${IPS}"
                        ##########################
                        echo -n
                        sleep 1
	                    shum
	                    echo "Текущий:"
	                    adb shell dumpsys package abox.store.client| grep -i versionName
	                    sleep 1
	                    shum
	                    getprop
                        sleep 1
	                    shum
                        echo "Удаляю apk:"
                        uninstall_pack_apk
                        sleep 1
                        shum
	                    echo "Установленный:"
	                    adb shell dumpsys package abox.store.client| grep -i versionName
	                    sleep 1
	                    shum
                        echo -n "Чистка cash:"
	                    adb shell pm clear abox.store.client
	                    sleep 1
	                    open_factory 2>/dev/null 1>/dev/null
	                    sleep 5
	                    adb shell reboot
                        ##########################
                done
                disconnect
                break
                ;;

            "Кейс 1/4")
                for IPS in ${IP}; do
                    adb disconnect 2> /dev/null 1> /dev/null
                    echo ""
                    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
                    sleep 1
                    if [ $? -ne 0 ] ; then
            	        sleep 1
		                echo "Failed to connect ${IPS}"
	                fi
	    	            echo "Connected to ${IPS}"
                        ##########################
                        sleep 1
                        shum
                        echo "Текущий:"
	                    adb shell dumpsys package abox.store.client| grep -i versionName
                        sleep 1
                        shum
                        getprop
                        sleep 1
                        shum
                        shum
                        echo "Удаляю стор:"
                        adb uninstall abox.store.client
                        sleep 1
                        shum
                        echo "Устанавливаем стор:"
                        adb install -r /home/enot/.tool/abox.store_20191226_f9dc3adc5352ab82f2959a90fc3f9b6b_sys.apk
                        sleep 1
                        shum
                        echo "Текущий:"
                        adb shell dumpsys package abox.store.client| grep -i versionName
                        shum
                        adb shell reboot
                        ##########################
                done
                disconnect
                break
                ;;

            "Кейс 2")
                echo "Перейдите в папку с раздающимся стором и введите название файла"
                read APK_NAME
                sleep 1
                for IPS in ${IP}; do
                    adb disconnect 2> /dev/null 1> /dev/null
                    echo ""
                    timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
                    sleep 1
                    if [ $? -ne 0 ] ; then
            	        sleep 1
		                echo "Failed to connect ${IPS}"
	                fi
	    	            echo "Connected to ${IPS}"
                        ##########################
                        sleep 1
                        shum
                        echo "Текущий:"
	                    adb shell dumpsys package abox.store.client| grep -i versionName
                        sleep 1
                        shum
                        getprop
                        sleep 1
                        shum
                        shum
                        echo "Удаляю стор:"
                        adb uninstall abox.store.client
                        sleep 1
                        shum
                        echo "Устанавливаем стор:"
                        adb install -r ${APK_NAME}
                        sleep 1
                        shum
                        echo "Текущий:"
                        adb shell dumpsys package abox.store.client| grep -i versionName
                        shum
                        adb shell reboot
                        ##########################
                done
                disconnect
                break
                ;;

            "Выход")
                echo "Ты расстроил Морфиуса"
                echo "(*μ_μ)"
                break
                ;;

        *) echo "Это не правильная таблетка, Нео..."
            echo -n "(*μ_μ)"
            echo ""
    esac
done
}

#подключение к ТВ по списку, отсылка broadcast, отключение
connect2all_send_broadcast(){
	for IPS in ${IP}; do
            adb disconnect 2> /dev/null 1> /dev/null
            echo ""
            timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
            sleep 1
            if [ $? -ne 0 ] ; then
            	sleep 1
		    echo "Failed to connect ${IPS}"
	    fi
	    	echo "Connected to ${IPS}"
            #return 0
            ########################################### установка apk и старт его
            adb install -r abox.statistic.apk
            adb shell getprop sys.wildred.hw_id
            sleep 2
            adb shell am start -n "ru.abox.myhome/abox.myhome.MainActivity"
    done
    disconnect
}

#Установка списка приложений
install_pack_apk(){
    cat /dev/null >|${MODULES_INSTALL}
    ls *.apk >> ${MODULES_INSTALL}

 # for INP in  $(ls -f *.tar.gz );do
    for APK in $(cat ${MODULES_INSTALL}); do
            echo "Installing apk ${APK}"
            adb install -r ${APK} 2> /dev/null 1> /dev/null
            if [ $? -ne 0 ] ; then
        echo "Failed to install ${APK}"
    fi

  done
}

#получение списка  getprop
getprop(){
 echo "Получение getprop:"
 adb shell getprop |grep -E "(sys.wildred.hw_id|sys.wildred.brand|ro.product.brand|ro.product.device|ro.product.model|sys.wildred.version|ro.build.date.utc|ro.build.version.min_supported_target_sdk|ro.build.version.sdk|ro.sf.lcd_density|qemu.sf.lcd_density)"
 # > ~/.tool/${IPS}.txt
}

#Monkey test для выбранного приложения
monkey_test(){
 echo -n "По какому приложению будем проводить monkey-тест?default(com.family.atlas.launcher) :"
 read PACKAGE
 echo -n "Задержка между событиями в ms ?default(100ms) :"
 read THROTTLE
 echo -n "Количество событий?default(1000) :"
 read EVENT
 adb shell monkey -p ${PACKAGE:=com.family.atlas.launcher} --pct-touch 15 --pct-motion 20 --pct-nav 15 --pct-majornav 20 --pct-syskeys 15 --pct-appswitch 15 --ignore-security-exceptions --throttle ${THROTTLE:=100}  -vv ${EVENT:=10000}

}

#Остановка приложения store
stop_app(){
    echo -n "Введите название останавливаймого apk (по умалчанию установленно значение abox.F): "
    read APK_STOPED
    adb shell am force-stop ${APK_STOPED:=abox.F}
}

#Удаление определенного приложения
uninstall_apk(){
    local IS_SYSTEM=$(adb shell /system/bin/busybox id -u)
    echo "Uninstall package"
    if [ ${IS_SYSTEM} != 0 ]; then
    	echo -n "Введите название удаляймого apk (по умалчанию установленно значение abox.store.client): "
        read APK_UDALENIE
        adb uninstall ${APK_UDALENIE:=abox.F}
        echo "Удаление завершено"
    else
           echo "Удаление apk с правами root"
           adb root
           adb remount
           adb shell pm uninstall -k  ${APK_UDALENIE:=abox.F}
           adb unroot
    fi
}

get_app_name() {
    echo "Получение списка имен пакетов"
    CMD='adb shell "pm list packages -f" | sed -e "s/==//"'
    PACKAGES=$(eval ${CMD} | cut -f 2 -d "=")
    echo  ${PACKAGES}
    if [ ${#PACKAGES[@]} == 0 ]; then
	    echo "No packages found"
	    exit 0
    fi
    echo "Found packages: ${#PACKAGES[@]}"
    for P in "${PACKAGES[@]}"; do
	    NAME=$(echo "${P//[$'\t\r\n']}")
		echo -e "${NAME}\n"
    done
}


pull_file() {
  echo "pull_apk"
}

push_file() {
  echo "push_apk"
}

send_exec(){
  echo "exec_script"
}

get_logcat(){
    echo -n "Show logcat | grep by word?:"
    read FD
    adb shell logcat |  grep ${FD}
}


#МЕНЮ РАЗРАБОТЧИКА
open_factory(){
 echo "Последовательный перебор всех  вариантов вызова factory_menu "
 echo "send HiKeen(RTK2851/RTK2842) SOURCE>2580"
  adb shell am start -n 'com.hikeen.factorymenu/com.hikeen.factorymenu.FactoryMenuActivity'  2> /dev/null 1> /dev/null
  sleep 1
 echo ""

 echo "send CVTE(MTK55xx/SK506/SK706) HOME.SOURCE>ATV>MENU>1147"
  adb shell am startservice -n com.cvte.fac.menu/com.cvte.fac.menu.app.TvMenuWindowManagerService --es com.cvte.fac.menu.commmand com.cvte.fac.menu.commmand.factory_menu  2> /dev/null 1> /dev/null
  sleep 1
 echo ""
 echo "send KTC(6681) SOURCE>ATV>MENU>8202"
  adb shell am start -n kgzn.factorymenu.ui/mediatek.tvsetting.factory.ui.kgznfactorymenu.FactoryMenuActivity  2> /dev/null 1> /dev/null
  sleep 1
}



screen(){
 RAN=(${RANDOM}.png)
 echo "$(pwd)/${RAN}"
 echo -n "Do screenshoot  :"
 adb shell screencap /mnt/sdcard/${RAN}
 checkb
 echo -n "Pull /mnt/sdcard/${RAN} :"
 adb pull /mnt/sdcard/${RAN} 1>/dev/null 2>/dev/null
 checkb
 adb shell rm /mnt/sdcard/${RAN}
 # open . 0>/dev/null
}



#Получение установленных приложений и их версий с записью в файл
get_app_name_version() {
 #  echo "Получение списка пакетов и их версий"
  CMD='adb shell "pm list packages -f" | sed -e "s/==//"'
  PACKAGES=($(eval ${CMD} | cut -f 2 -d "="))
  if [ ${#PACKAGES[@]} == 0 ]; then
   echo "No packages found"
 #    exit 0
  fi
 #  echo "Found packages: ${#PACKAGES[@]}"
    for P in "${PACKAGES[@]}"; do
     NAME=$(echo "${P//[$'\t\r\n ']}")
     VERSIONS=($(adb shell dumpsys package $NAME | grep -i versionName | awk -F"=" '{print $2}'))
  echo -e "$NAME${BL} $VERSIONS${NC}"
    done
}

launch_activity(){
    adb shell am start -n "$PKG/$ACTIVITY" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
}

#Сравнение списков приложений. Текущий список  - Стоковый список и запист различий в файл foundit.txt
check_apps_version_vs(){
    echo "Сравнение файлов до и после обновления"
 #Без версии пакетов
 #   diff -E -b -B -w  ${APPCUR} ${APPDEF} | grep "<" | sed -e 's/^[ <]*//' > ${TEMP_DIFF_NEW_OLD}
 #С версиями пакетов
    diff -E -b -B -w  ${APPCUR} ${APPDEF} | grep "<" || sed -e 's/^[ <]*//' > ${TEMP_DIFF_NEW_OLD}
    cat ${TEMP_DIFF_NEW_OLD}.txt
}

#Отправка broadcast'а для того что бы дернуть сервис  abox.store.client
 send_broadcast_store_client(){
      echo "Broadcast for abox.store.client already send"
      adb shell am broadcast -a abox.store.client.ACTION_START -n abox.store.client/.receiver.StoreBroadcastReceiver
}


uninstall_diff_apk(){
            echo "Удаление списка приложений  от обновленного к предыдущему состоянию:"
            diff -E -b -B -w  ${APPCUR} ${APPDEF} | grep "<" | sed -e 's/^[ <]*//' > ${TEMP_DIFF_NEW_OLD}
              for APK in $(cat ${TEMP_DIFF_NEW_OLD}); do
              echo "Uninstalling apk ${APK}"
            adb uninstall ${APK}
  done
}


#Удаление списка приложений
uninstall_pack_apk(){
    for APK in $(cat ${MODULES_UNINSTALL}); do
            echo "Uninstalling apk ${APK}"
            adb shell pm uninstall -k ${APK} 2> /dev/null
            if [ $? -ne 0 ] ; then
        echo "Failed to unistall ${APK}"
    fi

    done
}

########################################
clear_data() {
    adb shell pm clear "${PKG}"
}

#Чтение версии приложения из apk
readfromapkversion() {
 #  APK_VERSION=$(date +%Y%m%d)
 cat /dev/null >|${MODULES_UNINSTALL}
 for INP in  $(ls -f *.apk );do
 #     APK_VERSION=$(aapt dump badging ${INP} | sed -n "s/.*versionName='\([^']*\).*/\1/p")
      APK_VERSION=$(aapt dump badging ${INP} | sed -n "s/.*package: name='\([^']*\).*/\1/p")
      echo "${APK_VERSION}" >> ${MODULES_UNINSTALL}
      echo " ${INP} : ${APK_VERSION}"
done
}

#шум
shum(){
	echo "#################################################################################################################################################################"

}

find_on_android() {
    echo -n "Поиск на устройстве по заданному слову через busybox(*.apk)     :"
    read FD
 #    adb shell /system/bin/busybox find / -name "*${FD:=*.apk}*" |grep -v "Permission denied"
 #    adb shell /system/bin/busybox find / -name "*${FD:=*.apk}*" 2>/dev/null
    adb shell find / -name "*${FD:=*.apk}*" >${MODULES_UNINSTALL} 2>/dev/null
}

disconnect() {
    adb disconnect 2> /dev/null 1> /dev/null
     echo "Disconnect "
}

monitor(){
    for IPS in ${IP}; do
            adb disconnect 2> /dev/null 1> /dev/null
            echo ""
            timeout 2 adb connect ${IPS}:5555 2> /dev/null 1> /dev/null
            if [ $? -ne 0 ] ; then
		echo "Failed to connect ${IPS}"
	    fi
 #	    	echo -n "Connected to ${IPS}"
    ##########
 sleep 1
 APP_APK=$(adb shell dumpsys package abox.store.client | grep -i versionName | awk -F"=" '{print $2}'|sed -n 1p |tr -d '\n' )
 APP_VERS=$(adb shell getprop |grep sys.wildred.hw_id | tr -d '\n' )
 echo -n "ip-address : ${IPS} "
 sleep 1
 echo -n "abox.store.client : ${APP_APK} "
 sleep 1
 echo  -n "HWID : ${APP_VERS} "
 sleep 1
     done
    adb disconnect 2> /dev/null 1> /dev/null

}

connect_more_ip(){
   for IPS in ${IP}; do
            disconnect
            shum
            echo "Try connect to ${IPS}"
            sleep 1
            connect${IPS} 2> /dev/null 1> /dev/null
            sleep 1
            if [ $? -ne 0 ] ; then
        echo "Failed to connect ${IPS}"
    fi
    echo "Success"
    done
}


#-------------------------------MAIN-----------------------------------------------------


 if [[ "${@}" == *"${K_HELP}"* ]]; then
	showHelp
	exit 0
 fi

 for arg in "$@"; do
	  case ${arg} in
	    ${K_GET_IP})
	         get_ip
	         shift 1
	          ;;
	    ${K_NEW_DAY})
	    	 new_day
	    	 shift 1
	    	  ;;
        ${K_WIFI})
             wifi
             shift 1
              ;;
        ${K_DPI})
              dpi
              shift 1
              ;;
        ${K_PROSHIVOCHKA})
             proshivochka
             shift 1
              ;;
	    ${K_PROVERKA})
	         proverka
	         shift 1
	          ;;
	    ${K_CHECKB})
	    	 checkb
	    	 shift 1
	    	  ;;
	    ${K_MONKEY_FON})
	    	 monkey_fon
	    	 shift 1
	    	  ;;
	    ${K_MONKEY_RESULT})
	    	 monkey_result
	    	 shift 1
	    	  ;;
	    ${K_TETS_FUN})
	         test_fun
	         shift 1
	          ;;
	    ${K_CONNECT})
	         connect
	    	 shift 1
	    	  ;;
	    ${K_BIG_BAD_MONKEY})
	    	 big_bad_monkey
	    	 shift 1
	    	  ;;
	    ${K_DISCONNECT})
	         disconnect
	         shift 1
	          ;;
        ${K_ALL_STORE_TEST})
             all_store_test
             shift 1
              ;;
        ${K_CONNECT2ALL_SEND_BROADCAST})
             connect2all_send_broadcast
             shift 1
              ;;
        ${K_UNINST})
             uninstall_apk
             shift 1
              ;;
        ${K_UNINST_DIFF})
             uninstall_pack_apk
             shift 1
               ;;
        ${K_INSTALL_PAK})
             install_pack_apk
             shift 1
              ;;
        ${K_UNINST_PAK})
             uninstall_pack_apk
             shift 1
              ;;
        ${K_SEND})
             send_broadcast_store_client
             shift 1
              ;;
        ${K_GETPROP})
             getprop
             shift 1
              ;;
        ${K_STOP_APP})
             stop_app
             shift 1
              ;;
        ${K_LOGCAT})
             get_logcat
             shift 1
              ;;
	    ${K_OPEN_FACT})
             open_factory
             shift 1
              ;;
        ${K_SCREEN})
             screen
             shift 1
              ;;
        ${K_GET_NAME})
             get_app_name
             shift 1
              ;;
        ${K_GET_VERS})
             get_app_name_version
             shift 1
              ;;
        ${K_RFAV})
             readfromapkversion
             shift 1
              ;;
        ${K_DIFF_VERSION})
             check_apps_version_vs
             shift 1
              ;;
        ${K_CLEAR_DATA})
             clear_data
             shift 1
              ;;
        ${K_MONKEY})
             monkey_test
             shift 1
              ;;
        ${K_FIND})
             find_on_android
             shift 1
              ;;
	    *)
 #	      >&2
	      echo "Unknown argument: $arg"
	      exit 1
	      ;;
	  esac
done
