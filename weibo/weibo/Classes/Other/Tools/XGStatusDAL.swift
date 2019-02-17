//
//  XGStatusDAL.swift
//  weibo
//
//  Created by monkey on 2019/2/11.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGStatusDAL
{
    /// 单例
    public static let shared:XGStatusDAL = XGStatusDAL()
    
    // MARK: - 构造方法
    
    private init()
    {
        // 设置缓存路径
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        cachePath = (document as NSString).appendingPathComponent("status.db")
        
        // 打开数据库
        SQLiteManager = XGSQLiteManager(path: cachePath)
        
        // 创建数据表
        if let filePath = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: filePath) {
            _ = SQLiteManager.createTables(sql: sql)
        }
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundAction), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 监听方法
    
    /// 应用程序进入后台通知监听事件
    @objc private func applicationDidEnterBackgroundAction() -> Void
    {
        clearCache()
    }
    
    // MARK: - 私有属性
    
    /// 数据库管理
    private var SQLiteManager:XGSQLiteManager
    /// 微博数据缓存路径
    private var cachePath:String
    /// 最大缓存时间3天
    private let kMaxCacheTime:CFTimeInterval = -3 * 24 * 60 * 60
}

// MARK: - 加载广告

extension XGStatusDAL
{
    /// 加载广告数据
    ///
    /// - Parameter completion: 完成回调
    open func loadAdvertisementData(completion:@escaping ([String:Any]?, Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["code2": "phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"]
        XGNetworkManager.request(type: .Get, URLString: kAdvertisementAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(nil,error)
                return
            } else {
                let array = (responseObject as? [String:Any])?["ad"]
                let dictionary = (array as? [[String:Any]])?.first
                completion(dictionary,nil)
            }
        }
    }
}

// MARK: - 登录相关

extension XGStatusDAL
{
    /// 加载用户授权令牌
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调
    open func loadAccessToken(code:String,completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["client_id":kAppKey,
                                       "client_secret":kAppSecret,
                                       "grant_type":"authorization_code",
                                       "code":code,
                                       "redirect_uri":kRedirectURLString]
        XGNetworkManager.request(type: .Post, URLString: kAccessTokenAPI, parameters: parameters) { (responseObject, error) in
            if error != nil || responseObject == nil {
                completion(nil,error)
                return
            } else {
                
                // 加载用户个人信息
                if var responseObject = responseObject as? [String:Any],
                    let accessToken = responseObject["access_token"] as?String,
                    let uid = responseObject["uid"] as? String {
                    self.loadUserInfo(userId: uid, accessToken: accessToken, completion: { (userInfo, error) in
                        if error != nil || userInfo == nil {
                            completion(nil,error)
                            return
                        }
                        
                        // 合并字典信息
                        for (key,value) in userInfo! {
                            responseObject[key] = value
                        }
                        
                        completion(responseObject,nil)
                    })
                }
            }
        }
    }
    
    private func loadUserInfo(userId:String,accessToken:String, completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters = ["uid":userId,"access_token":accessToken]
        XGNetworkManager.request(type: .Get, URLString: kUserInfoAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(nil,error)
                return
            } else {
                completion(responseObject as? [String : Any],nil)
            }
        }
    }
}

// MARK: - 获取微博数据

extension XGStatusDAL
{
    /// 获取微博数据
    ///
    /// - Parameters:
    ///   - sinceId: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - maxId: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    open func loadStatusList(sinceId:Int64 = 0,maxId:Int64 = 0,completion:@escaping ([[String:Any]]?,Error?) -> Void) -> Void
    {
        // 数据库加载微博数据
        let statusList = loadStatusListFromCache(userId: XGAccountViewModel.shared.uid, sinceId: sinceId, maxId: maxId)
        if statusList.count > 0 {
            completion(statusList,nil)
            XGPrint("数据库加载\(statusList.count)条数据")
            return
        }
        
        // 网络加载微博数据
        var parameters:[String:Any]? = nil
        if sinceId > 0 {
            parameters = ["since_id":sinceId]
        } else if maxId > 0 {
            parameters = ["max_id":maxId]
        }
        
        accessTokenRequest(type: .Get, URLString: kHomeTimelineAPI, parameters: parameters) { (responseObject, error) in
            if error != nil || responseObject == nil {
                completion(nil,error)
                return
            } else {
                let dictionary = responseObject as? [String:Any]
                let statusListArray = dictionary?["statuses"] as? [[String:Any]]
                // 缓存数据
                self.saveStatusListToCache(statusList: statusListArray)
                XGPrint("网络加载\(statusListArray?.count ?? 0)条数据")
                // 完成回调
                completion(statusListArray,nil)
            }
        }
    }
    
