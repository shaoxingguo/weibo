//
//  XGAccountModel.swift
//  weibo
//
//  Created by monkey on 2019/1/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class XGAccountModel: NSObject,NSCoding
{
    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any!
    {
        return (propertyName as NSString).mj_underlineFromCamel()
    }
    
    // MARK: - 模型属性
    /// 授权令牌
    open var accessToken:String?
    /// 有效时长 单位秒
    open var expiresIn:Int64 = 0 {
        didSet {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            expiresString = dateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval(expiresIn)))
            expiresDate = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
        }
    }
    /// 用户id
    open var uid:String?
    /// token过期时间
    open var expiresDate:Date?
    /// 用户昵称
    open var screenName:String?
    /// 用户头像(大图)
    open var avatarLarge:String?
    
    // MARK: - NSCoding
    /// 归档
    func encode(with aCoder: NSCoder) -> Void
    {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expiresDate, forKey: "expiresDate")
        aCoder.encode(screenName, forKey: "screenName")
        aCoder.encode(avatarLarge, forKey: "avatarLarge")
    }
    
    /// 解档
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init()
        accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? Date
        screenName = aDecoder.decodeObject(forKey: "screenName") as? String
        avatarLarge = aDecoder.decodeObject(forKey: "avatarLarge") as? String
    }
}
