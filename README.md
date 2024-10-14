<div align="center" >
  <img width="85%" src="image/logo.png" />
</div>

# SFServiceKit

[![CI Status](https://img.shields.io/travis/Sfh03031/SFServiceKit.svg?style=flat)](https://travis-ci.org/Sfh03031/SFServiceKit)
[![Version](https://img.shields.io/cocoapods/v/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)
[![License](https://img.shields.io/cocoapods/l/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)
[![Platform](https://img.shields.io/cocoapods/p/SFServiceKit.svg?style=flat)](https://cocoapods.org/pods/SFServiceKit)

## Introduction

Some collections of tool classes (zh: 一些工具类集合: 后台保活/显示模式/身份验证/文件管理/GCD计时器/区域监测/语言管理/位置定位/加载SFSymbol图标)

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

or

pod 'SFServiceKit', :subspecs => ['Full']
```

If you want to use the latest features of SFServiceKit use normal external source dependencies.

```ruby
pod 'SFServiceKit', :git => 'https://github.com/Sfh03031/SFServiceKit.git'
```

SFServiceKit has created sub libraries, if you only want to use one of them, simply add the following line to your Podfile: 

```ruby
# 后台保活，可自定义时长
pod 'SFServiceKit/Bgtask'

# 显示模式
pod 'SFServiceKit/Display'

# 身份验证
pod 'SFServiceKit/Author'

# 文件管理
pod 'SFServiceKit/File'

# GCD计时器
pod 'SFServiceKit/Timer'

# 区域监测
pod 'SFServiceKit/IBeacon'

# 语言管理
pod 'SFServiceKit/Language'

# 位置定位
pod 'SFServiceKit/Location'

# 加载SF Symbol图标
pod 'SFServiceKit/Symbol'

# 内购
pod 'SFServiceKit/IAP'
```

or use subspecs, simply add the following line to your Podfile:

```swift
pod 'SFServiceKit', :subspecs => ['Bgtask', 'Display', 'Author', 'File', 'Timer', 'IBeacon', 'Language', 'Location', 'Symbol', 'IAP']
```

## Change log

2024.10.14, 0.1.7
- fix bug(zh: 修复bug)

2024.08.13, 0.1.6
- add iap manager(zh: 新增内购管理类)

2024.07.31, 0.1.5
- update podspec and optimized the subspecs(zh: 优化配置子库)

2024.07.18, 0.1.4
- code optimize(zh: 代码优化)

2024.07.16, 0.1.2、0.1.3
- update readme and fix bug(zh: 更新readme、修改bug)
    
2024.07.15, 0.1.1
- Initial version(zh: 初始版本)

## Author

Sfh03031, sfh894645252@163.com

## License

SFServiceKit is available under the MIT license. See the LICENSE file for more info.
