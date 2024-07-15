//
//  SFLanguageManager.swift
//  SFKit
//
//  Created by sfh on 2023/12/4.
//

import UIKit

@objcMembers
public class SFLanguageManager: NSObject {
    
    public static let shared = SFLanguageManager()
    
    private static let kAppleLanguages = "AppleLanguages"
    
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
     
    override private init() {
        super.init()
        loadAvailableLanguages()
    }
     
    private var languageCodes: [String] = []
    /// 全部可用语言
    public private(set) var availableLanguages: [SFLanguage] = []
    /// 当前语言
    public private(set) var curLanguage: SFLanguage?
     
    private func loadAvailableLanguages() {
        guard let array = UserDefaults.standard.value(forKey: Self.kAppleLanguages) as? [String] else { return }
        languageCodes = array
        // Map函数：对集合中的所有元素进行同样的操作，并返回一个新集合
        // compactMap函数：类似于Map函数，只是CompactMap可以处理集合中的nil元素
        availableLanguages = array.compactMap {
            SFLanguage(code: $0)
        }
        availableLanguages.first?.isCurrent = true
        curLanguage = availableLanguages.first
    }
     
    /// 设置语言
    /// - Parameters:
    ///   - code: 语言码
    ///   - restart: 修改后重启
    public func setLanguage(with code: String, restart: Bool = true) {
        guard code != curLanguage?.code, let index = languageCodes.firstIndex(of: code) else { return }
        (languageCodes[0], languageCodes[index]) = (languageCodes[index], languageCodes[0])
        (availableLanguages[0], availableLanguages[index]) = (availableLanguages[index], availableLanguages[0])
        availableLanguages[index].isCurrent = false
        availableLanguages.first?.isCurrent = true
        curLanguage = availableLanguages.first
        UserDefaults.standard.setValue(languageCodes, forKey: Self.kAppleLanguages)
        guard restart else { return }
        let alert = UIAlertController(title: "修改语言后需要重启应用", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "立即重启", style: .default) { action in
            abort()
        }
        alert.addAction(action)
        WINDOW?.rootViewController?.present(alert, animated: true)
    }
}

public class SFLanguage {
    public var isCurrent: Bool = false
    public var code: String?
    public var title: String?
    
    init(code: String) {
        self.code = code
        self.title = Locale.current.localizedString(forIdentifier: code)
    }
}
