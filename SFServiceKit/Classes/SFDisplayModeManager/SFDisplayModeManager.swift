//
//  SFDisplayModeManager.swift
//  SFKit
//
//  Created by sfh on 2023/12/2.
//

import UIKit

@available(iOS 13.0, *)
public class SFDisplayModeManager: NSObject {
    
    public static let shared = SFDisplayModeManager()
    
    private var WINDOW: UIWindow? {
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                let sence = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
                let window = sence?.windows.first(where: { $0.isKeyWindow })
                return window
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 当前模式
    public var currentMode: SFDisplayMode {
        guard let style = WINDOW?.overrideUserInterfaceStyle else { return .flowSystem(.light) }
        if style == .unspecified {
            return .flowSystem(SFDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue))
        }
        return SFDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue)
    }
    
    private static let kDisplayModeKey = "kDisplayModeKey"
    
    override private init() {
        super.init()
        if let value = UserDefaults.standard.value(forKey: Self.kDisplayModeKey) as? Int {
            setDisplayMode(SFDisplayMode.makeMode(value))
        }
    }
    
    /// 设置显示模式
    public func setDisplayMode(_ model: SFDisplayMode) {
        var realMode = model
        switch model {
        case .flowSystem:
            realMode = .flowSystem(SFDisplayMode.makeMode(UITraitCollection.current.userInterfaceStyle.rawValue))
            UserDefaults.standard.removeObject(forKey: Self.kDisplayModeKey)
        default:
            UserDefaults.standard.setValue(model.rawValue, forKey: Self.kDisplayModeKey)
        }
        WINDOW?.overrideUserInterfaceStyle = realMode.userInterfaceStyle
    }
}

@available(iOS 13.0, *)
public enum SFDisplayMode {
    // indirect 此case是可递归的，可以调用自身
    indirect case flowSystem(SFDisplayMode?)
    case light
    case dark
    
    public var rawValue: Int {
        switch self {
        case .flowSystem:
            return 0
        case .light:
            return 1
        case .dark:
            return 2
        }
    }
    
    public static func makeMode(_ value: Int) -> SFDisplayMode {
        switch value {
        case 1:
            return .light
        case 2:
            return .dark
        default:
            return .flowSystem(.light)
        }
    }
    
    public var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .flowSystem:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
