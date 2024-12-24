# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, '14.0'
inhibit_all_warnings!
#plugin 'cocoapods-imy-bin'
#use_binaries!

target 'KVOTestModel' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KVOTestModel
  pod 'FMDB', '~> 2.7.5'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SDWebImage'
  pod 'FLAnimatedImage'
  pod 'ReactiveObjC', :path => './localPod/ReactiveObjC' #'~> 3.1.1'
  pod 'Masonry'
  pod 'YYText', :path => '/Users/zhangjiang/Documents/斗鱼极速版SPM/SPMFinder/YYText'
  pod 'MJRefresh'
  pod 'JXCategoryView', :path => './localPod/JXCategoryView'
  pod 'SnapKit'
  
  # json模型库
  pod 'SwiftyJSON', '5.0.2'
  pod 'HandyJSON', '5.0.2'
  pod 'ObjectMapper', '4.4.2'
  pod 'SmartCodable', '4.0.3'
  pod 'ExCodable', '0.6.0'
#  pod 'CodableWrappers', '2.0.7'
  pod 'CodableWrapper', :path => './localPod/CodableWrapper'
  pod 'MetaCodable', '1.3.0'
  pod 'KakaJSON', '1.1.2'

  
  #奔溃搜集
#  pod 'PLCrashReporter'
  #Yogakit 盒子布局设置
#  pod 'Yoga', :path => './Yoga'
#  pod 'YogaKit' , :path => './YogaKit'
  
#  pod 'libpag'
  
#  pod 'SVGAPlayer', '2.5.7'

  
  #接入bugly

#  pod 'Bugly'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
