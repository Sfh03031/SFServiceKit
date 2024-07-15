# SFServiceKit

[![CI Status](https://img.shields.io/travis/Sfh03031/SFServiceKit.svg?style=flat)](https://travis-ci.org/Sfh03031/SFServiceKit)
[![Version](https://img.shields.io/cocoapods/v/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)
[![License](https://img.shields.io/cocoapods/l/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)
[![Platform](https://img.shields.io/cocoapods/p/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)

## Introduction

Some collections of tool classes (zh: 一些工具类集合: 后台保活/显示模式/身份认证/文件管理/GCD计时器/区域监测/语言管理/位置定位/加载SFSymbol图标)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 12.0 or later
* Swift 5.9.2
* Xcode 15.1

## Installation

SFServiceKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SFServiceKit'
```

If you want to use the latest features of SFServiceKit use normal external source dependencies.

```ruby
pod 'SFServiceKit', :git => 'https://github.com/Sfh03031/SFServiceKit.git'
```

SFServiceKit has created sub libraries, you can use them like this: 

```ruby
# 后台保活，可自定义时长
pod 'SFServiceKit/SFBackgroundTaskManager'

# 显示模式
pod 'SFServiceKit/SFDisplayModeManager'

# 身份认证
pod 'SFServiceKit/SFFaceIDWithTouchIDManager'

# 文件管理
pod 'SFServiceKit/SFFileManager'

# GCD计时器
pod 'SFServiceKit/SFGCDTimer'

# 区域监测
pod 'SFServiceKit/SFIBeaconManager'

# 语言管理
pod 'SFServiceKit/SFLanguageManager'

# 位置定位
pod 'SFServiceKit/SFLocationManager'

# 加载SF Symbol图标
pod 'SFServiceKit/SFSymbolManager'
```

## Author

Sfh03031, sfh894645252@163.com

## License

SFServiceKit is available under the MIT license. See the LICENSE file for more info.
