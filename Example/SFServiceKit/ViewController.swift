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
        
        
        SFIAPManager.shared.startPurch("111") { [weak self] receipt in
            self?.postReceiptToService(receipt)
        } complete: { type, data in
            switch type {
            case .success:
                print("购买成功")
                break
            case .failed:
                print("购买失败")
                break
            case .cancel:
                print("取消购买")
                break
            case .checkSuccess:
                print("订单校验成功")
                // 后续业务逻辑...
                break
            case .checkFailed:
                print("订单校验失败")
                break
            case .notAllowed:
                print("不允许程序内付费")
                break
            }
        }

    }
    
    func check(count: Int) {
        print("timeCount: \(timeCount)")
        if timeCount >= 15 {
            self.gcdTimer?.cancel()
        }
    }
    
    /// 把购买凭证传给后台，后台传给苹果服务器进行校验
    /// 用URLSession实现，AFN等第三方在内部对数据进行反序列化时丢失了数据容易造成21002（苹果服务器返回的状态码，代表数据缺失）
    /// - Parameter receipt: 交易凭证
    func postReceiptToService(_ receipt: String?) {
        guard let value = receipt else {
            print("交易凭证为空")
            return
        }
        
        var param: [String: Any] = [:]
        param.updateValue(value, forKey: "mapJsonStr")
        //拼接字符串
        var paramStr = NSMutableString()
        var pos: Int = 0
        for key in param.keys {
            let value = param[key] as? String ?? ""
            paramStr.append("\(key)=\(value)")
            if pos < param.keys.count - 1 {
                paramStr.append("&")
            }
            pos += 1
        }
        //转换数据类型
        let paramData = paramStr.data(using: String.Encoding.utf8.rawValue)
        //创建请求
        var path = "https://xxxx.xxxxxx.xx/common/getApplePayResult"
        var request = URLRequest(url: URL.init(string: path)!)
        request.httpMethod = "POST"//请求方法
        request.addValue("", forHTTPHeaderField: "token")//请求头
        request.httpBody = paramData//请求体
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("凭证发送失败")
            } else {
                print("凭证发送成功")
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

