//
//  SFIAPManager.swift
//  SFServiceKit_Example
//
//  Created by sfh on 2024/8/12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

/*注意事项：
 1.沙盒环境测试appStore内购流程的时候，请使用没越狱的设备。
 2.请务必使用真机来测试，一切以真机为准。
 3.项目的Bundle identifier需要与您申请AppID时填写的bundleID一致，不然会无法请求到商品信息。
 4.如果是你自己的设备上已经绑定了自己的AppleID账号请先注销掉,否则你哭爹喊娘都不知道是怎么回事。
 5.订单校验 苹果审核app时，仍然在沙盒环境下测试，所以需要先进行正式环境验证，如果发现是沙盒环境则转到沙盒验证。
 识别沙盒环境订单方法：
 1.根据字段 environment = sandbox。
 2.根据验证接口返回的状态码,如果status=21007，则表示当前为沙盒环境。
 苹果反馈的状态码：
 21000 App Store无法读取你提供的JSON数据
 21002 订单数据不符合格式，数据缺失了
 21003 订单无法被验证
 21004 你提供的共享密钥和账户的共享密钥不一致
 21005 订单服务器当前不可用
 21006 订单是有效的，但订阅服务已经过期。当收到这个信息时，解码后的收据信息也包含在返回内容中
 21007 订单信息是测试用（sandbox），但却被发送到产品环境中验证
 21008 订单信息是产品环境中使用，但却被发送到测试环境中验证
 */

import UIKit
import StoreKit

/// PurchType
public enum SFPurchType: CaseIterable {
    case success
    case failed
    case cancel
    case checkSuccess
    case checkFailed
    case notAllowed
}

public enum IAP {
    /// 交易凭证验证的正式地址
    public static var ReleasePath: String {
        "https://buy.itunes.apple.com/verifyReceipt"
    }
    /// 交易凭证验证的沙盒测试地址
    public static var SandboxPath: String {
        "https://sandbox.itunes.apple.com/verifyReceipt"
    }
}

public class SFIAPManager: NSObject {
    /// 单例
    public static let shared = SFIAPManager()
    /// 商品id
    private(set) var productID: String?
    /// 提交交易凭证到后台服务器的回调
    private(set) var callBack: ((String?) -> Void)?
    /// 发起内购的回调
    private(set) var handle: ((SFPurchType, Data?) -> Void)?
    
    public override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    /// 发起内购
    /// - Parameters:
    ///   - productID: 商品id
    ///   - callBack: 提交交易凭证到后台服务器的回调
    ///   - complete: 发起内购的回调
    public func startPurch(_ productID: String?, callBack: ((String?) -> Void)?, complete: ((SFPurchType, Data?) -> Void)?) {
        if let value = productID {
            if SKPaymentQueue.canMakePayments() {
                self.productID = value
                self.callBack = callBack
                self.handle = complete
                let request = SKProductsRequest(productIdentifiers: [value])
                request.delegate = self
                request.start()
            } else {
                self.handleAction(.notAllowed, data: nil)
            }
        } else {
            self.handleAction(.notAllowed, data: nil)
        }
    }
}

extension SFIAPManager {
    fileprivate func handleAction(_ type: SFPurchType, data d:Data?) {
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
            break
        case .checkFailed:
            print("订单校验失败")
            break
        case .notAllowed:
            print("不允许程序内付费")
            break
        }
        
