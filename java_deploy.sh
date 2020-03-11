#GITHUB此代码仅供技术面试官参考，脚本已清洗敏感数据。
#!/bin/bash
. global.p

_cdate=`date +%F`
_version='1.0.0.0'
_date=`date +%m%d%H%M`
path=`pwd`
_passwd="test"
cd $path
if [ -d log ];then
rm -fr log/*
elif [ -f log ];then
rm -fr log
mkdir log
else
mkdir log
fi
#######################判断脚本的版本号##########################
 while getopts vp name;do
    case $name in
        v)
        echo ${_version}
        exit 0
        ;;
        p)
        #pro=$OPTARG
        pro='yl_java.p'
        cat $pro | more
        exit 0
        ;;
        *)
        echo "usage:$0 -[v p]"
        exit 1
        ;;
        esac
done
##########################################设置密码################################################
java_passwd(){
stt=`stty -g`
for (( i=1;i<=3;i++ ));do
stty -echo 
read -p "please input script password：" passwd
stty $stt
echo
if [ "$passwd" = "${_passwd}" ];then
echo -e "\e[32;1mThe passwords match!\e[0m"
break
else
echo -e "\e[31;1mThe passwords you entered do not match!\e[0m"
fi
done

if [ "$passwd" != "$_passwd" ];then
exit
fi
}
#java_passwd

################################定义变量函数############################################
java_func()
{
eval java_ips_num='$'${env}${yl_java}'_ips_num'
eval java_ips='(''$'{${env}${yl_java}'_ips'[*]}')'
eval java_directories_num='$'${env}${yl_java}'_directories_num'
eval java_install_directories='(''$'{${env}${yl_java}'_install_directories'[*]}')'
eval java_start_directories='(''$'{${env}${yl_java}'_start_directories'[*]}')'
eval java_start_port='(''$'{${env}${yl_java}'_start_port'[*]}')'
eval java_username='$'${env}${yl_java}'_username'
eval java_process_name='$'${env}${yl_java}'_process_name'
#eval java_oldversion='$'${yl_java}'_oldversion'
#eval java_newversion='$'${yl_java}'_newversion'
#eval java_version_file='$'${yl_java}'_version_file'
}


##############################java服务判断#############################################
java_ips_pd()
{
#echo ${#java_ips[*]}
if [ "$java_ips_num" != "${#java_ips[*]}" ];then
echo -e "\e[31;1merror: 配置文件中，${game_c}_ips参数和${game_c}_ips_num参数不一致\e[0m"
exit
fi
for  i in `echo ${java_ips[*]}`; do
java_ip1=`echo "$i" | egrep '^(25[0-5]?[0-9])$'`
#echo $i
ping -c2 $i &>/dev/null
if [ $? = 0 ] && [ "$java_ip1" = "$i" ]; then
echo -e "$java_process_name服务的ip：$i			[\e[32;1m符合ip规则并连通性正常！\e[0m]" 
else
echo -en "$java_process_name服务的ip：$i"
echo -en "\e[60G" 
echo -en "[\e[31;1m不符合ip规则或无法连通！\e[0m]"
echo
exit 1
fi
done
}

java_dir_port_pd()
{
#判断java_directories_num、java_install_directories、java_start_directories、java_start_port参数
if [ "$java_directories_num" 
echo -e "\e[31;1merror: 请检查配置文件中
exit 1
fi
#判断java_dir_port
if [ "${#java_install_directories[*]}"
echo -e "\e[31;1merror: 请检查配置文件中，
exit 1
fi
#判断tomcat目录和端口是否存在
for (( i=0;i<$java_ips_num;i++ ));do
for (( y=0;y<$java_directories_num;y++ ));do
_install_directories=`echo ${java_install_directories[$y]}`
_start_directories=`echo ${java_start_directories[$y]}`
if [ "${_install_directories%/*}" != "${_start_directories%/*}" ];then
echo -e "\e[31;1merror: 配置文件中，${yl_java}_install_directories参数
fi
ssh -p 17822 $java_username@${java_ips[$i]} <<eof >log/${yl_java}_directories_pd.log 2>/dev/null
find ${_install_directories%/*} -name ${_install_directories##*/} |wc -l
exit 
eof
cat log/${yl_java}_directories_pd.log | grep -v from | grep ^1 >/dev/null ||
if [ `echo $?` -eq 1 ];then
echo -e "\e[31;1merror: ${java_install_directories[$y]}
fi

ssh -p 17822 $java_username@${java_ips[$i]} <<eof >log/${yl_java}_port_pd.log 2>/dev/null
cat ${java_install_directories[$y]}/../conf/server.xml |grep \"${java_start_port[$y]}\" | wc -l 
exit 
eof
cat log/${yl_java}_port_pd.log | grep -v from | grep ^0 >/dev/null |
if [ `echo $?` -eq 0 ];then
echo -en "$java_process_name服务的ip：${java_ips[$i]}"
echo -en "\e[60G"
echo -en "\e[31;1merror: ${java_start_port[$y]}端口不存在
exit 1
fi
done
done
}

