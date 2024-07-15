#
# Be sure to run `pod lib lint SFServiceKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFServiceKit'
  s.version          = '0.1.2'
  s.summary          = 'A short description of SFServiceKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Sfh03031/SFServiceKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sfh03031' => 'sfh894645252@163.com' }
  s.source           = { :git => 'https://github.com/Sfh03031/SFServiceKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = '5'
  s.ios.deployment_target = '10.0'

  s.source_files = 'SFServiceKit/Classes/**/*'
  
#  s.resource_bundles = {
#    'SFServiceKit' => ['SFServiceKit/Assets/SFBackgroundTaskManager/*.wav']
#  }
  s.static_framework = true

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'MapKit', 'LocalAuthentication', 'CoreLocation', 'AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.subspec 'SFBackgroundTaskManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFBackgroundTaskManager/*'
      ss.resource_bundles = {
        'SFBackgroundTaskManager' => ['SFServiceKit/Assets/SFBackgroundTaskManager/*.wav']
      }
  end
  
  s.subspec 'SFDisplayModeManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFDisplayModeManager/*'
  end
  
  s.subspec 'SFFaceIDWithTouchIDManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFFaceIDWithTouchIDManager/*'
  end
  
  s.subspec 'SFFileManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFFileManager/*'
  end
  
  s.subspec 'SFGCDTimer' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFGCDTimer/*'
  end
  
  s.subspec 'SFIBeaconManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFIBeaconManager/*'
  end
  
  s.subspec 'SFLanguageManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFLanguageManager/*'
  end
  
  s.subspec 'SFLocationManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFLocationManager/*'
  end
  
  s.subspec 'SFSymbolManager' do |ss|
      ss.source_files = 'SFServiceKit/Classes/SFSymbolManager/*'
  end
  
  
  
end
