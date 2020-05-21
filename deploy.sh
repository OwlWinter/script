#!/bin/bash

# Author owlwinter
#
# 必须的参数：$1
# 想要部署的容器名[jetty, tomcat, resin]
#
# 必须的参数：$2
# war 包的绝对路径
#
# 在运行前设定好 JAVA_HOME 与 TOMCAT_HOME

# ======================================
JAVA_HOME="/usr/local/java/jdk1.8.0_202"
TOMCAT_HOME="/usr/local/tomcat"
JETTY_HOME="/usr/local/jetty"
RESIN_HOME="/usr/local/resin"
# ======================================

SERVLET_NAME=${1^^}
SERVLET_HOME=home
WAR_PATH=$2
BIN=$(cd `dirname $0`;pwd)

readonly BIN
readonly SERVLET_NAME
readonly WAR_PATH
readonly TOMCAT_HOME
readonly JETTY_HOME
readonly RESIN_HOME
readonly JAVA_HOME


precheck()
{
echo "=============检查运行环境============="

# 检查将要部署的 war 包
if [ -s "$WAR_PATH" -a ! -d "$WAR_PATH" ]
then
    echo "部署目标文件：$WAR_PATH"
else
    echo "$WAR_PATH"
    echo "请检查文件路径"
    exit 1
fi

# 检查目标运行环境
echo "JAVA_HOME: ${JAVA_HOME:?"No JAVA_HOME!"}"
case $SERVLET_NAME in
	TOMCAT) echo "TOMCAT_HOME: ${TOMCAT_HOME:?"No TOMCAT_HOME!"}"
	SERVLET_HOME=${TOMCAT_HOME}
	;;
	JETTY) echo "JETTY_HOME: ${JETTY_HOME:?"No JETTY_HOME!"}"
	SERVLET_HOME=${JETTY_HOME}
	;;
	RESIN) echo "RESIN_HOME: ${RESIN_HOME:?"No RESIN_HOME!"}"
	SERVLET_HOME=${RESIN_HOME}
	;;
	*) echo "err args: $1"
	exit 1
	;;
esac

readonly SERVLET_HOME
}


clean_close()
{
${BIN}/${SERVLET_NAME,,}Controller.sh clean ${SERVLET_HOME} ${WAR_PATH}
${BIN}/${SERVLET_NAME,,}Controller.sh stop ${SERVLET_HOME} ${WAR_PATH}
}



deploy_war()
{
${BIN}/${SERVLET_NAME,,}Controller.sh deploy ${SERVLET_HOME} ${WAR_PATH}
${BIN}/${SERVLET_NAME,,}Controller.sh start ${SERVLET_HOME} ${WAR_PATH}
}

# main workflow
precheck
clean_close
deploy_war
