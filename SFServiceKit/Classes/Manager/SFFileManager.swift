//
//  SFFileManager.swift
//  SFServiceKit
//
//  Created by sfh on 2024/7/1.
//

import UIKit

@objcMembers
public class SFFileManager: NSObject {

    public static let shared = SFFileManager()
    
    /// 获取缓存大小 "/Library" + "/Caches" + "/tmp"
    /// - Returns: 缓存大小，单位M
    public func totalCacheSize() -> String {
        let cache1 = folderSizeAtPath(folderPath: NSHomeDirectory() + "/Library" + "/Caches")
        let cache2 = folderSizeAtPath(folderPath: NSHomeDirectory() + "/tmp")
        return String(format: "%.2fM", cache1 + cache2)
    }
    
    /// 删除所有缓存 "/Library" + "/Caches" + "/tmp"
    /// - Parameter completion: 完成闭包
    public func cleanCache(completion: () -> Void) {
        deleteFolderAtPath(folderPath: NSHomeDirectory() + "/Library" + "/Caches")
        deleteFolderAtPath(folderPath: NSHomeDirectory() + "/tmp")
        completion()
    }
    
    /// 获取路径下所有文件的大小
    /// - Parameter folderPath: 路径
    /// - Returns: 文件大小, 单位M
    public func folderSizeAtPath(folderPath: String) -> Double {
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath) { return 0 }
        let subPaths = manager.subpaths(atPath: folderPath)
        var fileSize: Double = 0
        for path in subPaths! {
            let absolutePath = folderPath + "/" + path
            fileSize += getFileSize(path: absolutePath)
        }
        return fileSize
    }
    
    /// 获取单个文件的大小
    /// - Parameter path: 路径
    /// - Returns: 文件大小, 单位M
    public func getFileSize(path: String) -> Double {
        let manager = FileManager.default
        var fileSize: Double = 0
        do {
            let attr = try manager.attributesOfItem(atPath: path)
            fileSize = Double(attr[FileAttributeKey.size] as! UInt64)
            let dict = attr as NSDictionary
            fileSize = Double(dict.fileSize())
        } catch {
            dump(error)
        }
        return fileSize/1024/1024
    }
    
    /// 删除路径下的所有文件
    /// - Parameters folderPath: 路径
    public func deleteFolderAtPath(folderPath: String) {
        let manager = FileManager.default
        if manager.fileExists(atPath: folderPath) {
            let subPaths = manager.subpaths(atPath: folderPath)
            for path in subPaths! {
                let absolutePath = folderPath + "/" + path
                deleteFile(path: absolutePath)
            }
        }
    }
    
    /// 删除单个文件
    /// - Parameter path: 路径
    public func deleteFile(path: String) {
        let manager = FileManager.default
        do {
            try manager.removeItem(atPath: path)
        } catch {}
    }
    
    
}
