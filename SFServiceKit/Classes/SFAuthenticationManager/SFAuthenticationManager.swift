//
//  SFAuthenticationManager.swift
//  SFKit
//
//  Created by sfh on 2023/12/2.
//

import LocalAuthentication
import UIKit

/**
 所需权限:
    Privacy - Face ID Usage Description
 
 1.LAPolicyDeviceOwnerAuthenticationWithBiometrics 生物识别

 针对TouchID.首先弹出识别的弹窗，当第一次指纹解锁失败时弹框会变成两个按钮，第二个按钮可以自定义标题，如上述的代码的localizedFallbackTitle。另外还可以自定义点击事件，即上述代码的if (error.code == kLAErrorUserFallback){ NSLog(@"用户选择了另一种方式"); }.输错三次密码会，弹框会消失，此时还可再进行验证，如若接下来两次的指纹之别都错误的话，此时TouchID会被锁住，必须得到设置里解锁才能重新再次识别，TouchID被锁住的状态也可以监听到，如上述代码的case LAErrorBiometryLockout:{ NSLog(@"TouchID lock out"); break; }

 当设备支持FaceID时，此时会调用FaceID识别，注意两次识别错误后弹框才会出现自定义标题的的按钮选项,设置方式与TouchID相同。5次识别错误后，FaceID会被锁住，也无法再进行识别了，必须到设置里解锁才能再次进行识别。

 2.LAPolicyDeviceOwnerAuthentication 生物识别+密码认证

 针对TouchID。优先调用TouchID识别，如果三次识别错误后，则会弹出系统密码验证，输入设备密码来解锁。如果不输入设备密码，还有两次机会调用指纹识别，如果都失败的话，TouchID会被锁住，则接下来每次调用识别的话，都是调用系统密码验证。

 当设备支持FaceID时,优先调用FaceID识别，有5次输入机会，当5次识别失败后FaceID会被锁住，之后每次调用识别都会弹出系统密码验证

 kLAErrorUserCancel   用户取消
 kLAErrorPasscodeNotSet  未设置系统密码
 LAErrorBiometryLockout   生物识别被锁住，指TouchID或FaceID识别次数达到最大次数(5次)
 kLAErrorUserFallback  上述所说自定义按钮标题时,点击是的错误码，可在此设置自定义的点击事件
 LAErrorSystemCancel  另一个App进入到了前台
 LAErrorTouchIDNotAvailable  TouchID不可用
 LAErrorTouchIDNotEnrolled    未设置TouchID
 LAErrorTouchIDLockout    TouchID被锁住 建议判断LAErrorBiometryLockout即可
 */

@objcMembers
public class SFAuthenticationManager: NSObject {
    
    public static let shared = SFAuthenticationManager()
    
    private lazy var context: LAContext = {
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        context.localizedFallbackTitle = "输入密码"
        return context
    }()

    private var error: NSError?

    /// 是否可用
    public func isValid() -> LAError? {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return nil
        } else {
            return error as? LAError
        }
    }

    /// 进行验证
    /// - Parameters:
    ///   - canPassword: 演示失败后是否可以进行密码验证
    ///   - complete: 验证结果
    public func evaluate(canPassword: Bool, complete: @escaping (Bool, LAError?) -> Void) {
        if let error = isValid() {
            complete(false, error)
            return
        }
        let policy: LAPolicy = canPassword ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics
        context.evaluatePolicy(policy, localizedReason: "输入密码") { success, error in
            DispatchQueue.main.async {
                complete(success, error as? LAError)
            }
        }
    }

}

public extension LAError {
    var descText: String {
        switch code {
        case .authenticationFailed:
            return "连续三次输入错误，身份验证失败"
        case .biometryNotEnrolled:
            return "未设置FaceID或TouchID"
        case .biometryNotAvailable:
            return "FaceID或TouchID不可用"
        case .passcodeNotSet:
            return "未设置系统密码"
        case .biometryLockout:
            return "解锁次数已用尽, 已锁定" // 5次
        case .systemCancel:
            return "系统取消"
        case .userCancel:
            return "用户取消"
        case .userFallback:
            return "用户点击输入密码"
        default:
            return "验证失败"
        }
    }
}
