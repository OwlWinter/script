#!/bin/bash

# Author owlwinter
#
# 必须的参数：$1
# 指令 start/stop
#
# 必须的参数：$2
# resin 安装路径
#
# 参数：$3
# war 包路径
#
# 在运行前设定好 JAVA_HOME 与 RESIN_HOME

OPTION=$1
RESIN_HOME=$2
WAR_PATH=$3

case $OPTION in
	stop) echo -e "\nclose resin..."
	pid=`ps aux | grep resin | grep -v grep | grep Dresin.watchdog | awk '{printf $2}'`

	if [ -n "${pid}" ]; then
		echo "=========TOMCAT : shutdown.sh========="
		${RESIN_HOME}/bin/resinctl stop
		sleep 3
		pid=`ps aux | grep resin | grep -v grep | grep Dresin.watchdog | awk '{printf $2}'` 
		if [ -n "${pid}" ]; then
			echo "==============kill resin============="
			kill -9 ${pid}
		fi
	fi
	;;
	
	start) echo "satrt resin..."
	exec ${RESIN_HOME}/bin/resinctl start
	;;
	
	clean) echo -e "\nclean resin webapps.."
	if [ -d "${RESIN_HOME}/webapps" ]
	then
		echo "===========rebuild webapps============"
		echo -n "rm ${RESIN_HOME}/webapps/"
		echo `ls ${RESIN_HOME}/webapps/`
		rm -rf ${RESIN_HOME}/webapps/*

		echo "mkdir ${RESIN_HOME}/webapps/ROOT"
		mkdir ${RESIN_HOME}/webapps/ROOT    
	fi
	;;
	
	deploy) echo -e "\ndeploy to resin.."
	cp $WAR_PATH ${RESIN_HOME}/webapps/ROOT/
	cd ${RESIN_HOME}/webapps/ROOT
	jar -xf ./*.war
	rm -rf ./*.war
	;;
	
	*) echo "Err Args For resinController"
	exit 1
	;;
esac