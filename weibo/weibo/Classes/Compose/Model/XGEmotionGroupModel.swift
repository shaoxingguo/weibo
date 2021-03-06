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
        
        // 设置表情页数
        if category == "最近" {
            // 最近 只有一页
            numberOfPages = 1
        } else {
            numberOfPages = ((emotions?.count ?? 0) - 1) / kEmotionPageCount + 1
        }
        
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
        
        // 处理越界
        if (location + length) > emotions.count {
            length = emotions.count - location
        }
        
        // 返回当前页码的20个表情模型
        let emotionArr = (emotions as NSArray).subarray(with: NSRange(location: location, length: length))
        return emotionArr as? [XGEmotionModel]
    }
}
