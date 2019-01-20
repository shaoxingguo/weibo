//
//  XGNetworkManager.swift
//  weibo
//
//  Created by monkey on 2019/1/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import AFNetworking

enum HttpMethodType:String
{
    case Get = "Get"
    case Post = "Post"
}

class XGNetworkManager: AFHTTPSessionManager
{
    // MARK: - 单例
    private static let sharedManager:XGNetworkManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .useProtocolCachePolicy
        let manager = XGNetworkManager(baseURL: URL(string: kBaseURLString), sessionConfiguration: config)
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html","application/json","text/json","text/javascript")
        return manager
    }()
    
    // MARK: - 请求方法
    
    /// 网络请求方法
    ///
    /// - Parameters:
    ///   - type: 方法类型
    ///   - URLString: 请求地址
    ///   - parameters: 请求参数
    ///   - completion: 完成回调
    class func request(type:HttpMethodType,URLString:String,parameters:[String:Any]?,completion:@escaping (Any?, Error?) -> Void)  -> Void
    {
        if type == HttpMethodType.Get {
            sharedManager.get(URLString, parameters: parameters, progress: nil, success: { (dataTask, responseObject) in
                completion(responseObject,nil)
            }) { (dataTask, error) in
                completion(nil,error)
            }
        } else if type == HttpMethodType.Post {
            sharedManager.post(URLString, parameters: parameters, progress: nil, success: { (dataTask, responseObject) in
                completion(responseObject,nil)
            }) { (dataTask, error) in
                completion(nil,error)
            }
        }
    }
}
