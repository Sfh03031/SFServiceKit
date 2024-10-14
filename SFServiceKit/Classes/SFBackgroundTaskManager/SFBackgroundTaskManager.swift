//
//  SFBackgroundTaskManager.swift
//  SFBackgroundTaskManager
//
//  Created by sfh on 2024/6/11.
//

import UIKit
import Foundation
import AVFoundation

/**
 Background Modes:
    Audio,AirPlay,and Picture in Picture
 
 应用进入后台调用:
    SFBackgroundTaskManager.shared.start()
 应用进入前台调用:
    SFBackgroundTaskManager.shared.stop()
 
 原理:
    申请时间(系统限制一般为30秒)执行一段后台任务(播放无声音乐)并返回任务id，任务结束回调中必须结束该后台任务，否则系统会杀死App；在结束回调中再次申请时间执行一段后台任务，系统会开始新的申请，重复此过程以达到保活的目的。
 
 注意:
    1.被挂起的程序，在系统资源不够的时候也会被杀死
    2.如果应用退到后台长时间不被杀死，长时间静默播放无声音频会累积消耗大量的设备电量，风险自行评估
 */

@objcMembers 
public class SFBackgroundTaskManager: NSObject {
    
    public static let shared = SFBackgroundTaskManager.init()
    
    private var audioPlayer: AVAudioPlayer!
    private var bgTask: UIBackgroundTaskIdentifier!
    
    /// 累积保活时长
    private var seconds: Int = 0
    /// 在多长时间段内保活，默认为2小时
    private var limit: Int = 2
    /// 计时器，计算时长
    private var taskTimer: Timer?
    
    public override init() {
        super.init()
        
        self.setupAudioSession()
        self.setupAudioPlayer()
    }
    
    //MARK: - public
    
    /// 开始
    /// - Parameters:
    ///   - limit: 在多长时间内保活，默认2小时
    ///   - isAutoStop: 是否在限制时间内保活，默认为true，设置为false则会一直保持保活状态，长时间保活会消耗设备大量电量，风险自行评估
    public func start(_ limit: Int? = 2, isAutoStop: Bool = true) {
        self.audioPlayer.play()
        self.applyForBackgroundTask()
        if isAutoStop {
            self.seconds = 0
            self.limit = limit ?? 2
            taskTimer = Timer(timeInterval: 1, target: self, selector: #selector(taskKeeped), userInfo: nil, repeats: true)
        }
    }
    
    /// 结束
    public func stop() {
        self.audioPlayer.stop()
        if self.bgTask != nil {
            UIApplication.shared.endBackgroundTask(self.bgTask)
        }
    }
    
    //MARK: - private
    
    /// 计算保活时长，超过限制停止保活
    @objc fileprivate func taskKeeped() {
        self.seconds += 1
        if self.seconds > self.limit * 60 * 60 {
            self.stop()
            self.taskTimer?.invalidate()
            self.taskTimer = nil
        }
    }
    
    /// 申请后台任务
    fileprivate func applyForBackgroundTask() {
#if DEBUG
        print("UIApplication.shared.backgroundTimeRemaining: \(UIApplication.shared.backgroundTimeRemaining)")
#endif
        self.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            if self.bgTask != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(self.bgTask)
                self.bgTask = UIBackgroundTaskIdentifier.invalid
            }
            self.start()
        })
    }
    
    /// 配置AVAudioSession
    fileprivate func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } catch let error as NSError {
#if DEBUG
            print("Error setCategory AVAudioSession: \(error.debugDescription)")
#endif
        }
        
        do {
            // 如果一个前台app正在播放音频则可能会启动失败
            try audioSession.setActive(true)
        } catch let error as NSError {
#if DEBUG
            print("Error activating AVAudioSession: \(error.debugDescription)")
#endif
        }
    }
    
    /// 配置AVAudioPlayer
    fileprivate func setupAudioPlayer() {
        // MARK: 与自身所在的bundle保持一致，否则会因找不到资源而崩溃，当前在子库Bgtask下
        let bundlePath = Bundle(for: self.classForCoder).path(forResource: "Bgtask", ofType: "bundle")
        let bundle = Bundle(path: bundlePath ?? "")
        let filePath = bundle?.path(forResource: "Silence", ofType: "wav")
        let fileUrl = URL.init(fileURLWithPath: filePath ?? "")
        
        self.audioPlayer = try? AVAudioPlayer(contentsOf: fileUrl)
        self.audioPlayer.volume = 0 //静音
        self.audioPlayer.numberOfLoops = 1 //播放一次
        self.audioPlayer.prepareToPlay()
    }
}
