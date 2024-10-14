#
# Be sure to run `pod lib lint SFServiceKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFServiceKit'
  s.version          = '0.1.7'
  s.summary          = 'Some collections of tool classes (zh: 一些工具类集合).'
  s.description      = <<-DESC
  Some collections of tool classes (zh: 一些工具类集合: 后台保活/显示模式/身份验证/文件管理/GCD计时器/区域监测/语言管理/位置定位/加载SFSymbol图标/IAP内购).
                       DESC
  s.homepage         = 'https://github.com/Sfh03031/SFServiceKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sfh03031' => 'sfh894645252@163.com' }
  s.source           = { :git => 'https://github.com/Sfh03031/SFServiceKit.git', :tag => s.version.to_s }
  s.swift_versions   = '5.0'
  s.platform         = :ios, '10.0'
#  s.static_framework = true
  s.frameworks       = 'UIKit', 'Foundation', 'MapKit', 'LocalAuthentication', 'CoreLocation', 'AVFoundation'
  s.default_subspec  = 'Full'
  
  s.subspec 'Bgtask' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFBackgroundTaskManager/*'
      ss.resource_bundles = {
        'Bgtask' => ['SFServiceKit/Assets/SFBackgroundTaskManager/*.wav']
      }
  end
  
  s.subspec 'Display' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFDisplayModeManager/*'
  end
  
  s.subspec 'Author' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFAuthenticationManager/*'
  end
  
  s.subspec 'File' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFFileManager/*'
  end
  
  s.subspec 'Timer' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFGCDTimer/*'
  end
  
  s.subspec 'IBeacon' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFIBeaconManager/*'
  end
  
  s.subspec 'Language' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFLanguageManager/*'
  end
  
  s.subspec 'Location' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFLocationManager/*'
  end
  
  s.subspec 'Symbol' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFSymbolManager/*'
  end
  
  s.subspec 'IAP' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFIAPManager/*'
  end
  
  s.subspec 'Full' do |ss|
      ss.dependency 'SFServiceKit/Bgtask'
      ss.dependency 'SFServiceKit/Display'
      ss.dependency 'SFServiceKit/Author'
      ss.dependency 'SFServiceKit/File'
      ss.dependency 'SFServiceKit/Timer'
      ss.dependency 'SFServiceKit/IBeacon'
      ss.dependency 'SFServiceKit/Language'
      ss.dependency 'SFServiceKit/Location'
      ss.dependency 'SFServiceKit/Symbol'
      ss.dependency 'SFServiceKit/IAP'
  end
  
end
