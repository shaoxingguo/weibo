//
//  XGEmotionModel.swift
//  weibo
//
//  Created by monkey on 2019/2/1.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

@objcMembers class XGEmotionModel: NSObject
{
    /// 图片URL地址
    var icon:String?
    /// 文字
    var value:String?
    /// 分类
    var category:String? {
        didSet {
            // 在didSet方法中重新给属性赋值 不会再继续调用didSet方法 避免了死递归 
            if category == "" {
                category = "默认"
            }
        }
    }
    
    /// 表情图片
    var image:UIImage? {
        return SDWebImageManager.shared().imageCache?.imageFromCache(forKey: icon)
    }
}
