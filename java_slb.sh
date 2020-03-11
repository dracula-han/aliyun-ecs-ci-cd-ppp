#GITHUB此代码仅供技术面试官参考，脚本已清洗敏感数据。
#!/bin/bash

. global.p

#########################判断slb负载下的backserver的负载情况###################
list_compare(){
t=0
flag=0
for i in ${desc_list[*]};do
        for j in ${java_bes_id[*]};do
                
                        flag=1
                        break
                fi
        done
        if [ $flag -eq 0 ];then
                 
                 t=$((t+1))
        else
                flag=0
        fi
done
if [ ${#result_list[*]} -eq 0 ];then
        echo -e "\e[31;1merror:请确认slb负载下的$java_process_name的服务器挂载情况!\e[0m"
	exit 2
fi

}



################################定义变量函数############################################
java_func(){
eval java_lb_id='$'${yl_java}'_lb_id'
eval java_bes_id='(''$'{${env}${yl_java}'_bes_id'[*]}')'
eval java_start_port='$'${env}${yl_java}'_start_port'
eval java_process_name='$'${env}${yl_java}'_process_name'
}

###############################generate backserverid#####################################
check_ip_host(){
java_func
for i in ${java_bes_id[*]};do
m_result=`python ${outdir}matchup.py ${java_lb_id} $i`
eval mu='('$m_result')'
echo "$i: ------ ip:${mu[0]},hostname:${mu[1]}"
done
}

##############################java slb server call##########################################
health_desc(){
java_func
n=1
while :;do
        result=
        if [ $result -eq '1' ];then
                if [ $n -lt 1000 ] && [ $n -ge 100 ];then
                        s=`echo "$n"`
                elif [ $n -lt 100 ] && [ $n -ge 10 ];then
                        s=`echo "0$n"`
                        elif [ $n -lt 10 ];then
                        s=`echo "00$n"`
                fi
                echo -ne "\b\b\b\b${s}s"
                sleep 1
                n=$(( n+1 ))
        else
                break
        fi
done
echo
}

status_desc(){
java_func
switch=0
return_value=
#echo $return_value
for (( i=0;i<`eval echo '$'{\#${yl_java}'_total_bes_id'[*]}`;i++ ));do
        path_id=(`eval echo '$'{${yl_java}'_total_bes_id'[i]}`);
        for j in ${path_id[*]:1};do
                if [ `echo $return_value|grep $j|wc -l` -eq 0 ];then
                        echo -e "\e[31;1mslb未挂载${path_id[0]}下的id为$j的服务\e[0m"
                        switch=1
                        break
                fi
                #echo $j
        done
done
if [ $switch -eq 0 ];then
        echo -e "\e[32;1m${yl_java}的slb下的服务已经全部挂载!\e[0m"
fi
#echo "aa"
}

slb_desc(){
java_func
python ${outdir}DescribeLoadBalancerAttribute.py ${java_lb_id} $outdir $desc_outfile
check_bes_id=
}

check_slb_mount(){
value=0
add_ser_id=
slb_desc
for i in ${java_bes_id[*]};do
return_val=`echo $check_bes_id |grep $i|wc -l`
if [ $return_val -eq 1 ];then
echo -e "\e[33;1mwarning:'$i' has been mount!\e[0m"
continue
else
value=1
fi
add_ser_id+=`echo -n "{\"ServerId\":\"$i\",\"Weight\":100},"`
done
if [ $value -eq 0 ];then
exit 1
fi

}

slb_add(){
#java_func
#value=0
#add_ser_id=
#slb_desc
#for i in ${java_bes_id[*]};do
#return_val=`echo $check_bes_id |grep $i|wc -l`
#if [ $return_val -eq 1 ];then
#echo -e "\e[33;1mwarning:'$i' has been mount!\e[0m"
#continue
#else
#value=1
#fi
#add_ser_id+=`echo -n "{\"ServerId\":\"$i\",\"Weight\":100},"`
#done
#if [ $value -eq 0 ];then
#exit 1
#fi
#echo $add_ser_id
check_slb_mount
add_ser_id=`echo "[${add_ser_id%,}]"`
re_val=
if [[ $re_val == 'addsucessful' ]];then
echo -e "\e[32;1minfo:$add_ser_id has mount sucessful!\e[0m"
fi

}

slb_del(){
java_func
del_ser_id=
slb_desc
desc_list=
eval desc_list='('$desc_list')'
list_compare
for i in ${java_bes_id[*]};do
#if [[ $check_bes_id != $i ]];then
return_val=`echo $check_bes_id |grep $i|wc -l`
if [ $return_val -eq 0 ];then
echo -e "\e[33;1mwarning:'$i' has been umount!\e[0m"
continue
fi
del_ser_id+=`echo -n "'$i',"`
done
if [[ $del_ser_id == '' ]];then
exit 1
fi
del_ser_id=`echo "[${del_ser_id%,}]"`
#echo $del_ser_id
re_val=
#echo $re_val
if [[ $re_val == 'removesucessful' ]];then
echo -e "\e[32;1minfo:$del_ser_id has umount sucessful!\e[0m"
fi

}

#python ${outdir}RemoveBackendServers.py $LoadBalancerId $outdir $outfile  $backserverid


#########################################main fun###############################################

if [[ $1 == 'main' ]];then
env=main_
elif [[ $1 == 'test' ]];then
env=test_
elif [[ $1 == 'slb' ]];then
env=
else
echo -e "\e[31;1merror:please input first right parament!\e[0m"
exit 1
fi

#if [[ $2 == 'front.onigiri' ]];then
#yl_java=front
#elif [[ $2 == 'customer.onigiri' ]];then
#yl_java=customer
#elif [[ $2 == 'app.onigiri' ]];then
#yl_java=app
#else
#echo -e "\e[31;1merror:please input second right parament!\e[0m"
#exit 1
#fi
slb_val=
if [[ $slb_val == 'slb' ]];then
	yl_java=
else
	echo -e "\e[31;1merror:please input second right parament!\e[0m"
fi

if [[ $3 == 'slb_add' ]];then
slb_add
elif [[ $3 == 'slb_del' ]];then
slb_del
elif [[ $3 == 'slb_desc' ]];then
slb_desc
elif [[ $3 == 'health_desc' ]];then
health_desc
elif [[ $3 == 'status_desc' ]];then
status_desc
elif [[ $3 == 'check_slb_mount' ]];then
check_slb_mount
else
echo -e "\e[31;1merror:please input third right parament!\e[0m"
exit 1
fi

#echo $yl_java
#check_ip_host
#slb_add
#slb_desc
#slb_del



