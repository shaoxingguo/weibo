//
//  XGEmotionModel.swift
//  weibo
//
//  Created by monkey on 2019/2/1.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

@objcMembers class XGEmotionModel: NSObject
{
    /// 图片
    var icon:String?
    /// 文字
    var value:String?
    /// 分类
    var category:String? {
        didSet {
            // 在didSet方法中重新给属性赋值 不会再继续调用didSet方法 避免了死递归 
            if category?.compare("") == ComparisonResult.orderedSame {
                category = "默认"
            }
        }
    }
}
