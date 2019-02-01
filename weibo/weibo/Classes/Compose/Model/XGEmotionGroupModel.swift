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
    
    init(category:String?,emotions:[XGEmotionModel]?)
    {
        self.category = category
        self.emotions = emotions
        super.init()
    }
}
