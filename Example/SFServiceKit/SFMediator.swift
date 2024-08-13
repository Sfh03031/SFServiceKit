//
//  SFMediator.swift
//  SFServiceKit_Example
//
//  Created by sfh on 2024/8/6.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import CoreGraphics

public class SFMediator: NSObject {

    public var cachedTarget: [String: Any] = [:]
    
    public static let shared = SFMediator()
    
//    private func safePerformAction(action: Selector, target: NSObject, params: [String: Any]) -> Any? {
//        let methodSig = target.method(for: action)
//        if methodSig == nil {
//            return nil
//        }
//    }
    
}
