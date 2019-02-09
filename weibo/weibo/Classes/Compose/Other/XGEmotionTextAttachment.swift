//
//  XGEmotionTextAttachment.swift
//  weibo
//
//  Created by monkey on 2019/2/9.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGEmotionTextAttachment: NSTextAttachment
{
    // MARK: - 构造方法
    
    init(emotionModel:XGEmotionModel)
    {
        self.emotionModel = emotionModel
        
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var emotionModel:XGEmotionModel
}

// MARK: - 表情相关

extension XGEmotionTextAttachment
{
    /// 表情字符串
    open var emotionValue:String? {
        return emotionModel.value
    }
    
    /// 返回表情属性字符串
    open func emotionAttributedString(fontSize:CGFloat) -> NSAttributedString?
    {
        if let image = emotionModel.image {
            self.image = image
            let lineHeight = UIFont.systemFont(ofSize: fontSize).lineHeight
            bounds = CGRect(x: 0, y: -3, width: lineHeight, height: lineHeight)
            let emotionAttributedString = NSAttributedString(attachment: self)
            return emotionAttributedString
        } else {
            return nil
        }
    }
}
