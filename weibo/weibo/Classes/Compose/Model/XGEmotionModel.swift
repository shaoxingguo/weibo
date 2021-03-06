//
//  XGEmotionModel.swift
//  weibo
//
//  Created by monkey on 2019/2/1.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

@objcMembers public class XGEmotionModel: NSObject
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
    
    /// 使用次数
    var useTimes:Int64 = 0
    
    /// 返回表情图片属性文本
    ///
    /// - Parameter fontSize: 字体大小
    /// - Returns: NSAttributedString
    open func emotionText(fontSize:CGFloat) -> NSAttributedString?
    {
        if image == nil {
            return nil
        }
        
        let attachment = XGEmotionTextAttachment(emotionModel: self)
        return attachment.emotionAttributedString(fontSize: fontSize)
    }
    
    /// 重写判断相等方法
    public override func isEqual(_ object: Any?) -> Bool {
        return value == (object as? XGEmotionModel)?.value
    }
    
    /// 将模型转为字典
    open func emotionToKeyValues() -> [String:Any]
    {
        let keys = ["icon","value","category","useTimes"]
        return dictionaryWithValues(forKeys: keys)
    }
}
