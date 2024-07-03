//
//  SFSymbolManager.swift
//  SFServiceKit
//
//  Created by sfh on 2024/7/1.
//

import UIKit

@available(iOS 13.0, *)
@objcMembers
public class SFSymbolManager: NSObject {

    public static let shared = SFSymbolManager()
    
    /// 获取SFSymbol图片
    /// - Parameters:
    ///   - name: Symbol名称
    ///   - config: Symbol配置
    ///   - tintColor: Symbol颜色
    /// - Returns: 图片，可能为nil
    public func symbol(systemName name: String,
                       withConfiguration config: UIImage.Configuration?,
                       withTintColor tintColor: UIColor?) -> UIImage? {
        if tintColor != nil {
            return UIImage.init(systemName: name, withConfiguration: config)?.withTintColor(tintColor!, renderingMode: .alwaysOriginal)
        } else {
            return UIImage.init(systemName: name, withConfiguration: config)
        }
    }
    
    //MARK: - 如何调整SF Symbol大小
    
    /// 通过pointSize和weight调整大小
    /// - Parameters:
    ///   - pointSize: 自定义大小
    ///   - weight: 权重
    ///   - scale: 缩放比例
    /// - Returns: Symbol配置
    public func sizeConfig(pointSize: CGFloat = 22.0,
                           weight: UIImage.SymbolWeight = .regular,
                           scale: UIImage.SymbolScale = .default) -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
    }
    
    /// 通过textStyle和weight调整大小
    /// - Parameters:
    ///   - textStyle: 内置的动态类型大小
    ///   - weight: 权重
    ///   - scale: 缩放比例
    /// - Returns: Symbol配置
    public func sizeConfig(textStyle: UIFont.TextStyle = .largeTitle,
                           weight: UIImage.SymbolWeight = .regular,
                           scale: UIImage.SymbolScale = .default) -> UIImage.Configuration? {
        let ts = UIImage.SymbolConfiguration(textStyle: textStyle)
        let sw = UIImage.SymbolConfiguration(weight: weight)
        let ss = UIImage.SymbolConfiguration(scale: scale)
        return ts.applying(sw).applying(ss)
    }
    
    /// 通过font调整大小
    /// - Parameters:
    ///   - font: 字号
    ///   - scale: 缩放比例
    /// - Returns: Symbol配置
    public func sizeConfig(font: UIFont = UIFont.systemFont(ofSize: 14),
                           scale: UIImage.SymbolScale = .default) -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration(font: font, scale: scale)
    }
    
    //MARK: - 如何渲染分层SF Symbol
    
    //在iOS15和更高版本中，许多SF Symbol图标包含几个代表图标深度的层，这些层可以用一点透明度来渲染，以帮助突出图标的含义。这即使在重新着色图像时也有效——由于透明度，你只会改变颜色的深浅。
    
    @available(iOS 15.0, *)
    /// 渲染分层，指定层次颜色
    /// - Parameters:
    ///   - hierarchical: 层次颜色
    /// - Returns: Symbol配置
    public func hierConfig(color: UIColor = .systemIndigo) -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration(hierarchicalColor: color)
    }
    
    //MARK: - 如何渲染多色SF Symbol
    
    //在iOS14和以后的版本中，许多SF Symbol都有带有特定含义的内置颜色，例如“externaldrive.badge.plus”。徽章。外置驱动器使用默认颜色，但外置徽章是绿色的。默认情况下不启用这种多色绘图模式，所以你的符号将以上面讨论的颜色呈现，但是如果你愿意，你可以启用默认多色模式。
    //没有多色变体的图像将自动呈现单色，就像你没有改变设置一样。
    
    @available(iOS 15.0, *)
    /// 启用多色绘图模式
    /// - Returns: Symbol配置
    public func multiConfig() -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration.preferringMulticolor()
    }
    
    
    @available(iOS 16.0, *)
    /// 启用单色绘图模式，默认
    /// - Returns: Symbol配置
    public func monoConfig() -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration.preferringMonochrome()
    }
    
    //MARK: - 如何创建自定义SF Symbol调色板
    
    // 在iOS15之后，许多SF Symbol被分成支持两种甚至三种颜色的片段。它们的渲染方式取决于它们包含多少片段以及你提供了多少颜色：
    //如果它们有1段，它将始终使用您指定的第一种颜色；其他颜色将被忽略。
    //如果它们有2个段，并且您指定了1种颜色，这将用于两个段。如果您指定了2种颜色，每个段将使用一种。如果您指定了3种颜色，第三种将被忽略。
    //如果它们有3个段，并且您指定了1种颜色，这将用于所有三个段。如果您指定了2种颜色，第一个段将使用一种颜色，其余两个段将使用另一种颜色。如果您指定了3种颜色，每个段将使用一种颜色。
    //UIKit不能在其调色板中使用材料或渐变，只能使用颜色。
    
    @available(iOS 15.0, *)
    /// 自定义色板
    /// - Parameters:
    ///   - colors: 颜色数组
    /// - Returns: Symbol配置
    public func paletConfig(colors: [UIColor]) -> UIImage.Configuration? {
        return UIImage.SymbolConfiguration(paletteColors: colors)
    }
}
