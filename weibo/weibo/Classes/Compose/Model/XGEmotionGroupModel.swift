//
//  XGEmotionGroupModel.swift
//  weibo
//
//  Created by monkey on 2019/2/1.
//  Copyright © 2019 itcast. All rights reserved.
//

import Foundation

class XGEmotionGroupModel: NSObject
{
    /// 分类
    var category:String?
    /// 表情模型
    var emotions:[XGEmotionModel]?
    /// 表情页数 每一页20个表情
    var numberOfPages:Int = 0
    
    /// 构造方法
    ///
    /// - Parameters:
    ///   - category: 分组名称
    ///   - emotions: 表情模型数组
    init(category:String?,emotions:[XGEmotionModel]?)
    {
        self.category = category
        self.emotions = emotions
        if let emotions = emotions {
            numberOfPages = (emotions.count - 1) / kEmotionPageCount + 1
        }
        
        category == "最近" ? numberOfPages = 1 : ()
        
        super.init()
    }
    
    /// 返回对应分页的表情模型数组
    open func emotionsForPage(page:Int) -> [XGEmotionModel]?
    {
        if page < 0 || page >= numberOfPages {
            return nil
        }
        
        guard let emotions = emotions else {
            return nil
        }
        
        let location:Int = page * kEmotionPageCount
        var length:Int = kEmotionPageCount
        if (location + length) > emotions.count {
            length = emotions.count - location
        }
        let emotionArr = (emotions as NSArray).subarray(with: NSRange(location: location, length: length))
        return emotionArr as? [XGEmotionModel]
    }
}