        self.handle?(type, d)
    }
    
    /// 完成交易
    /// - Parameter transaction: 交易凭证
    fileprivate func completeTransaction(_ transaction: SKPaymentTransaction) {
        let productIdentifier = transaction.payment.productIdentifier
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return }
        let traReceiptData = try? Data.init(contentsOf: receiptUrl)
        let receipt = traReceiptData?.base64EncodedString(options: .lineLength64Characters)
        
        if productIdentifier.count > 0 {
            // 把购买凭证回调出去，传给后台，后台传给苹果服务器进行校验
            // 用URLSession实现，AFN等第三方在内部对数据进行反序列化时丢失了数据容易造成21002（苹果服务器返回的状态码，代表数据缺失）
            self.callBack?(receipt)
            
//            var param: [String: Any] = [:]
//            param.updateValue(receipt ?? "", forKey: "mapJsonStr")
//            var request = URLRequest(url: URL.init(string: "https://xxxx.xxxxxx.xx/common/getApplePayResult")!)
//            request.httpMethod = "POST"//请求方法
//            request.addValue("", forHTTPHeaderField: "token")//请求头
//            //拼接字符串
//            var paramStr = NSMutableString()
//            var pos: Int = 0
//            for key in param.keys {
//                let value = param[key] as? String ?? ""
//                paramStr.append("\(key)=\(value)")
//                if pos < param.keys.count - 1 {
//                    paramStr.append("&")
//                }
//                pos += 1
//            }
//            
//            let paramData = paramStr.data(using: String.Encoding.utf8.rawValue)//转换数据类型
//            request.httpBody = paramData//请求体
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if error != nil {
//                    print("凭证发送失败")
//                } else {
//                    print("凭证发送成功")
//                }
//            }.resume()
        }
        
        self.verifyPruchase(transaction, isTestServer: false)
    }
    
    /// 交易失败
    /// - Parameter transaction: 交易凭证
    fileprivate func failedTransaction(_ transaction: SKPaymentTransaction) {
        self.handleAction(.failed, data: nil)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    /// 交易验证
    /// - Parameters:
    ///   - transaction: 交易凭证
    ///   - istest: 是否是测试服务器
    fileprivate func verifyPruchase(_ transaction: SKPaymentTransaction, isTestServer istest: Bool) {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return }
        let receipt = try? Data.init(contentsOf: receiptUrl)
        
        //交易凭证为空，验证失败
        if receipt == nil {
            self.handleAction(.failed, data: nil)
            return
        }
        //购买成功将交易凭证发送给苹果服务器进行再次校验
        self.handleAction(.success, data: receipt)
        
        let param = ["receipt-data": receipt!.base64EncodedString(options: .lineLength64Characters)] as [String: Any]
        guard let requestData = try? JSONSerialization.data(withJSONObject: param) else {
            // 交易凭证为空，验证失败
            self.handleAction(.failed, data: nil)
            return
        }
        
        let path = istest ? IAP.SandboxPath : IAP.ReleasePath
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        request.httpBody = requestData
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 无法连接服务器或返回数据为空，校验失败
            if error != nil || data == nil {
                self.handleAction(.checkFailed, data: nil)
            } else {
                guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] else {
                    self.handleAction(.checkFailed, data: nil)
                    return
                }
                // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
                let status = json["status"] as? String ?? ""
                if status == "21007" {
                    self.verifyPruchase(transaction, isTestServer: true)
                } else if status == "0" {
                    self.handleAction(.checkSuccess, data: nil)
                }
            }
        }.resume()
        // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

// MARK: - SKPaymentTransactionObserver
extension SFIAPManager: SKPaymentTransactionObserver {
    /// 监听购买状态的回调
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.completeTransaction(transaction)
                break
            case .purchasing:
                print("------商品被添加进购买列表------")
                break
            case .restored:
                print("------已经购买过商品------")
                // 消耗型商品不支持恢复购买
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                self.failedTransaction(transaction)
                break
            default:
                break
            }
        }
    }
}

// MARK: - SKProductsRequestDelegate
extension SFIAPManager: SKProductsRequestDelegate {
    /// 商品信息回调
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let list = response.products
        if list.count <= 0 {
            print("没有商品")
            return
        }
        
        var p: SKProduct? = nil
        for product in list {
            if product.productIdentifier == self.productID {
                p = product
                break
            }
        }
        
        print("产品ID：\(response.invalidProductIdentifiers)")
        print("数量：\(list.count)")
        print("商品描述：\(String(describing: p?.description))")
        print("本地标题：\(String(describing: p?.localizedTitle))")
        print("本地描述：\(String(describing: p?.localizedDescription))")
        print("价格：\(String(describing: p?.price))")
        print("标识：\(String(describing: p?.productIdentifier))")
        
        //发送购买请求
        if p != nil {
            let payment = SKPayment.init(product: p!)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    /// 请求商品信息失败回调
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("-------请求商品信息失败------: \(error)")
    }
    
    /// 请求结束的回调
    public func requestDidFinish(_ request: SKRequest) {
        print("------请求结束------")
    }
}
