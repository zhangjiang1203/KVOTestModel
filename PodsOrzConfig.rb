#############
#开发人员专用
#############

#想要开发修改的的Pod
$FIX_POD_LIST = [
    #         "AFNetworking",
    ]
    
    
    module GitConfig
        #App 当前版本
        APP_RELEASE_VERSION = "1.1.4"
    
        #作者姓名xiangqi简写
        BRANCH_AUTHOR_SUFFIX = "xq"
    
    
    
        #App pods的远端仓库地址 源码
        REMOTE_URL_SOURCECODE = 'git@gitlab.91banban.com:zhuita-ios/pod_group/pods'
        #App podspec的发布地址仓库
        REMOTE_URL_CODESPEC = 'git@gitlab.91banban.com:zhuita-ios/pod_group/specs.git'
        
        
        #App 二进制存放地址 service
        REMOTE_URL_SOURCEBINARY = 'http://192.168.6.127:8899'
        #App 二进制 podspec的发布地址仓库
        REMOTE_URL_BINARYSPEC = 'git@gitlab.91banban.com:zhuita-ios/pod_group/binary_specs.git'
        
    end
    
    module FileConfig
        #开发pods组件时仓库名称（需要与主工程同一级文件夹）
        FILE_DEVPODS_NAME = 'zt_pods'
    
        #ztPods/kxPods下的Pod源码库打包成二进制库相关 需要用到该行标识注释
        FILE_PACKAGE_FILTER_MARK = 'ztPods'
        
        #与cocoapods同一级的私有repo仓库文件夹名称
        FILE_CODEREPO_NAME = "zhuita_specs"
        
        #与cocoapods同一级的私有二进制 repo仓库文件夹名称
        FILE_BINARYREPO_NAME = "zhuita_binary_specs"
        
    end
        
        
    
    
    
    #############
    #打包人员专用
    #############
    
    #------Binary Static library ------#
    #是否全部Pod以二进制静态库加载，false代表以源码显示【打包机】请用源码
    $is_all_binary = false
    #当is_all_binary = false 所有pod即将显示源码时，仍然希望部分Pod二进制静态库加载
    $static_lib_list = [
    #         "AFNetworking",
    ]
    
    #------Package Action------#
    #当is_all_binary = false 并不是针对所有pod 打binary包，仍然希望部分pod打包成二进制静态库的Pod
    $will_package_list = [
    #        "AFNetworking",
    ]
    