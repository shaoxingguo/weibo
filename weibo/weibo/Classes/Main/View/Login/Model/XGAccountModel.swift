//
//  XGAccountModel.swift
//  weibo
//
//  Created by monkey on 2019/1/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class XGAccountModel: NSObject
{
    /*
     "access_token" = "2.00sSgbiCCd1I9C8d555b0364GXL5wD";
     "expires_in" = 157679999;
     isRealName = true;
     uid = 2491405202;
 */

    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any!
    {
        return (propertyName as NSString).mj_underlineFromCamel()
    }
    
    // MARK: - 模型属性
    /// 授权令牌
    open var accessToken:String?
    /// 有效时长
    open var expiresIn:Int64 = 0
    /// 用户id
    open var uid:String?
}
