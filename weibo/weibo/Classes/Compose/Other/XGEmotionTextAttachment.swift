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
    /// 返回表情属性字符串
    open func emotionAttributedString(fontSize:CGFloat) -> NSAttributedString?
    {
        if let image = emotionModel.image {
            self.image = image
            bounds = CGRect(x: 0, y: -3, width: fontSize, height: fontSize)
            let emotionAttributedStringM = NSMutableAttributedString(attachment: self)
            emotionAttributedStringM.addAttributes(
                [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)],
                range: NSRange(location: 0, length: 1))
            return emotionAttributedStringM.copy() as? NSAttributedString
        } else {
            return nil
        }
    }
}