    /// 获取消息未读数
    ///
    /// - Parameter completion: 完成回调
    open func loadUnreadCount(completion:@escaping (Int,Error?) ->Void) -> Void
    {
        guard let uid = XGAccountViewModel.shared.uid else {
            completion(0,NSError(domain: "error", code: 100000003, userInfo: ["reason" : "uid为空!"]))
            return
        }
        
        let parameters = ["uid":uid]
        accessTokenRequest(type: .Get, URLString: kUnreadCountAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(0,error)
                return
            } else {
                guard let dictionary = responseObject as? [String:Any],
                    let count = dictionary["status"] as? Int else {
                        completion(0,error)
                        return
                }
                
                completion(count,nil)
            }
        }
    }
    
    /// 获取微博官方表情的详细信息
    ///
    /// - Parameter completion: 完成回调
    open func loadEmotionsList(completion:@escaping ([[String:Any]]?,Error?) ->Void) -> Void
    {
        accessTokenRequest(type: .Get, URLString: kEmotionsAPI, parameters: nil) { (responseObject, error) in
            if error != nil || responseObject == nil {
                completion(nil,error)
                return
            } else {
                 let dictArray = responseObject as? [[String:Any]]
                completion(dictArray,nil)
            }
        }
    }
    
    /// access_token请求
    ///
    /// - Parameters:
    ///   - type: 请求类型
    ///   - URLString: 接口地址
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    private func accessTokenRequest(type:HttpMethodType, URLString:String,parameters:[String:Any]?,completion:@escaping (Any?,Error?) ->Void) -> Void
    {
        // 追加参数
        var parameters = parameters
        if !appendAccessToken(parameters: &parameters) {
            completion(nil,NSError(domain: "error", code: 100000002, userInfo: ["reason" : "accessToken为空!"]))
            return
        }
        
        // 发送网络请求
        XGNetworkManager.request(type: type, URLString: URLString, parameters: parameters, completion: completion)
    }
    
    /// 追加access_token参数
    private func appendAccessToken(parameters:inout [String:Any]?) -> Bool
    {
        guard let accessToken = XGAccountViewModel.shared.accessToken else {
            return false
        }
        
        if parameters == nil {
            parameters = ["access_token":accessToken]
        } else {
            parameters!["access_token"] = accessToken
        }
        
        return true
    }
    
    /// 从本地缓存数据库中加载微博数据
    private func loadStatusListFromCache(userId:String?,sinceId:Int64 = 0,maxId:Int64 = 0) -> [[String:Any]]
    {
        var statusList = [[String:Any]]()
        guard let userId = userId else {
            return statusList
        }
        
        var sql = "SELECT userId,statusId,status FROM T_status\n"
        sql += "WHERE userId = \(userId)\n"
        if sinceId > 0 {
            sql += "AND statusId > \(sinceId)\n"
        } else if maxId > 0 {
            sql += "AND statusId < \(maxId)\n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20;"
        let result = SQLiteManager.query(sql: sql)
        
        for dictionary in result {
            if let str = dictionary["status"] as? String,
               let data = str.data(using: .utf8),
               let status = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any]  {
                statusList.append(status)
            }
        }
        
        return statusList
    }
    
    /// 将微博数据保存至本地数据库缓存
    private func saveStatusListToCache(statusList:[[String:Any]]?)
    {
        guard let statusList = statusList,
        let userId = XGAccountViewModel.shared.uid else {
            return
        }
        
        for status in statusList {
            if JSONSerialization.isValidJSONObject(statusList) {
                if let data = try? JSONSerialization.data(withJSONObject: status, options: [.prettyPrinted]),
                    let str = String(data: data, encoding: .utf8),
                    let statusId  = status["id"] as? Int64 {
                    let sql = "INSERT OR REPLACE INTO T_status (userId,statusId,status) VALUES (?,?,?);"
                    _ = SQLiteManager.insert(sql: sql, arguments: [userId,statusId,str])
                }
            }
        }
    }
    
    /// 清除过期数据
    private func clearCache() -> Void
    {
        let dateStr = Date.dateToString(sinceNow: kMaxCacheTime)
        let sql = "DELETE FROM T_status WHERE createTime < ?;"
        _ = SQLiteManager.delete(sql: sql, arguments: [dateStr])
    }
}

// MARK: - 发送微博

extension XGStatusDAL
{
    
    /// 发送微博
    ///
    /// - Parameters:
    ///   - text: 微博文字
    ///   - imageData: 图片数据
    ///   - completion: 完成回调
    open func sendStatus(text:String,imageData:Data?,completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let statusText = text + "\nhttp://www.weibo.com/"
        if let imageData = imageData {
            // 发送图片微博
            sendImageStatus(text: statusText, imageData: imageData, completion: completion)
        } else {
            // 发送纯文本微博
            sendTextStatus(text: statusText, completion: completion)
        }
    }
    
    /// 发送纯文本微博
    private func sendTextStatus(text:String,completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        let parameters = ["status":text]
        accessTokenRequest(type: .Post, URLString: kShareAPI, parameters: parameters) { (responseObject, error) in
            if error != nil || responseObject == nil {
                completion(nil,error)
                return
            }
            
            completion(responseObject as? [String:Any],nil)
        }
    }
    
    /// 发送带图片微博
    private func sendImageStatus(text:String,imageData:Data,completion:@escaping ([String:Any]?,Error?) -> Void) -> Void
    {
        var parameters:[String:Any]? = ["status":text]
        if appendAccessToken(parameters: &parameters) {
            XGNetworkManager.uploadFile(URLString: kShareAPI, parameters: parameters, fileData: imageData, filedName: "pic") { (responseObject, error) in
                if error != nil || responseObject == nil {
                    completion(nil,error)
                    return
                }
                
                completion(responseObject as? [String:Any],nil)
            }
        }
    }
}

