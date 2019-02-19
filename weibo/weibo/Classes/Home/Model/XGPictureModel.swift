//
//  XGPictureModel.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

@objcMembers class XGPictureModel: NSObject
{
    // MARK: - 模型属性
    
    /// 缩略图
    open var thumbnailPic:String? {
        didSet {
            bmiddlePic = (thumbnailPic as NSString?)?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
        }
    }
    
    /// 中等图
    open var bmiddlePic:String?
    
    
    /// 是否是gif图片
    open var isGif:Bool {
        return thumbnailPic?.lowercased().hasSuffix("gif") == true
    }
}

// MARK: - 设置模型key

extension XGPictureModel
{
    override static func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        return (propertyName as NSString).mj_underlineFromCamel()
    }
}
