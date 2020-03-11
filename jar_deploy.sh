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




jar_func()
{
eval jar_ips_num='$'${env}${yl_java}'_ips_num'
eval jar_ips='(''$'{${env}${yl_java}'_ips'[*]}')'
eval jar_directories_num='$'${env}${yl_java}'_directories_num'
eval jar_install_directories='(''$'{${env}${yl_java}'_install_directories'[*]}')'
eval jar_back_directories='$'${env}${yl_java}'_back_directories'
eval jar_start_directories='(''$'{${env}${yl_java}'_start_directories'[*]}')'
#eval jar_start_port='(''$'{${env}${yl_java}'_start_port'[*]}')'
eval jar_username='$'${env}${yl_java}'_username'
eval jar_process_name='(''$'{${env}${yl_java}'_process_name'[*]}')'
xf_process_name=($xf_process_name)

}



##############################jar服务判断#############################################
jar_ips_pd()
{
if [ "$jar_ips_num" != "${#jar_ips[*]}" ];then
echo -e "\e[31;1merror: 
fi
for  i in `echo ${jar_ips[*]}`; do
jar_ip1=`echo "$i" | egrep '^(25[0-5][0-9])$'`
#echo $i
ping -c2 $i &>/dev/null
if [ $? = 0 ] && [ "$jar_ip1" = "$i" ]; then
echo -e "${jar_process_name[0]}服务的ip：$i                   
echo -en "${jar_process_name[0]}服务的ip：$i"
echo -en "\e[60G" 
echo -en "[\e[31;1m不符合ip规则或无法连通！\e[0m]"
echo
exit 1
fi
done
}

jar_dir_port_pd()
{
#判断jar_directories_num、jar_install_directories参数
if [ "$jar_directories_num" != "${#jar_install_directories[*]}" ];
fi
}

sub_pro_pd()
{
if [ ${sub_pro[0]} -eq 0 ] || [[ $yl_java == 'lib' ]];then
eval sub_pro1='('${xf_process_name[*]:1}')'
else
sub_pro1=()
for s in ${sub_pro[*]};do
sub_pro1+=(${xf_process_name[$s]})
done
fi

}

sub_pro_pd2()
{
if [ ${sub_pro[0]} -eq 0 ];then
eval sub_pro1='('${jar_process_name[*]:1}')'
else
sub_pro1=()
for s in ${sub_pro[*]};do
sub_pro1+=(${jar_process_name[$s]})
done
fi

}



#################################################jar服务停服操作############################################

