//
//  XGStatusModel.swift
//  weibo
//
//  Created by monkey on 2019/1/21.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class XGStatusModel: NSObject
{
    // MARK: - 模型属性

    /// 文本
    open var text:String?
    /// 微博id
    open var id:Int64 = 0
    /// 用户
    open var user:XGUserModel?
    /// 转发数
    var repostsCount:Int = 0
    /// 评论数
    var commentsCount:Int = 0
    /// 点赞数
    var attitudesCount:Int = 0
    /// 微博配图模型数组
    var picUrls: [XGPictureModel]?
    /// 被转发微博
    var retweetedStatus:XGStatusModel?
    /// 微博来源
    var source:String?
    /// 微博创建时间
    var createdAt:String?
}

// MARK: - 设置模型key

extension XGStatusModel
{
    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        return (propertyName as NSString).mj_underlineFromCamel()
    }
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["picUrls":XGPictureModel.self]
    }
}
