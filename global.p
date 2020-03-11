
#!/bin/bash
#GITHUB此代码仅供技术面试官参考，脚本已清洗敏感数据。
###define global variables
home_dir="/opt/fanfanjinfu/whole_deploy_hf"
script_dir="/opt/fanfanjinfu/whole_deploy_hf"
java_app_dir="/opt/fanfanjinfu/whole_deploy_hf/app"
java_tar_dir="/backup"
java_general_dir="/root/.m2/repository/com/"

outdir='/opt/FFJF-Project/whole_deploy_hf/slb_api/'
desc_outfile='Attribute_list'
add_outfile="Add_list"
del_outfile="Del_list"

jar_log="/var/log/mq"
jar_mem=512
jar_back_dir="/backup"

##svn username and password
svn_username=xxxxxx
svn_pass=xxxxxx


#########################menu variables######################################
##总菜单数组php、java和static
code_array=(java static)
##php菜单数组
php_array=(front xf admin web-t)
##静态资源菜单数组 
static_array=(customer.onigiri app.onigiri)
##下载菜单数组
download_array=(java jar)
##编译部署菜单数组
com_deploy_array=(front.onigiri customer.onigiri app.onigiri ff_batch.onigiri bgfront.onigiri manage.onigiri web.onigiri jar)
##部署菜单分类数组
#负载菜单数组
slb_deploy_array=(front.onigiri customer.onigiri web.onigiri app.onigiri)
#主备菜单数组
mb_deploy_array=(ff_batch.onigiri)
#单机菜单数组
single_deploy_array=(bgfront.onigiri manage.onigiri)
#jar菜单数组
jar_deploy_array=(jar)
##负载服务停服等待时间,设定时间小于1000,单位为秒
stop_wait_time=20
##负载服务挂载等待时间,设定时间小于1000，单位为秒
mount_wait_time=10





#########################java compile server variables######################################

##------------------------static---------------------------------
##rsync 密码文件
static_secrets=/opt/secrets
##静态资源服务器ip
static_ips='172.16.146.102'
##svn url项目名前缀部分
##svn url项目名后缀部分
static_svn_postfix_url='src/main/webapp/static'
##静态资源服务器rsync项目名和update升级目录名
static_process_name='static'

##------------------------java compile---------------------------------
##svn url项目名前缀部分
java_svn_url=
##java和jar下载目录，这数组和下载菜单数组有关联（索引关联）
java_download_dir=(onigiri_hffy mq.onigiri_hffy)
compile_env=pro



#########################java deploy server variables######################################

## -----------------front.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
front_onigiri_lb_id='lb-bp1l82z7'
front_onigiri_total_bes_id=('main i-bp1i1isl5' 'test i-bp1fxn3b')
main_front_onigiri_bes_id='i-bp1itisl5'
test_front_onigiri_bes_id='i-bp1fvyvoxn3b'
##deploy server
main_front_onigiri_ips_num=1
main_front_onigiri_ips='172.16.34.194'
main_front_onigiri_directories_num=1
main_front_onigiri_install_directories='/usr/local/tomcat_customer/webapps'
main_front_onigiri_start_directories='/usr/local/tomcat_customer/bin'
main_front_onigiri_start_port='80'
main_front_onigiri_username=root
main_front_onigiri_process_name='front.onigiri'

test_front_onigiri_ips_num=1
test_front_onigiri_ips='172.16.146.100'
test_front_onigiri_directories_num=1
test_front_onigiri_install_directories='/usr/local/tomcat_customer/webapps'
test_front_onigiri_start_directories='/usr/local/tomcat_customer/bin'
test_front_onigiri_start_port='80'
test_front_onigiri_username=root
test_front_onigiri_process_name='front.onigiri'




## -----------------customer.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
customer_onigiri_lb_id='lb-bp18l82z7'
customer_onigiri_total_bes_id=('main i-bpltisl5' 'test i-bp1fyvoxn3b')
main_customer_onigiri_bes_id='i-bp1i1otltisl5'
test_customer_onigiri_bes_id='i-bp1fvj7yvoxn3b'
##deploy server
main_customer_onigiri_ips_num=1
main_customer_onigiri_ips='172.16.34.194'
main_customer_onigiri_directories_num=1
main_customer_onigiri_install_directories='/usr/local/tomcat_customer/webapps'
main_customer_onigiri_start_directories='/usr/local/tomcat_customer/bin'
main_customer_onigiri_start_port='80'
main_customer_onigiri_username=root
main_customer_onigiri_process_name='customer.onigiri'

test_customer_onigiri_ips_num=1
test_customer_onigiri_ips='172.16.146.100'
test_customer_onigiri_directories_num=1
test_customer_onigiri_install_directories='/usr/local/tomcat_customer/webapps'
test_customer_onigiri_start_directories='/usr/local/tomcat_customer/bin'
test_customer_onigiri_start_port='80'
test_customer_onigiri_username=root
test_customer_onigiri_process_name='customer.onigiri'



## -----------------web.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
web_onigiri_lb_id='lb-bp1so8emn'
web_onigiri_total_bes_id=('main i-bp1g5io7' 'test i-bp1jasdlw3')
main_web_onigiri_bes_id='i-bp1ikb5io7'
test_web_onigiri_bes_id='i-bp1j01dsdlw3'
##deploy server
main_web_onigiri_ips_num=1
main_web_onigiri_ips='172.16.34.196'
main_web_onigiri_directories_num=1
main_web_onigiri_install_directories='/usr/local/tomcat_web/webapps'
main_web_onigiri_start_directories='/usr/local/tomcat_web/bin'
main_web_onigiri_start_port='80'
main_web_onigiri_username=root
main_web_onigiri_process_name='web.onigiri'

