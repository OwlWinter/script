# script
慢慢完善一个自用部署脚本


deploy.sh 用于控制主流程   
使用前需要补充一些信息: JAVA_HOME TOMCAT_HOME JETTY_HOME RESIN_HOME
使用示例：   

```
chmod +x ./deploy.sh
chmod +x ./jettyController.sh
./deploy.sh jetty /root/myProject.war
```   

tomcatController.sh 
tomcat 的附属控制脚本，一般不需要修改，除非想更改发布项目的方法

发布流程：
清空 tomcat 下的 webapps 文件夹
并且把 myProject.war 文件复制到 webapps/ROOT/ 文件夹下解压
然后删除 war 文件

jettyController.sh
jetty 的附属控制脚本
发布流程：
清空 jetty 的 webapps 文件夹
把 war 包复制过来并且生成一个同名 xml 配置文件

resinController.sh
resin 的附属控制脚本
发布流通与 tomcat 脚本相同。
