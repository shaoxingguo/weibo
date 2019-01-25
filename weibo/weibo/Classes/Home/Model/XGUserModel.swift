//
//  XGUser.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

@objcMembers class XGUserModel: NSObject
{
    // 基本数据类型 & private 不能使用 KVC 设置
    var id: Int64 = 0
    /// 用户昵称
    var screenName:String?
    /// 用户头像地址（中图），50×50像素
    var profileImageUrl: String?
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verifiedType:Int = 0
    /// 会员等级 0-6
    var mbrank:Int = 0
}

// MARK: - 设置模型key

extension XGUserModel
{
    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        return (propertyName as NSString).mj_underlineFromCamel()
    }
}
