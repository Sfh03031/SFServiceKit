//
//  SFGCDTimer.swift
//  SFKit
//
//  Created by sfh on 2023/12/4.
//

import UIKit

/**
 优势：DispatchSourceTimer不依赖Runloop，Runloop底层代码中也用到了DispatchSourceTimer。
 
 注意事项:
    1.当Timer创建完后，建议调用activate()方法开始运行。如果直接调用resume()也可以开始运行。
    2.suspend()的时候，并不会停止当前正在执行的event事件，而是会停止下一次event事件。
    3.当Timer处于suspend的状态时，如果销毁Timer或其所属的控制器，会导致APP奔溃。
    4.suspend()和resume()需要成对出现，挂起一次，恢复一次，如果Timer开始运行后，在没有suspend的时候，直接调用resume()，会导致APP崩溃。
    5.使用cancel()的时候，如果Timer处于suspend状态，APP崩溃。
    6.注意block的循环引用问题。
 */

public class SFGCDTimer: NSObject {
    private lazy var timer: DispatchSourceTimer? = {
        // 默认在主队列中调度使用
//        let ktimer = DispatchSource.makeTimerSource()
        // 指定在主队列中调度使用
//        let ktimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        // 指定在全局队列中调度使用
//        let ktimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        // 指定在自定义队列中调度使用
//        let ktimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue(label: "customQueue"))
        
        // delay秒之后执行任务，不重复，偏差量1毫秒
//        ktimer.schedule(deadline: .now() + delay, repeating: .never, leeway: .nanoseconds(1))
        // delay秒之后执行任务，每repeating秒执行一次，偏差量1毫秒
//        ktimer.schedule(deadline: .now() + delay, repeating: repeating, leeway: .nanoseconds(1))
        
        // 设置任务，包括一次性任务和定时重复任务，回调方法在子线程中执行
//        ktimer.setEventHandler { [weak self] in
//            DispatchQueue.main.async {
//                self?.handler()
//            }
//        }
        
        // 此方法设置的任务只会执行一次，在Timer就绪后开始运行的时候执行，类似于Timer开始的一个通知回调，回调方法在子线程中执行
//        ktimer.setRegistrationHandler { [weak self] in
//            DispatchQueue.main.async {
//                self?.handler()
//            }
//        }
        
        let ktimer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        ktimer.schedule(deadline: .now() + delay, repeating: repeating, leeway: .nanoseconds(1))
        ktimer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.handler()
            }
        }
        return ktimer
    }()
    
    /// 队列
    private var queue: DispatchQueue
    /// 任务开始前延迟秒数
    private var delay: Double
    /// 任务执行间隔
    private var repeating: DispatchTimeInterval
    /// 执行的任务回调
    private var handler: () -> Void
    
    /// 计时器是否正在运行
    private var isRunning: Bool = false
    
    /// 初始化
    /// - Parameters:
    ///   - queue: 默认全局队列
    ///   - delay: 几秒后开始执行任务
    ///   - repeating: 几秒执行一次
    ///   - handler: 执行事件回调
    public init(queue: DispatchQueue = DispatchQueue.global(), delay: Double, repeating: DispatchTimeInterval, handler: @escaping () -> Void) {
        self.queue = queue
        self.delay = delay
        self.repeating = repeating
        self.handler = handler
    }
    
    /// 开始
    @objc public func start() {
        guard !isRunning else { return }
        timer?.resume()
        isRunning = true
    }
    
    /// 暂停
    @objc public func pause() {
        guard isRunning else { return }
        timer?.suspend()
        isRunning = false
    }
    
    /// 结束
    @objc public func cancel() {
        pause()
        timer?.resume()
        timer?.cancel()
        timer = nil
    }
}
