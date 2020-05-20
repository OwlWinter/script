#!/bin/bash

# Author owlwinter
#
# 必须的参数：$1
# 指令 start/stop
#
# 必须的参数：$2
# jetty 安装路径
#
# 参数：$3
# war 包路径
#

OPTION=$1
JETTY_HOME=$2
WAR_PATH=$3

case $OPTION in
	stop) echo "close jetty..."
	pid=`ps aux |grep jetty | grep -v grep | grep ${JETTY_HOME} | awk '{printf $2}'`

	if [ -n "${pid}" ]; then
		echo "====JETTY : shutdown.sh===="
		exec ${JETTY_HOME}/bin/jetty.sh stop
		sleep 4
		pid=`ps aux |grep jetty | grep -v grep | grep ${JETTY_HOME} | awk '{printf $2}'` 
		if [ -n "${pid}" ]; then
			echo "==========kill jetty============"
			kill -9 ${pid}
		fi
	fi
	;;
	
	start) echo "satrt jetty..."
	exec ${JETTY_HOME}/bin/jetty.sh start
	;;
	
	clean) echo -e "\nclean jetty webapps.."
	if [ -d "${JETTY_HOME}/webapps" ]
	then
		echo "===========rebuild webapps============"
		echo -n "rm ${JETTY_HOME}/webapps/"
		echo `ls ${JETTY_HOME}/webapps/`
		rm -rf ${JETTY_HOME}/webapps/*  
	fi
	;;
	
	deploy) echo -e "\ndeploy to jetty.."
	cp $WAR_PATH ${JETTY_HOME}/webapps/
	cd ${JETTY_HOME}/webapps
	
	# 生成项目配置文件
	FILE_NAME=`ls`
	XML_NAME=${FILE_NAME%%.*}.xml
	echo "create file: ${XML_NAME}"
	
	cat > ${XML_NAME} << END_FILE
<?xml version="1.0"  encoding="UTF-8"?>
<!DOCTYPE Configure PUBLIC "-//Jetty//Configure//EN" "http://www.eclipse.org/jetty/configure_9_0.dtd">

<Configure class="org.eclipse.jetty.webapp.WebAppContext">
    <Set name="contextPath">/</Set>
    <Set name="war">${JETTY_HOME}/webapps/${FILE_NAME}</Set>
</Configure>
	
END_FILE
	;;
	
	*) echo "Err Args For jettyController"
	exit 1
	;;
esac