jar_stop()
{
sub_pro_pd
for (( y=0;y<${jar_ips_num};y++ ));do
echo -e "\e[32;1m${jar_ips[$y]}\e[0m"
for (( i=0;i<${jar_directories_num};i++ ));do
for j in ${sub_pro1[*]} ;do
###judge java established status close
#sleep 1
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_shutdown.log 2>/dev/null
ps -ef | grep $j |grep -v grep|wc -l
exit
eof
cat log/${yl_java}_shutdown.log | grep -v from | grep ^1 >/dev/null
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >>/dev/null 2>>/dev/null
cd ${jar_start_directories[$i]}
ps -ef|grep $j|grep -v grep|cut -c 9-15|xargs kill -9
eof
#sleep 1
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_shutdown.log 2>/dev/null
ps -ef | grep $j |grep -v grep|wc -l
exit
eof
cat log/${yl_java}_shutdown.log | grep -v from | grep ^1 >/dev/null
#echo "${jar_ips[$y]}"
echo -en "$j"                             
echo -en "\e[60G"
echo -en "[\e[32;1m停止\e[0m]"
echo
 else
#echo "${jar_ips[$y]}"
echo -en "$j"                            
echo -en "\e[60G" 
echo -en "[\e[31;1m无法停止\e[0m]"
echo
 fi
else
#echo "${jar_ips[$y]}"
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[33;1m已停止\e[0m]"
echo
fi
  done
 done
done
}

###################################备份jar服务程序#####################################
jar_backup()
{
sub_pro_pd2
#判断jar服务的app目录和服务程序是否存在
if [ ! -d ${java_app_dir} ];then
echo -e "\e[31;1merror: 没有$java_app_dir 目录，无法进行备份和替换！\e[0m"
exit 1
fi
for j in ${sub_pro1[*]};do
if [ ! -f ${java_app_dir}/$j ];then
echo -e "\e[31;1merror: 在app目录下，没有$j服务包，无法进行备份和替换！\e[0m"
exit 1
fi
done

for (( y=0;y<$jar_ips_num;y++ ));do
#echo ${jar_ips[$y]}
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >/dev/null 2>&1
if [ ! -d $jar_back_directories ];then
mkdir -p $jar_back_directories
fi
exit
eof
  for (( i=0;i<$jar_directories_num;i++ ));do
     echo -e "\e[32;1m${jar_ips[$y]}\e[0m"
     for j in ${sub_pro1[*]};do
#判断jar服务是否停止
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
ps -ef | grep $j |grep -v grep|wc -l
exit
eof
cat log/${yl_java}_backup.log | grep -v from | grep ^1 >/dev/null
echo -e "\e[31;1merror: 在${jar_ips[$y]}的$j服务没有停止，无法进行备份和替换\e[0m"
exit 1
fi
#备份操作
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${jar_back_directories}
find ./ -name ${j}_${_cdate}_\*|wc -l
eof
_bak_sum=`cat log/${yl_java}_backup.log | grep -v from | grep ^[1-9]\*`

ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${jar_back_directories}
find ./ -name ${j}_${_cdate}_\*|sort -n -r|head -n 1
eof

_bak=`cat log/${yl_java}_backup.log | grep -v from | grep ^./$j`
_bak_num=`echo ${_bak##*/}|awk -F'_' '{print $3}'|awk -F. '{print $1}'`

if [[ ${_bak_sum} -eq 0 ]];then
_bak_num=1
else
_bak_num=$((_bak_num+1))
fi
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
cd ${jar_install_directories[$i]}
echo ${_bak_sum}--------${_bak}-------${_bak_num}-------------${_cdate}
cp $j ${jar_back_directories}/${j}_${_cdate}_${_bak_num} 
exit
eof
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_backup.log 2>/dev/null
find ${jar_back_directories} -name ${j}_${_cdate}_${_bak_num} |wc -l
exit 
eof
if [ `cat log/${yl_java}_backup.log | grep -v from | grep [\$\ ]1 |wc -l` -eq 1 ]
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[32;1m备份成功\e[0m]" 
echo
else
#echo -e "${jar_ips[$y]}"
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[31;1m备份失败\e[0m]" 
echo
exit
fi
   done
 done
done
}

##################################替换jar服务程序#####################################
jar_replace()
{
sub_pro_pd2
#tar fvxz app/${java_process_name}.${java_newversion}.tar.gz -C app/ 
for (( y=0;y<$jar_ips_num;y++ ));do
  for (( i=0;i<$jar_directories_num;i++ ));do
    for j in ${sub_pro1[*]};do
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof  >log/${yl_java}_replace.log 2>/dev/null
cd ${jar_install_directories[$i]}
rm -fr $j
eof
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_replace.log 2>/dev/null
find ${jar_install_directories[$i]} -name $j -type f | wc -l
eof
if [ `cat log/${yl_java}_replace.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ]
echo -e "\e[31;1merror:删除旧$j服务失败\e[0m" 
exit
fi
  done
 done
done
for (( y=0;y<$jar_ips_num;y++ ));do
  echo -e "\e[32;1m${jar_ips[$y]}\e[0m"
  for (( i=0;i<$jar_directories_num;i++ ));do
    for j in ${sub_pro1[*]};do
scp -P 17822 $java_app_dir/$j $jar_username@${jar_ips[$y]}:${jar_install_directories[$i]} >>/dev/null
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_replace.log 2>/dev/null
find ${jar_install_directories[$i]} -name $j -type f | wc -l
exit 
eof
if [ `cat log/${yl_java}_replace.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ]
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[32;1m替换成功\e[0m]" 
echo
else
#echo -e "${java_ips[$y]}"
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[31;1m替换失败\e[0m]" 
echo
exit
fi
  done
 done
done
}

################################################java服务回退操作############################################
jar_rollback(){
sub_pro_pd2
echo -en "\e[33;1m请输入回退的日期:\e[0m"
read input_date
echo -en "\e[33;1m请输入回退的版本号:\e[0m"
read ver
for (( y=0;y<$jar_ips_num;y++ ));do
  for (( i=0;i<$jar_directories_num;i++ ));do
    for j in ${sub_pro1[*]};do
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof  >log/${yl_java}_rollback.log 2>/dev/null
cd ${jar_back_directories}
find ${jar_back_directories} -name ${j}_${input_date}_${ver} -type f |wc -l
eof
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]1 |wc -l` -eq 0 ]
echo -e "\e[31;1merror:${j}_${input_date}_${ver}回退包不存在!\e[0m" 
exit
fi

ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof  >log/${yl_java}_rollback.log 2>/dev/null
cd ${jar_install_directories[$i]}
rm -fr $j
eof
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_rollback.log 2>/dev/null
find ${jar_install_directories[$i]} -name $j -type f | wc -l
eof
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ]
echo -e "\e[31;1merror:删除新$j服务失败\e[0m" 
exit
fi
  done
 done
done
for (( y=0;y<$jar_ips_num;y++ ));do
  echo -e "\e[32;1m${jar_ips[$y]}\e[0m"
  for (( i=0;i<$jar_directories_num;i++ ));do
    for j in ${sub_pro1[*]};do
#scp -P 17822 -r app/${java_process_name} $java_username@${java_ips[$y]}
cd ${jar_install_directories[$i]}
cp ${jar_back_directories}/${j}_${input_date}_${ver} $j
find ${jar_install_directories[$i]} -name $j -type f | wc -l
exit 
eof
if [ `cat log/${yl_java}_rollback.log | grep -v from | grep [\$\ ]0 |wc -l` -eq 0 ] 
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[32;1m回退成功\e[0m]" 
echo
else
#echo -e "${jar_ips[$y]}"
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[31;1m回退失败\e[0m]" 
echo
exit
fi
  done
 done
done
}

################################################java服务启服操作############################################
jar_start()
{
sub_pro_pd
for (( y=0;y<$jar_ips_num;y++ ));do
  echo -e "\e[32;1m${jar_ips[$y]}\e[0m"
  for (( i=0;i<$jar_directories_num;i++ ));do
    for j in ${sub_pro1[*]};do
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_startup.log 2>/dev/null
ps -ef | grep $j |grep -v grep|wc -l
exit
eof
cat log/${yl_java}_startup.log | grep -v from | grep ^0 >/dev/null |
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >/dev/null 2>/dev/null
cd ${jar_start_directories[$i]}
nohup java -jar -Xms${jar_mem}m -Xmx${jar_mem}m ${jar_start_directories[$i]}/$j
eof
#sleep 3
ssh -p 17822 $jar_username@${jar_ips[$y]} <<eof >log/${yl_java}_startup.log 2>/dev/null
ps -ef | grep $j |grep -v grep|wc -l
exit
eof
cat log/${yl_java}_startup.log | grep -v from | grep ^0 >/dev/null |
        #echo "${jar_ips[$y]}"
        echo -en "$j"                               
        echo -en "\e[60G"
        echo -en "[\e[32;1m启动\e[0m]"
        echo
        else
        #echo "${jar_ips[$y]}"
        echo -en "\e[31;1merror:\e[0m $j"                  
        echo -en "\e[60G"
        echo -en "[\e[31;1m无法启动\e[0m]"
        echo
        fi
else
#echo "${jar_ips[$y]}"
echo -en "$j"
echo -en "\e[60G"
echo -en "[\e[33;1m已启动\e[0m]"
echo
fi
  done
 done
done
}


###################################main########################

jar_bak_rep()
{
jar_stop
jar_backup
jar_replace
jar_start
}

main_jar_rollback()
{
jar_stop
jar_rollback
jar_start
}


#env=general_
#yl_java=jar
env=$1
yl_java=$2
jar_func
jar_ips_pd
jar_dir_port_pd
#jar_stop
if [[ $3 == 'jar_stop' ]];then
sub_pro=()
n=4
while :;do
eval s='$'$n
if [[ $s == '' ]];then
break
fi
sub_pro+=($s)
n=`echo $n+1|bc`
done
jar_stop
elif [[ $3 == 'jar_start' ]];then
sub_pro=()
n=4
while :;do
eval s='$'$n
if [[ $s == '' ]];then
break
fi
sub_pro+=($s)
n=`echo $n+1|bc`
done
jar_start
elif [[ $3 == 'jar_bak_rep' ]];then
sub_pro=()
n=4
while :;do
eval s='$'$n
if [[ $s == '' ]];then
break
fi
sub_pro+=($s)
n=`echo $n+1|bc`
done
jar_bak_rep
elif [[ $3 == 'jar_rollback' ]];then
sub_pro=()
n=4
while :;do
eval s='$'$n
if [[ $s == '' ]];then
break
fi
sub_pro+=($s)
n=`echo $n+1|bc`
done
main_jar_rollback
else
echo -e "\e[31;1merror:please input third right parament!\e[0m"
exit 1
fi

#./jar_deploy.sh general_ jar jar_stop  0
#./jar_deploy.sh general_ jar jar_stop  1 2 3
