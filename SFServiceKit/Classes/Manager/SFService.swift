//
//  SFService.swift
//  SFServiceKit
//
//  Created by sfh on 2024/7/1.
//

import Foundation

public enum SFService {
    
    public static var WINDOW: UIWindow? {
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
}
