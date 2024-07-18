//
//  ViewController.swift
//  SFServiceKit
//
//  Created by SparkeXHApp on 07/01/2024.
//  Copyright (c) 2024 SparkeXHApp. All rights reserved.
//

import UIKit
import SFServiceKit

class ViewController: UIViewController {

    var timeCount: Int = 0
    var gcdTimer: SFGCDTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            print("SFDisplayModeManager.shared.currentMode: \(SFDisplayModeManager.shared.currentMode)")
            print("SFLanguageManager.shared.availableLanguages: \(SFLanguageManager.shared.availableLanguages)")
            print("SFLanguageManager.shared.curLanguage: \(String(describing: SFLanguageManager.shared.curLanguage?.isCurrent)) = \(String(describing: SFLanguageManager.shared.curLanguage?.code)) = \(String(describing: SFLanguageManager.shared.curLanguage?.title))")
            
            SFLocationManager.shared.start(false) { location in
                print("location?.addressDesc: \(String(describing: location?.addressDesc))")
                print("location?.latitude: \(String(describing: location?.latitude))")
                print("location?.longitude: \(String(describing: location?.longitude))")
            }
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 15.0, *) {
            let config = SFSymbolManager.shared.sizeConfig(font: UIFont.systemFont(ofSize: 30.0, weight: .medium), scale: .default)
            let config1 = SFSymbolManager.shared.multiConfig()
            let combined = config?.applying(config1)
            let img = SFSymbolManager.shared.symbol(systemName: "arrowshape.turn.up.backward.circle", withConfiguration: combined, withTintColor: nil)
            
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imgView.center = self.view.center
            imgView.image = img
            imgView.accessibilityLabel = "Go back"// 画外音或简称
            self.view.addSubview(imgView)
            
        }
        
        print("SFFileManager.shared.totalCacheSize: \(SFFileManager.shared.totalCacheSize())")
        
        SFAuthenticationManager.shared.evaluate(canPassword: true) { iscan, error in
            print("iscan: \(iscan)")
            if iscan {
                print("验证通过...")
            } else {
                print("验证失败: \(error?.descText as Any)")
            }
            
        }
        
        gcdTimer = SFGCDTimer.init(delay: 5, repeating: .seconds(2), handler: { [weak self] in
            guard let self = self else { return }
            self.timeCount += 1
            self.check(count: self.timeCount)
            
        })
        gcdTimer?.start()
    }
    
    func check(count: Int) {
        print("timeCount: \(timeCount)")
        if timeCount >= 15 {
            self.gcdTimer?.cancel()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