#####计时函数############
timer()
{
n=0
sum=300
echo -en "\e[32;1m等待时间为:    "
while :;do
sy=$(( $sum-$n ))
if [ $sy -lt 100 ] && [ $sy -ge 10 ];then
sy=`echo "0$sy"`
elif [ $sy -lt 10 ];then
sy=`echo "00$sy"`
fi
echo -ne "\b\b\b\b${sy}s"
sleep 1
n=$(( n+1 ))
if [ $n -ge $sum ];then
break
fi
done
echo -en "\e[0m"
#echo
echo -e "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\e[32;1mjava服务没有ESTABLISHED状态\e[0m"
}


#################################################java服务停服操作############################################
java_stop()
{
for (( y=0;y<${java_ips_num};y++ ));do
for (( i=0;i<${java_directories_num};i++ ));do
###judge java established status close
echo -e "\e[32;1m正在检测java服务的ESTABLISHED状态，请等待。。。\e[0m"
#timer #等待300s
echo -e "\e[32;1mjava服务没有ESTABLISHED状态\e[0m"
sleep 1
##判断tomcat进程是否存在
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_process_shutdown.log 2>/dev/null
ps -ef|grep ${java_start_directories[$i]} | grep -v grep |wc -l
exit
eof
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep ^1|wc -l`
if [ $result -eq 0 ];then
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep [\$\ ]1|wc -l`
fi
##判断端口是否存在
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_shutdown.log 2>/dev/null
netstat -antp|grep \:${java_start_port[$i]}\  | grep LISTEN |wc -l
exit
eof
cat log/${yl_java}_shutdown.log | grep -v from | grep ^1 >/dev/null || cat log/${yl_java}_shutdown.log 
if [ `echo $?` -eq 0 ] || [ $result -eq 1 ];then
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >>/dev/null 2>>/dev/null
cd ${java_start_directories[$i]}
./shutdown.sh
cd ${java_install_directories[$i]%/*}
rm -fr work/* logs/catalina.*
exit
eof
sleep 1
##判断tomcat进程是否停止
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_process_shutdown.log 2>/dev/null
ps -ef|grep ${java_start_directories[$i]} | grep -v grep |wc -l
exit
eof
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep ^1|wc -l`
if [ $result -eq 0 ];then
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep [\$\ ]1|wc -l`
fi
if [ $result -eq 1 ];then
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >>/dev/null 2>>/dev/null
cd ${java_start_directories[$i]}
./shutdown.sh
cd ${java_install_directories[$i]%/*}
rm -fr work/* logs/catalina.*
exit
eof
fi
sleep 1
##判断tomcat进程是否存在
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_process_shutdown.log 2>/dev/null
ps -ef|grep ${java_start_directories[$i]} | grep -v grep |wc -l
exit
eof
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep ^1|wc -l`
if [ $result -eq 0 ];then
result=`cat log/${yl_java}_process_shutdown.log | grep -v from | grep [\$\ ]1|wc -l`
fi
##判断端口是否存在
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_shutdown.log 2>/dev/null
netstat -antp | grep \:${java_start_port[$i]}\  | grep LISTEN |wc -l
exit
eof
cat log/${yl_java}_shutdown.log | grep -v from | grep ^1 >/dev/null |
if [ `echo $?` -eq 1 ] && [ $result -eq 0 ];then
echo "${java_ips[$y]}"
echo -en "${env}$java_process_name"                             
echo -en "\e[60G"
echo -en "[\e[32;1m停止\e[0m]"
echo
 else
echo "${java_ips[$y]}"
echo -en "${env}$java_process_name"                            
echo -en "\e[60G" 
echo -en "[\e[31;1m无法停止\e[0m]"
echo
 fi
else
echo "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[33;1m已停止\e[0m]"
echo
fi
 done
done
}

###################################备份java服务程序#####################################
java_backup()
{
#判断java服务的app目录和服务程序是否存在
if [ ! -d ${java_app_dir} ];then
echo -e "\e[31;1merror: 没有$java_app_dir 目录，无法进行备份和替换！\e[0m"
exit 1
fi
if [ ! -f ${java_app_dir}/${java_process_name}.tar.gz ];then
echo -e "\e[31;1merror: 
fi
rm -fr $path/app/${java_process_name}
tar fvxz ${java_app_dir}/${java_process_name}.tar.gz -C $path/app/ >>/dev/null
if [ ! -e app/${java_process_name} ];then
echo -e "\e[31;1merror: 在app目录下
fi

for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
#java服务目录是否存在
#ssh -p 17822 $java_username'@'${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
#find ${java_install_directories[$i]} -name $java_process_name -type d |wc -l
#exit 
#eof
#if [ `cat log/${yl_java}_backup.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 1 ]
#exit 1
#fi
#判断java服务是否停止
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
netstat -antp|grep \:${java_start_port[$i]}\  | grep LISTEN |wc -l
exit
eof
cat log/${yl_java}_backup.log | grep -v from | grep ^1 >/dev/null || cat log/${yl_java}_backup.log
if [ `echo $?` -eq 0 ];then
echo -e "\e[31;1merror: 在${java_ips[$y]}的${java_process_name}服务没有停止，无法进行备份和替换\e[0m"
exit 1
fi
#备份操作
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${java_install_directories[$i]}
find ./ -name ${java_process_name}.${_cdate}_\*.tar.gz|wc -l
eof
_bak_sum=`cat log/${yl_java}_backup.log | grep -v from | grep ^[1-9]\*`

ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${java_install_directories[$i]}
find ./ -name ${java_process_name}.${_cdate}_\*.tar.gz|sort -n -r|head -n 1
eof

_bak=`cat log/${yl_java}_backup.log | grep -v from | grep ^./${java_process_name}`
#_bak_num=`echo ${_bak##*/}|awk -F'_' '{print $2}'|awk -F. '{print $1}'` 
_bak_num=`echo ${_bak##*/}|awk -F'-' '{print $3}'|awk -F. '{print $1}'|awk -F_ '{print $2}'` 

#echo ${_bak##*/},${_bak_sum},$_bak_num
if [[ ${_bak_sum} -eq 0 ]];then
_bak_num=1
else
_bak_num=$((_bak_num+1))
fi

ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${java_install_directories[$i]}
echo ${_bak_sum}--------${_bak}-------${_bak_num}-------------${_cdate}
tar fcz ${java_process_name}.${_cdate}_${_bak_num}.tar.gz ${java_process_name}
exit
eof

ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
find ${java_install_directories[$i]} -name ${java_process_name}.${_cdate}_${_bak_num}.tar.gz |wc -l
exit 
eof
if [ `cat log/${yl_java}_backup.log | grep -v from | grep [\$\ ]1 |wc -l` -eq 1 ]
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[32;1m备份成功\e[0m]" 
echo
else
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[31;1m备份失败\e[0m]" 
echo
exit
fi
 done
done
}
##################################替换java服务程序#####################################
java_replace()
{
#tar fvxz app/${java_process_name}.${java_newversion}.tar.gz -C app/ 
for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
ssh -p 17822 $java_username@${java_ips[$y]} <<eof  >log/${yl_java}_replace.log 2>/dev/null
cd ${java_install_directories[$i]}
rm -fr ${java_process_name}
eof
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_replace.log 2>/dev/null
find ${java_install_directories[$i]} -name ${java_process_name} -type d | wc -l
eof
if [ `cat log/${yl_java}_replace.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ]
echo -e "${java_ips[$y]}"
echo -e "\e[31;1merror:删除旧$java_process_name服务失败\e[0m" 
exit
fi
 done
done 
for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
scp -P 17822 -r app/${java_process_name} $java_username@${java_ips[$y]}
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_replace.log 2>/dev/null
find ${java_install_directories[$i]} -name $java_process_name -type d | wc -l
exit 
eof
if [ `cat log/${yl_java}_replace.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ] 
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[32;1m替换成功\e[0m]" 
echo
else
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[31;1m替换失败\e[0m]" 
echo
exit
fi
 done
done
}


################################################java服务回退操作############################################
java_rollback(){
echo -en "\e[33;1m请输入回退的日期:\e[0m"
read input_date
echo -en "\e[33;1m请输入回退的版本号:\e[0m"
read ver
for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
ssh -p 17822 $java_username@${java_ips[$y]} <<eof  >log/${yl_java}_rollback.log 2>/dev/null
cd ${java_install_directories[$i]}
find ${java_install_directories[$i]} -name ${java_process_name}.${input_date}_${ver}.tar.gz
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]1 |wc -l` -eq 0 ] 
echo -e "${java_ips[$y]}"
echo -e "\e[31;1merror:${java_process_name}.${input_date}_${ver}.tar.gz回退包不存在!\e[0m" 
exit
fi

ssh -p 17822 $java_username@${java_ips[$y]} <<eof  >log/${yl_java}_rollback.log 2>/dev/null
cd ${java_install_directories[$i]}
rm -fr ${java_process_name}
eof
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_rollback.log 2>/dev/null
find ${java_install_directories[$i]} -name ${java_process_name} -type d | wc -l
eof
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ] 
echo -e "${java_ips[$y]}"
echo -e "\e[31;1merror:删除新$java_process_name服务失败\e[0m" 
exit
fi
 done
done
for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
#scp -P 17822 -r app/${java_process_name} $java_username@${java_ips[$y]}
cd ${java_install_directories[$i]}
tar fxz ${java_process_name}.${input_date}_${ver}.tar.gz ${java_process_name}
find ${java_install_directories[$i]} -name $java_process_name -type d | wc -l
exit 
eof
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ]
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[32;1m回退成功\e[0m]" 
echo
else
echo -e "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[31;1m回退失败\e[0m]" 
echo
exit
fi
 done
done

}


################################################java服务启服操作############################################
java_start()
{
for (( y=0;y<$java_ips_num;y++ ));do
  for (( i=0;i<$java_directories_num;i++ ));do
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_startup.log 2>/dev/null
netstat -antp|grep :${java_start_port[$i]}\  | grep LISTEN |wc -l
exit
eof
cat log/${yl_java}_startup.log | grep -v from | grep ^0 >/dev/null |
if [ `echo $?` -eq 0 ];then
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >/dev/null 2>/dev/null
cd $java_start_directories
./startup.sh
exit
eof
sleep 4
ssh -p 17822 $java_username@${java_ips[$y]} <<eof >log/${yl_java}_startup.log 2>/dev/null
netstat -antp|grep :${java_start_port[$i]}\  | grep LISTEN | wc -l
exit
eof
cat log/${yl_java}_startup.log | grep -v from | grep ^0 >/dev/null |
        if [ `echo $?` -eq 1 ];then
        echo "${java_ips[$y]}"
        echo -en "${env}$java_process_name"                               
        echo -en "\e[60G"
        echo -en "[\e[32;1m启动\e[0m]"
        echo
        else
        echo "${java_ips[$y]}"
        echo -en "\e[31;1merror:\e[0m ${env}$java_process_name"                  
        echo -en "\e[60G"
        echo -en "[\e[31;1m无法启动\e[0m]"
        echo
        fi
else
echo "${java_ips[$y]}"
echo -en "${env}$java_process_name"
echo -en "\e[60G"
echo -en "[\e[33;1m已启动\e[0m]"
echo
fi
 done
done
}
##########################################################主函数##############################################
main_stop()
{
java_func
java_ips_pd
java_dir_port_pd
java_stop
}
main_start()
{
java_func
java_ips_pd
java_dir_port_pd
java_start
}


main_bak_rep()
{
if [[ $env == 'backup_' ]];then
java_func
java_ips_pd
java_dir_port_pd
java_stop
java_backup
java_replace
else
java_func
java_ips_pd
java_dir_port_pd
java_stop
java_backup
java_replace
java_start
fi
}

main_rollback()
{
if [[ $env == 'backup_' ]];then
java_func
java_ips_pd
java_dir_port_pd
java_stop
java_rollback
else
java_func
java_ips_pd
java_dir_port_pd
java_stop
java_rollback
java_start
fi
}

##############################################判断java菜单####################################################

if [[ $1 == 'main' ]];then
env=main_
elif [[ $1 == 'test' ]];then
env=test_
elif [[ $1 == 'backup' ]];then
env=backup_
elif [[ $1 == 'single' ]];then
env=single_
elif [[ $1 == 'jar' ]];then
env=jar_
else
echo -e "\e[31;1merror:please input first right parament!\e[0m"
exit 1
fi


#if [[ $2 == 'front.onigiri' ]];then
#yl_java=front
#elif [[ $2 == 'customer.onigiri' ]];then
#yl_java=customer
#elif [[ $2 == 'batch.onigiri' ]];then
#yl_java=batch
#elif [[ $2 == 'bgfront.onigiri' ]];then
#yl_java=bgfront
#elif [[ $2 == 'manage.onigiri' ]];then
#yl_java=manage
#elif [[ $2 == 'app.onigiri' ]];then
#yl_java=app
#else
#echo -e "\e[31;1merror:please input second right parament!\e[0m"
#exit 1
#fi

total_deploy_array=(${slb_deploy_array[*]} ${mb_deploy_array[*]} ${single_deploy_array[*]})
slb_val=`echo "${total_deploy_array[*]}"|grep -wq "$2" && echo "slb"`
if [[ $slb_val == 'slb' ]];then
        yl_java=`echo "$2"|tr '.' '_'`
else
        echo -e "\e[31;1merror:please input second right parament!\e[0m"
fi


if [[ $3 == 'main_stop' ]];then
main_stop
elif [[ $3 == 'main_start' ]];then
main_start
elif [[ $3 == 'main_bak_rep' ]];then
main_bak_rep
elif [[ $3 == 'main_rollback' ]];then
main_rollback
else
echo -e "\e[31;1merror:please input third right parament!\e[0m"
exit 1
fi

