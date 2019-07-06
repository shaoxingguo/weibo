//
//  XGNetworkManager.swift
//  weibo
//
//  Created by monkey on 2019/1/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import AFNetworking

public enum HttpMethodType:String
{
    case Get = "Get"
    case Post = "Post"
}

class XGNetworkManager: AFHTTPSessionManager
{
    // MARK: - 单例
    
    public static let sharedManager:XGNetworkManager = {
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
    open class func request(type:HttpMethodType,URLString:String,parameters:[String:Any]?,completion:@escaping (Any?, Error?) -> Void)  -> Void
    {
        let successCompletion = { (dataTask:URLSessionDataTask?,responseObject:Any?) -> Void in
            completion(responseObject,nil)
        }
        
        let failureCompletion = { (dataTask:URLSessionDataTask?,error:Error?) ->Void in
            let response = dataTask?.response as? HTTPURLResponse
            if response?.statusCode == 403 {
                // token过期
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAccessTokenTimeOutNotification), object: nil, userInfo: nil)
            }
            
            completion(nil,error)
        }
        
        if type == HttpMethodType.Get {
            sharedManager.get(URLString, parameters: parameters, progress: nil, success: successCompletion, failure: failureCompletion)
        } else if type == HttpMethodType.Post {
           sharedManager.post(URLString, parameters: parameters, progress: nil, success: successCompletion, failure: failureCompletion)
        }
    }
    
    /// 上传文件
    ///
    /// - Parameters:
    ///   - URLString: 接口地址
    ///   - parameters: 参数
    ///   - fileData: 文件二进制数据
    ///   - filedName: 文件字段
    ///   - completion: 完成回调
    open class func uploadFile(URLString:String,parameters:[String:Any]?,fileData:Data,filedName:String,completion:@escaping (Any?, Error?) -> Void)  -> Void
    {
        let successCompletion = { (dataTask:URLSessionDataTask?,responseObject:Any?) -> Void in
            completion(responseObject,nil)
        }
        
        let failureCompletion = { (dataTask:URLSessionDataTask?,error:Error?) ->Void in
            let response = dataTask?.response as? HTTPURLResponse
            if response?.statusCode == 403 {
                // token过期
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAccessTokenTimeOutNotification), object: nil, userInfo: nil)
            }
            
            completion(nil,error)
        }
        
        sharedManager.post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            formData.appendPart(withFileData: fileData, name: filedName, fileName: "", mimeType: "application/octet-stream")
        }, progress: nil, success: successCompletion, failure: failureCompletion)
    }
}
