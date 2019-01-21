//
//  XGDataManager.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

class XGDataManager
{
    
}

// MARK: - 加载广告
extension XGDataManager
{
    /// 加载广告数据
    ///
    /// - Parameter completion: 完成回调
    open class func loadAdvertisementData(completion:@escaping (XGAdvertisementModel?, Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["code2": "phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"]
        XGNetworkManager.request(type: .Get, URLString: kAdvertisementAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(nil,error)
                return
            } else {
                guard let array = (responseObject as? [String:Any])?["ad"],
                    let dictionary = (array as? [[String:Any]])?.first,
                    let advertisementModel = XGAdvertisementModel.mj_object(withKeyValues: dictionary)
                    else {
                        completion(nil,error)
                        return
                }
                
                completion(advertisementModel,nil)
            }
        }
    }
}

// MARK: - 登录相关
extension XGDataManager
{
    /// 加载用户授权令牌
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调
    open class func loadAccessToken(code:String,completion:@escaping (XGAccountModel?,Error?) -> Void) -> Void
    {
        let parameters:[String:Any] = ["client_id":kAppKey,
                          "client_secret":kAppSecret,
                          "grant_type":"authorization_code",
                          "code":code,
                          "redirect_uri":kRedirectURLString]
        XGNetworkManager.request(type: .Post, URLString: kAccessTokenAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(nil,error)
                return
            } else {
                let accountModel = XGAccountModel.mj_object(withKeyValues: responseObject)
                completion(accountModel,nil)
                return
            }
        }
    }
}

// MARK: - 获取微博数据
extension XGDataManager
{
    /// 获取微博数据
    ///
    /// - Parameters:
    ///   - sinceId: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - maxId: 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
    ///   - completion: 完成回调
    open class func loadStatusList(sinceId:Int64 = 0,maxId:Int64 = 0,completion:@escaping ([XGStatusModel]?,Error?) -> Void) -> Void
    {
        var parameters:[String:Any]? = nil
        if sinceId > 0 {
            parameters = ["since_id":sinceId]
        } else if maxId > 0 {
            parameters = ["max_id":maxId]
        }
        
        accessTokenRequest(type: .Get, URLString: kHomeTimelineAPI, parameters: parameters) { (responseObject, error) in
            if error != nil {
                completion(nil,error)
                return
            } else {
                guard let dictionary = responseObject as? [String:Any],
                    let dictionaryArray = dictionary["statuses"] as? [[String:Any]] else {
                        completion(nil,error)
                        return
                }
                
                // 字典转模型
                let modelArray =  XGStatusModel.mj_objectArray(withKeyValuesArray: dictionaryArray)?.copy()
                completion(modelArray as? [XGStatusModel],nil)
            }
        }
    }
    
    
    /// 获取消息未读数
    ///
    /// - Parameter completion: 完成回调
    open class func loadUnreadCount(completion:@escaping (Int,Error?) ->Void) -> Void
    {
        let parameters = ["uid":XGAccountViewModel.shared.uid!]
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
    
    /// access_token请求
    ///
    /// - Parameters:
    ///   - type: 请求类型
    ///   - URLString: 接口地址
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    private class func accessTokenRequest(type:HttpMethodType, URLString:String,parameters:[String:Any]?,completion:@escaping (Any?,Error?) ->Void) -> Void
    {
        let accessToken = XGAccountViewModel.shared.accessToken!
        var parameters = parameters
        if parameters == nil {
            parameters = ["access_token":accessToken]
        } else {
            parameters!["access_token"] = accessToken
        }
        
        XGNetworkManager.request(type: type, URLString: URLString, parameters: parameters, completion: completion)
    }
}
