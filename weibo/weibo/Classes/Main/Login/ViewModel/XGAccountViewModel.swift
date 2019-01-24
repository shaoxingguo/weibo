//
//  XGAccountViewModel.swift
//  weibo
//
//  Created by monkey on 2019/1/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGAccountViewModel:NSObject
{
    // MARK: - 开放方法
    
    /// 单例
    public static let shared:XGAccountViewModel = XGAccountViewModel()
    
    /// 获取用户授权令牌
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调
    open func loadAccessToken(code:String,completion:@escaping (Bool,Error?) -> Void) -> Void
    {
        XGDataManager.loadAccessToken(code: code) { (accountModel, error) in
            if error != nil || accountModel == nil {
                completion(false,error)
                return
            } else {
                // 记录模型
                self.accountModel = accountModel
                // 保存模型
                NSKeyedArchiver.archiveRootObject(accountModel!, toFile: self.modelCachePath)
                // 完成回调
                completion(true,nil)
            }
        }
    }
    
    /// 用户是否登录
    open var isLogin:Bool {
        if accountModel == nil || isExpires {
            return false
        } else {
            return true
        }
    }
    
    /// 用户授权令牌
    open var accessToken:String? {
        return accountModel?.accessToken
    }
    
    /// 用户ID
    open var uid:String? {
        return accountModel?.uid
    }
    
    /// 用户昵称
    open var screenName:String? {
        return accountModel?.screenName
    }
    
    /// 用户头像(大图)
    open var avatarLarge:String? {
        return accountModel?.avatarLarge
    }
    
    
    // MARK: - 私有属性和方法
    
    private override init()
    {
        super.init()
        
        // 从文件读取用户账号模型
        if FileManager.default.fileExists(atPath: modelCachePath) {
            accountModel = NSKeyedUnarchiver.unarchiveObject(withFile: modelCachePath) as? XGAccountModel
        }
    }
    
    private var isExpires:Bool {
        // 现在时间 < 过期时间 ? token未过期 : token过期
        if Date().compare(accountModel?.expiresDate ?? Date()) != ComparisonResult.orderedAscending {
            return true
        } else {
            return false
        }        
    }
   
    /// 用户账号数据模型
    private var accountModel:XGAccountModel?
    
    // MARK: - 懒加载
    private lazy var modelCachePath:String = {
       let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
         return (cachePath as NSString).appendingPathComponent("XGAccountModel.plist")
    }()
}
