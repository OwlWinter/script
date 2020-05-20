#!/bin/bash

# Author owlwinter
#
# 必须的参数：$1
# 指令 start/stop
#
# 必须的参数：$2
# tomcat 安装路径
#
# 参数：$3
# war 包路径
#
# 在运行前设定好 JAVA_HOME 与 TOMCAT_HOME

OPTION=$1
TOMCAT_HOME=$2
WAR_PATH=$3

case $OPTION in
	stop) echo -e "\nclose tomcat..."
	pid=`ps aux | grep tomcat | grep -v grep | grep -v deploy |grep ${TOMCAT_HOME}/bin | awk '{printf $2}'`

	if [ -n "${pid}" ]; then
		echo "=========TOMCAT : shutdown.sh========="
		${TOMCAT_HOME}/bin/shutdown.sh
		sleep 3
		pid=`ps aux |grep tomcat | grep -v grep | grep -v deploy | grep ${TOMCAT_HOME}/bin | awk '{printf $2}'` 
		if [ -n "${pid}" ]; then
			echo "==============kill tomcat============="
			kill -9 ${pid}
		fi
	fi
	;;
	
	start) echo "satrt tomcat..."
	exec ${TOMCAT_HOME}/bin/startup.sh
	;;
	
	clean) echo -e "\nclean tomcat webapps.."
	if [ -d "${TOMCAT_HOME}/webapps" ]
	then
		echo "===========rebuild webapps============"
		echo -n "rm ${TOMCAT_HOME}/webapps/"
		echo `ls ${TOMCAT_HOME}/webapps/`
		rm -rf ${TOMCAT_HOME}/webapps/*

		echo "mkdir ${TOMCAT_HOME}/webapps/ROOT"
		mkdir ${TOMCAT_HOME}/webapps/ROOT    
	fi
	;;
	
	deploy) echo -e "\ndeploy to tomcat.."
	cp $WAR_PATH ${TOMCAT_HOME}/webapps/ROOT/
	cd ${TOMCAT_HOME}/webapps/ROOT
	jar -xf ./*.war
	rm -rf ./*.war
	;;
	
	*) echo "Err Args For tomcatController"
	exit 1
	;;
esac