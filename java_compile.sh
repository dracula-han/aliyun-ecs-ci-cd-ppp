#GITHUB此代码仅供技术面试官参考，脚本已清洗敏感数据。
#!/bin/bash
. global.p
###define global variables
#home_dir="/opt/YL-Project"
#script_dir="/opt/YL-Project/auto_deploy"
#java_app_dir="/opt/YL-Project/app"

if [ ! -d ${script_dir}/logs ];then
mkdir logs
else
rm -fr ${script_dir}/logs/*
fi



################清除用户的svn保存的用户和密码###########
#rm -fr ~/.subversion/auth
sub1=`sed -n '/^store-passwords/ p' ~/.subversion/config | wc -l`
sub2=`sed -n '/^store-auth-creds/ p' ~/.subversion/config | wc -l`
if [ $sub1 -lt 1 ] || [ $sub2 -lt 1 ]; then
echo "store-passwords = no" >> ~/.subversion/config
echo "store-auth-creds = no" >> ~/.subversion/config
#sed -i '/store-passwords\ =\ no/ s/#//g' ~/.subversion/config
#sed -i '/store-auth-creds\ =\ no/ s/#//g' ~/.subversion/config
echo -e "\e[32;1m已清除svn的用户和密码的缓存，请继续。。。\e[0m"
fi

##########################static##############################
static_svn_code()
{
if [ ! -d ${home_dir}/$1 ];then
mkdir -p ${home_dir}/$1
echo -e "\e[32;1m下载$1资源。。。\e[0m"
cd ${home_dir}/$1
svn co --username $svn_username --password $svn_pass $static_svn_prefix_url
else
echo -e "\e[32;1m更新$1资源。。。\e[0m"
cd ${home_dir}/$1/$static_process_name
/usr/bin/svn update --username $svn_username --password $svn_pass ./
fi
chown -R www.www ${home_dir}/$1
}

static_rsync()
{
eval static_ips='('$static_ips')'
echo -e "\e[32;1m部署$1资源。。。\e[0m"
for s in ${static_ips[*]};do
	/usr/bin/rsync -avzP --password-file=${static_secrets}  
		printf "\e[1;32m${s} sync static is done.\e[m\n";
	else 
		echo -e "\e[1;31m${Php_Web[i]} sync static is fail.\e[m\n";
		exit 114;
	fi
done
}


#############################java code############################################
java_svn_code(){
if [ ! -d ${home_dir}/$1 ];then
echo -e "\e[32;1m下载$1源码。。。\e[0m"
cd ${home_dir}
svn co --username $svn_username --password $svn_pass $java_svn_url/$1 >>${script_dir}
else
echo -e "\e[32;1m更新$1源码。。。\e[0m"
cd ${home_dir}/$1
/usr/bin/svn update --username $svn_username --password $svn_pass ./
fi
}

java_compile(){

if [[ $1 == ${java_download_dir[0]} ]];then
	if [ ! -d ${java_app_dir} ];then
		mkdir -p ${java_app_dir}
	else
		rm -fr ${java_app_dir}/$2*
	fi
echo -e "\e[32;1m编译$2源码。。。\e[0m"
cd ${home_dir}/$1
mvn install >>${script_dir}/logs/java_compile.log
cd ${home_dir}/$1/$2
mvn install >>${script_dir}/logs/java_compile.log 2>&1 && mvn clean package -P $compile_env 

elif [[ $1 == ${java_download_dir[1]} ]];then
        if [ ! -d ${java_app_dir} ];then
                mkdir -p ${java_app_dir}
        else
                rm -f ${java_app_dir}/*.jar
        fi
echo -e "\e[32;1m编译jar源码。。。\e[0m"
cd ${home_dir}/$1
#mvn install >>${script_dir}/logs/java_compile.log
mvn clean install -P $compile_env >>${script_dir}/logs/java_compile.log
fi
}

java_pkg(){
##tar package
cd ${home_dir}/$1/$2/target
tar fvcz $2.tar.gz $2 >>${script_dir}/logs/java_compile.log 2>&1
mv $2.tar.gz ${java_app_dir}
}

jar_pkg(){
##jar package
xf_process_name=($xf_process_name)
for y in ${xf_process_name[*]:1};do
cd ${home_dir}/$1/${y%.*}/target
cp $y ${java_app_dir}
	if [[ $y == 'settle.manage.reward.jar' ]];then
		lib_process_name=($general_lib_process_name)
		for i in ${lib_process_name[*]:1};do
			cp lib/$i ${java_app_dir}
		done
	fi
done
}

##############################################判断java菜单#####################################################
com_judge(){
val=`cat ${script_dir}/logs/java_compile.log|grep -i '^\[error'|wc -l`
val2=`find  ${script_dir}/logs/ -name java_compile.log|wc -l`
if [ $val -eq 0 ] && [ $val2 -eq 1 ];then
echo -e "\e[32;1minfo:compile is sucessful!\e[0m"
else
echo -e "\e[31;1merror:compile is fail!\e[0m"
exit 1
fi
}

if [[ $1 == 'java_svn_code' ]];then
	java_svn_code $2
elif [[ $1 == 'java_compile' ]];then
	if [[ $2 == ${java_download_dir[0]} ]];then
		java_compile $2 $3
		com_judge
		java_pkg $2 $3
	elif [[ $2 == ${java_download_dir[1]} ]];then
		java_compile $2
		com_judge
		jar_pkg $2
	fi
#val=`cat ${script_dir}/logs/java_compile.log|grep -i '^\[error'|wc -l`
#val2=`find  ${script_dir}/logs/ -name java_compile.log|wc -l`
#if [ $val -eq 0 ] && [ $val2 -eq 1 ];then
#echo -e "\e[32;1minfo:compile is sucessful!\e[0m"
#else
#echo -e "\e[31;1merror:compile is fail!\e[0m"
#exit 1
#fi

elif [[ $1 == 'static_svn_code' ]];then
static_svn_code $2
elif [[ $1 == 'static_rsync' ]];then
static_rsync $2
else
echo -e "\e[31;1merror:parameter is error!\e[0m"
exit 1
fi