test_web_onigiri_ips_num=1
test_web_onigiri_ips='172.16.146.101'
test_web_onigiri_directories_num=1
test_web_onigiri_install_directories='/usr/local/tomcat_web/webapps'
test_web_onigiri_start_directories='/usr/local/tomcat_web/bin'
test_web_onigiri_start_port='80'
test_web_onigiri_username=root
test_web_onigiri_process_name='web.onigiri'


#################
## -----------------Batch Servers-----------------
#@BATCH_SVR_SERVER:
##mount and umount
##deploy server
main_ff_batch_onigiri_ips_num=1
main_ff_batch_onigiri_ips='172.16.34.195'
main_ff_batch_onigiri_directories_num=1
main_ff_batch_onigiri_install_directories='/usr/local/tomcat_batch/webapps'
main_ff_batch_onigiri_start_directories='/usr/local/tomcat_batch/bin'
main_ff_batch_onigiri_start_port='8081'
main_ff_batch_onigiri_username=root
main_ff_batch_onigiri_process_name='ff_batch.onigiri'
                           
backup_ff_batch_onigiri_ips_num=1
backup_ff_batch_onigiri_ips='172.16.34.197'
backup_ff_batch_onigiri_directories_num=1
backup_ff_batch_onigiri_install_directories='/usr/local/tomcat_batch/webapps'
backup_ff_batch_onigiri_start_directories='/usr/local/tomcat_batch/bin'
backup_ff_batch_onigiri_start_port='8082'
backup_ff_batch_onigiri_username=root
backup_ff_batch_onigiri_process_name='ff_batch.onigiri'



## -----------------app.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
app_onigiri_lb_id='lb-bp1bs00'
app_onigiri_total_bes_id=('main i-bvxip9q' 'test i-bp1cgcdai')
main_app_onigiri_bes_id='i-bp1vxip9q'
test_app_onigiri_bes_id='i-bp13qhcgcdai'
##deploy server
main_app_onigiri_ips_num=1
main_app_onigiri_ips='172.16.34.203'
main_app_onigiri_directories_num=1
main_app_onigiri_install_directories='/usr/local/tomcat_app/webapps'
main_app_onigiri_start_directories='/usr/local/tomcat_app/bin'
main_app_onigiri_start_port='80'
main_app_onigiri_username=root
main_app_onigiri_process_name='app.onigiri'

test_app_onigiri_ips_num=1
test_app_onigiri_ips='172.16.146.106'
test_app_onigiri_directories_num=1
test_app_onigiri_install_directories='/usr/local/tomcat_app/webapps'
test_app_onigiri_start_directories='/usr/local/tomcat_app/bin'
test_app_onigiri_start_port='80'
test_app_onigiri_username=root
test_app_onigiri_process_name='app.onigiri'


## -----------------bgfront.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
##deploy server
single_bgfront_onigiri_ips_num=1
single_bgfront_onigiri_ips='172.16.34.197'
single_bgfront_onigiri_directories_num=1
single_bgfront_onigiri_install_directories='/usr/local/tomcat_manager/webapps'
single_bgfront_onigiri_start_directories='/usr/local/tomcat_manager/bin'
single_bgfront_onigiri_start_port='8080'
single_bgfront_onigiri_username=www
single_bgfront_onigiri_process_name='bgfront.onigiri'


## -----------------manage.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
##deploy server
single_manage_onigiri_ips_num=1
single_manage_onigiri_ips='172.16.34.197'
single_manage_onigiri_directories_num=1
single_manage_onigiri_install_directories='/usr/local/tomcat_manager/webapps'
single_manage_onigiri_start_directories='/usr/local/tomcat_manager/bin'
single_manage_onigiri_start_port='8080'
single_manage_onigiri_username=www
single_manage_onigiri_process_name='manage.onigiri'


## -----------------app.onigiri Servers-----------------
#@CUP_SVR_SERVER:
##mount and umount
##deploy server
single_app_onigiri_ips_num=1
single_app_onigiri_ips='172.16.34.203'
single_app_onigiri_directories_num=1
single_app_onigiri_install_directories='/usr/local/tomcat_app/webapps'
single_app_onigiri_start_directories='/usr/local/tomcat_app/bin'
single_app_onigiri_start_port='80'
single_app_onigiri_username=root
single_app_onigiri_process_name='app.onigiri'



## -----------------------------------------------general Servers---------------------------------------------------

#@JAR_SERVER:
##deploy server
general_jar_ips_num=1
general_jar_ips='172.16.146.103'
general_jar_directories_num=1
general_jar_install_directories='/usr/local/onigiri/runjar'
general_jar_start_directories='/usr/local/onigiri/runjar'
general_jar_back_directories='/usr/local/onigiri/runjar/backup'
#general_jar_start_port='NULL'
general_jar_username=root
general_jar_process_name='jar '
xf_process_name='jar accounting.manage.bal.jar '

## -----------------lib  Servers-----------------

#@LIB_SERVER:
##deploy server
general_lib_ips_num=1
general_lib_ips='172.16.146.103'
general_lib_directories_num=1
general_lib_install_directories='/usr/local/onigiri/runjar/lib'
general_lib_start_directories='/usr/local/onigiri/runjar'
general_lib_back_directories='/usr/local/onigiri/runjar/lib/backup'
#general_lib_start_port='NULL'
general_lib_username=root
general_lib_process_name='lib onigiri.common-1.0.jar'










