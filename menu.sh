#GITHUB此代码仅供技术面试官参考，脚本已清洗敏感数据。
#!/bin/bash

. global.p


eval xf_process_name='('$xf_process_name')'
eval general_lib_process_name='('$general_lib_process_name')'

#####计时函数############
timer()
{
n=0
expr $1 + 0 &>/dev/null
if [ `echo $?` -ne
        echo -e "\e[31;1m配置文件中，stop_wait_time或mount_wait_time变量配置有误!\e[0m"
        exit 1
fi
sum=$1
echo -en "\e[32;1m等待时间为:    "
while :;do
sy=$(( $sum-$n ))
if
sy=`echo "0$sy"`
elif [ $sy -lt 10 ];then
sy=`echo "00$sy"`
fi
echo -ne "\b\b\b\b${sy}s"
sleep 1
n=$(( n+1 ))
if [ $n -gt $sum ];then
break
fi
done
echo -en "\e[0m"
echo
#echo -e "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\e[32;1mjava服务没有ESTABLISHED状态\e[0m"
}




#########数字判断函数############
judge_num(){
##判断是否为数字
expr $1 + 0 &>/dev/null
if [ `echo $?` -ne 0 ];then
        echo -e "\e[31;1m输入有误!\e[0m"
        continue
fi
}


#n=1

upload_code(){
while :;do
echo -en "\e[35;1m
###################################################
\e[0m"
n=1
m=$n
for i in ${code_array[*]};do
     if [[ $i == ${code_array[${#code_array[*]}-1]} ]];then
         echo -en "\e[35;1m  $m.升级$i服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $m.升级$i服务\e[0m"
     m=$((m+1))
done
sum=$(($m+1))

echo -e "\e[35;1m
  $(($sum)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入操作代码号($n-$(($sum))):\e[0m"
read operate
judge_num $operate
if [ $operate -gt $((${#code_array[*]}+1)) ];then
        echo "输入有误!"
        continue
elif [ $operate -eq $((${#code_array[*]}+1)) ];then
        end=$((${#code_array[*]}+1))
else
        oper=$operate
fi
index=$(($operate-1))
case ${operate} in
 $oper)
        eval ${code_array[$index]}_menu ${code_array[$index]}
        ;;
 $end)
        echo "exit"
        exit
        ;;
esac
done

}



php_menu(){
while :
do
echo -en "\e[35;1m
###################################################
                升级$1代码
\e[0m"
n=1
m=$n
for i in ${php_array[*]};do
     if [[ $i == ${php_array[${#php_array[*]}-1]} ]];then
         echo -e "\e[35;1m  $m.下载$i服务代码\e[0m"
         echo -e "\e[35;1m  $((m+1)).部署$i服务代码\e[0m"
         echo -en "\e[35;1m  $((m+2)).一键下载/部署$i服务代码\e[0m"
         break
     fi
     echo -e "\e[35;1m  $m.下载$i服务代码\e[0m"
     echo -e "\e[35;1m  $((m+1)).部署$i服务代码\e[0m"
     echo -e "\e[35;1m  $((m+2)).一键下载/部署$i服务代码\e[0m"
     m=$((m+3))
done
sum=$(($m+4))
echo -en "\e[35;1m
  $(($sum-1)).返回上层目录
  $(($sum)).退出                                         
###################################################
\e[0m"
echo -en "\e[35;1m请输入操作代码号($n-$(($sum))):\e[0m"
read php_dep
t=`echo "${#php_array[*]}*3"|bc`
#for i in ${php_array[*]};do
#       for (( j=1;j<=3;j++ ));do
#               t=$(($t+1))
#       done
#done
judge_num $php_dep
if [ $php_dep -le $t ];then
        c=$php_dep
fi
if [ $php_dep -le $((t+2)) ] ;then
        for (( i=0;i<${#php_array[*]};i++ )); do
                if [ $(((php_dep-1)/3)) -eq $i ];then
                        php_item=${php_array[$i]}
                fi
        done
        u=$((t+1))
        q=$((t+2))
        case $php_dep in
        $c)

        fi
        ;;
        $u)
        clear
        break
        ;;
        $q)
        exit
        ;;
        *)
        clear
        ;;
        esac
fi

done

}





static_menu(){
while :
do
echo -en "\e[35;1m
###################################################
		升级$1资源
\e[0m"
n=1
m=$n
for i in ${static_array[*]};do
     if [[ $i == ${static_array[${#static_array[*]}-1]} ]];then
         echo -e "\e[35;1m  $m.下载$i服务\e[0m"
         echo -e "\e[35;1m  $((m+1)).部署$i服务\e[0m"
         echo -en "\e[35;1m  $((m+2)).一键下载/部署$i服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $m.下载$i服务\e[0m"
     echo -e "\e[35;1m  $((m+1)).部署$i服务\e[0m"
     echo -e "\e[35;1m  $((m+2)).一键下载/部署$i服务\e[0m"
     m=$((m+3))
done
sum=$(($m+4))
echo -en "\e[35;1m
  $(($sum-1)).返回上层目录
  $(($sum)).退出                                         
###################################################
\e[0m" 
echo -en "\e[35;1m请输入操作代码号($n-$(($sum))):\e[0m"
read static_dep
t=`echo "${#static_array[*]}*3"|bc`
#for i in ${static_array[*]};do
#	for (( j=1;j<=3;j++ ));do
#		t=$(($t+1))
#	done
#done
judge_num $static_dep
if [ $static_dep -le $t ];then
	c=$static_dep
fi
if [ $static_dep -le $((t+2)) ] ;then
	for (( i=0;i<${#static_array[*]};i++ )); do
		if [ $(((static_dep-1)/3)) -eq $i ];then
			static_item=${static_array[$i]}
		fi
	done
	u=$((t+1))
	q=$((t+2))
	case $static_dep in
	$c)

	fi
	;;
	$u)
	clear
	break
	;;
	$q)
	exit
	;;
	*)
	clear
	;;
	esac
fi	

done
}

############################java服务菜单################################
java_menu(){

while :
do
echo -en "\e[35;1m
###################################################
                升级$1服务
  1.$1代码download/update和编译
  2.$1代码部署
  3.返回上层目录
  4.退出
###################################################
\e[0m"

echo -en "\e[35;1m请输入操作代码号(1-4):\e[0m"
read java_up
case $java_up in
 1)
	java_com_menu
	#echo "编译"
	;;
 2)
	java_dep_menu
	#echo "部署"
	;;
 3)
	clear
	break
	;;
 4)
	exit 
	;;
 *)
	echo "输入错误"
	;;

esac

done

}


############################java编译服务菜单################################
java_com_menu(){
while :;do
echo -en "\e[35;1m
###################################################
		下载/编译java代码
\e[0m"
n=1
m=$n
for d in ${download_array[*]};do
	echo -e "\e[35;1m  $m.下载$d源代码\e[0m" 
	m=$((m+1))
done

#m=$((m+1))
p=$m
for c in ${com_deploy_array[*]};do
	if [[ $c 
		echo -en "\e[35;1m  $p.编译$c服务\e[0m"
		break
	fi
	echo -e "\e[35;1m  $p.编译$c服务\e[0m"
	p=$(($p+1))
done
sum=$(($p+1))

echo -e "\e[35;1m
  $(($sum)).返回上层目录
  $(($sum+1)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入操作代码号($n-$(($sum+1))):\e[0m"
read com_deploy
eval com_deploy=($com_deploy)
down_com_deploy_array=(${download_array[@]} ${com_deploy_array[@]})

	for c in ${com_deploy[*]};do
		judge_num $c
		index=$(($c-1))

			com_oper=$c
		fi
		case $c in
		 $down_oper)

			fi
			;;
		 $upper)
			clear
			break
			;;
		 $end)
			echo "exit"
			exit
			;;
		esac
	done #for c
	value=`echo ${com_deploy[*]} | grep -wq "$upper" && echo "upper"`
	if [[ $value == 'upper' ]];then
		break
	fi
done #compile
}

############################java部署服务菜单################################
java_dep_menu(){
while :;do
echo -en "\e[35;1m
###################################################
                部署java代码
\e[0m"
n=1
m=$n

                break
        fi
        echo -e "\e[35;1m  $m.$c服务\e[0m"
        m=$(($m+1))
done
sum=$(($m+1))

echo -e "\e[35;1m
  $(($sum)).返回上层目录
  $(($sum+1)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入操作代码号($n-$(($sum+1))):\e[0m"
read dep_code

judge_num $dep_code


fi
index=$(($dep_code-1))
case ${dep_code} in
 $dep_oper)
        java_dep_detail_menu ${com_deploy_array[$index]}
        ;;
 $upper)
        clear
        break
        ;;
 $end)
        echo "exit"
        exit
        ;;
esac
done

}

############################jar部署服务菜单################################
input_judge()
{
read jar_rep
eval y='('$jar_rep')'
s_val=0
for (( i=0;i<${#y[*]};i++ ));do
        n=0
        for (( j=0;j<${#y[*]};j++ ));do
                if [ ${y[$j]} -eq ${y[$i]} ] >>/dev/null 2>&1;then
                        n=$(($n+1))
                fi
        done
        if [ $n -ge 2 ];then
                #echo "repeat"
                break
        fi
        if [ ${y[$i]} -gt $(($sum+2)) ] >>/dev/null 2>&1;then
                s_val=1
        fi
done
#echo $n

        exit 1
fi
if [ ${#y[*]} -ge 1 ] && [ ${y[0]} -lt $(($sum+1)) ] >>/dev/null 2>&1;then
#./jar_deploy.sh general_ jar jar_bak_rep ${y[*]}
./jar_deploy.sh general_ $1 $2 ${y[*]}
#break
#echo ${y[*]}
elif [ ${#y[*]} -eq 1 ] && [ ${y[0]} -eq $(($sum+2)) ] >>/dev/null 2>&1;then
exit 1
else
clear
fi
}


jar_stop()
{
echo -en "\e[35;1m
###################################################
  0.停止所有的jar包服务
\e[0m" 
  n=1
  for j in ${xf_process_name[*]:1};do
     if 
         break
     fi
     echo -e "\e[35;1m  $n.停止$j服务\e[0m"
     n=$((n+1))
  done
  sum=$((${#xf_process_name[*]:1}-1))
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge jar jar_stop

}

jar_start()
{
echo -en "\e[35;1m
###################################################
  0.启动所有的jar包服务
\e[0m" 
  n=1
#  eval xf_process_name='('$xf_process_name')'
  for j in 
         echo -en "\e[35;1m  $n.启动$j服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $n.启动$j服务\e[0m"
     n=$((n+1))
  done
  sum=
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge jar jar_start

}

jar_bak_rep()
{
echo -en "\e[35;1m
###################################################
  0.备份/替换所有的jar包服务
\e[0m" 
  n=1
# eval xf_process_name='('$xf_process_name')'
  for j in 
         echo -en "\e[35;1m  $n.备份/替换$j服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $n.备份/替换$j服务\e[0m"
     n=$((n+1))
  done
  sum=
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge jar jar_bak_rep

}

jar_rollback()
{
echo -en "\e[35;1m
###################################################
  0.回退所有的jar包服务
\e[0m" 
  n=1
#  eval xf_process_name='('$xf_process_name')'
  for j in
         echo -en "\e[35;1m  $n.回退$j服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $n.回退$j服务\e[0m"
     n=$((n+1))
  done
  sum=$((${#xf_process_name[*]:1}-1))
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge jar jar_rollback

}

lib_bak_rep()
{
echo -en "\e[35;1m
###################################################
  0.备份/替换所有的jar包服务
\e[0m" 
  n=1
#  eval xf_process_name='('$xf_process_name')'
  for j in 
         echo -en "\e[35;1m  $n.备份/替换$j服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $n.备份/替换$j服务\e[0m"
     n=$((n+1))
  done
  sum=$((${#general_lib_process_name[*]:1}-1))
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge lib jar_bak_rep

}

lib_rollback()
{
echo -en "\e[35;1m
###################################################
  0.回退所有的jar包服务
\e[0m" 
  n=1
#  eval xf_process_name='('$xf_process_name')'
  for j in 
         echo -en "\e[35;1m  $n.回退$j服务\e[0m"
         break
     fi
     echo -e "\e[35;1m  $n.回退$j服务\e[0m"
     n=$((n+1))
  done
  sum=$((${#general_lib_process_name[*]:1}-1))
echo -e "\e[35;1m
  $(($sum+1)).返回上层目录                                     
  $(($sum+2)).退出 
###################################################
\e[0m"
echo -en "\e[33;1m请输入jar服务操作代码号(0-$(($sum+2))):\e[0m"
input_judge lib jar_rollback

}


############################java部署服务菜单################################
slb_deploy_menu(){
while :;do
	echo -e "\e[35;1m
###############################################################
  1.卸载$1的test服务                
  2.停止$1的test服务
  3.启动$1的test服务             
  4.一键备份/替换$1的test服务和main服务，并挂载test服务 
  5.一键回退$1的test服务和main服务，并挂载test服务
  6.挂载$1的test服务
  7.卸载$1的main服务                
  8.停止$1的main服务
  9.启动$1的main服务             
  10.一键备份/替换$1的main服务和test服务，并挂载main服务
  11.一键回退$1的main服务和test服务，并挂载main服务 
  12.挂载$1的main服务
  13.检查负载后台服务挂载情况
  14.返回上层目录                                     
  15.退出                                         
###############################################################
	\e[0m" 
	echo -en "\e[35;1m请输入java服务操作代码号(1-15):\e[0m"
	read pro_deploy
	case $pro_deploy in
		1)
		#echo "test umount"
		./java_slb.sh test $1 slb_del
		;;
		2)
		#echo "test stop"
		./java_slb.sh test $1 slb_del
			if [ `echo $?` -eq 2 ];then
				exit 2
			fi
		timer $stop_wait_time
		./java_deploy.sh test $1 main_stop
		;;
		3)
		#echo "test start"
		./java_deploy.sh test $1 main_start
		;;
		4)
		##备份/替换test
                ./java_slb.sh test $1 slb_del
                if [ `echo $?` -eq 2 ];then
                        exit 2
                fi

                fi
                timer $stop_wait_time
                ./java_deploy.sh main $1 main_bak_rep
                ;;
		5)
		##回退test
                ./java_slb.sh test $1 slb_del
                if [ `echo $?` -eq 2 ];then
                        exit 2
                fi

                        exit 2
                fi
                timer $stop_wait_time
                ./java_deploy.sh main $1 main_rollback
                ;;
		6)
		#echo "test mount"
                ./java_slb.sh test $1 check_slb_mount
                if [ `echo $?` -eq 1 ];then
                        break
                fi
                ./java_deploy.sh test $1 main_stop
                ./java_slb.sh test $1 slb_add
                #timer $mount_wait_time
                ./java_deploy.sh test $1 main_start
                ./java_slb.sh test $1 health_desc
                echo -e "\e[32;1mtest服务挂载正常！\e[0m"
                ;;
		7)
		#echo "main umount"
		./java_slb.sh main $1 slb_del
		;;
		8)
		#echo "stop"
		./java_slb.sh main $1 slb_del
			if [ `echo $?` -eq 2 ];then
				exit 2
			fi
		timer $stop_wait_time
		./java_deploy.sh main $1 main_stop
		;;
		9)
		#echo "start"
		./java_deploy.sh main $1 main_start
		;;
		10)
		##备份/替换main
                ./java_slb.sh main $1 slb_del
                        if [ `echo $?` -eq 2 ];then
                                exit 2
                        fi
                timer $stop_wait_time
                ./java_deploy.sh main $1 main_bak_rep
                ##挂载main
		sleep 8

                        fi
                timer $stop_wait_time
                ./java_deploy.sh test $1 main_bak_rep
                ;;
		11)
		##回退main
                ./java_slb.sh main $1 slb_del
                        if [ `echo $?` -eq 2 ];then
                                exit 2
                        fi
                timer $stop_wait_time

                        if [ `echo $?` -eq 2 ];then
                                exit 2
                        fi
                timer $stop_wait_time
                ./java_deploy.sh test $1 main_rollback
                ;;
		12)
		./java_slb.sh main $1 check_slb_mount
                if [ `echo $?` -eq 1 ];then
                        break
                fi

                echo -e "\e[32;1mmain服务挂载正常！\e[0m"
                ;;
		13)
                #echo "挂载情况"
                ./java_slb.sh slb $1 status_desc
                ;;
		14)
		clear
		break
		;;
		15)
		exit
		;;
		*)
		clear
		;;
	esac
done

}

mb_deploy_menu(){
while :
do
echo -e "\e[35;1m
###################################################                
  1.停止$1的main服务
  2.启动$1的main服务            
  3.一键备份/替换$1的backup和main服务         
  4.一键回退$1的backup和main服务
  5.返回上层目录                                     
  6.退出                                         
###################################################
\e[0m" 
echo -en "\e[35;1m请输入java服务操作代码号(1-6):\e[0m"
read pro_deploy
case $pro_deploy in
1)
#echo "test stop"
./java_deploy.sh main $1 main_stop
;;
2)
#echo "test start"
./java_deploy.sh main $1 main_start
;;
3)
#echo "main backup/replace"
./java_deploy.sh backup $1 main_bak_rep
./java_deploy.sh main $1 main_bak_rep
;;
4)
#echo "rollback"
./java_deploy.sh backup $1 main_rollback
./java_deploy.sh main $1 main_rollback
;;
5)
clear
break
;;
6)
exit
;;
*)
clear
;;

esac
done
}

single_deploy_menu(){
while :;do
	echo -e "\e[35;1m
###################################################
  1.停止$1服务
  2.启动$1服务             
  3.一键备份/替换$1服务         
  4.一键回退$1服务
  5.返回上层目录                                     
  6.退出                                         
###################################################
	\e[0m" 
	echo -en "\e[35;1m请输入java服务操作代码号(1-6):\e[0m"
	read pro_deploy
	case $pro_deploy in
		1)
		./java_deploy.sh single $1 main_stop
			;;
		2)
		./java_deploy.sh single $1 main_start
			;;
		3)
		./java_deploy.sh single $1 main_bak_rep
			;;
		4)
		./java_deploy.sh single $1 main_rollback
			;;
		5)
			clear
			break
			;;
		6)
			exit
			;;
	esac
done
}

jar_update_menu(){
while :;do
	echo -e "\e[35;1m
###################################################
                 升级jar代码                     
  1.jar服务                                      
  2.lib服务                                      
  3.返回上层目录                                     
  4.退出                                         
###################################################
	\e[0m" 
	echo -en "\e[35;1m请输入操作代码号(1-4):\e[0m"
	read jar_deploy
	case $jar_deploy in
	1)
	while :;do
		echo -e "\e[35;1m
###################################################
                 部署jar代码                      
  1.停止jar服务                                  
  2.启动jar服务                                  
  3.备份/替换jar服务                             
  4.回退jar服务                                  
  5.返回上层目录                                     
  6.退出                                         
###################################################
		\e[0m" 
		echo -en "\e[35;1m请输入操作代码号(1-6):\e[0m"
		read jar_dep
		case $jar_dep in
			  1)
			jar_stop
			  ;;
			  2)
			jar_start
			  ;;
			  3)
			jar_bak_rep
			  ;;
			  4)
			jar_rollback
			  ;;
			  5)
			  clear
			  break
			  ;;
			  6)
			  exit
			  ;;
			  *)
			  clear
		esac
	done
	  ;;
	  2)
	while :;do
		echo -e "\e[35;1m
###################################################
                部署lib代码                       
  1.备份/替换lib服务                             
  2.回退lib服务                                  
  3.返回上层目录                                     
  4.退出                                         
###################################################
		\e[0m" 
		echo -en "\e[35;1m请输入操作代码号(1-4):\e[0m"
		read lib_dep
		case $lib_dep in
			  1)
			lib_bak_rep
			  ;;
			  2)
			lib_rollback
			  ;;
			  3)
			  clear
			  break
			  ;;
			  4)
			  exit
			  ;;
			  *)
			  clear
		esac
	done
	  ;;
	  3)
	  	clear
	  	break
	  	;;
	  4)
	  	exit
	  	;;
	  *)
	  	clear
	esac
done

}

java_dep_detail_menu(){

slb_val=`echo  ${slb_deploy_array[*]}|grep -wq "$1" &&  echo "slb" || echo "no"`

        #echo "jar"
	jar_update_menu $1
else
	echo "$1服务不在部署菜单分类数组里，请检查全局配置文件!"
	exit 1	
fi

}



#static_menu




upload_code
#read operate
#if [ $operate -gt $((${#code_array[*]}+1)) ];then
#	echo "输入有误!"
#	exit 1
#elif [ $operate -eq $((${#code_array[*]}+1)) ];then
#	sum=$((${#code_array[*]}+1))
#else
#	oper=$operate
#fi
#index=$(($operate-1))
#case ${operate} in
# $oper)
#	echo "${code_array[$index]}"
# 	;;
# $sum)
#	echo "exit"
#	exit
#	;;
#esac
####echo "java"
#while :
#do
#cat<<eof











