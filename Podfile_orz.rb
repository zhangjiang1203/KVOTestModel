# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
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
  pod 'ReactiveObjC', :path => './ReactiveObjC' #'~> 3.1.1'
  pod 'Masonry'
  pod 'YYText'

  #奔溃搜集
  pod 'PLCrashReporter'
  #Yogakit 盒子布局设置
  pod 'Yoga', :path => './Yoga'
  pod 'YogaKit' , :path => './YogaKit'
  
  pod 'libpag'

  
  #接入bugly

#  pod 'Bugly'

end
