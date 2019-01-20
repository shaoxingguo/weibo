//
//  XGAdvertisementModel.swift
//  weibo
//
//  Created by monkey on 2019/1/19.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class XGAdvertisementModel: NSObject,NSCoding
{
    // MARK: - 模型属性
    open var pictureImageURL:String?
    open var webURL:String?
    
    // MARK: - 其他方法
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]!
    {
        return ["pictureImageURL": "w_picurl",
         "webURL": "ori_curl"]
    }
    
    // MARK: - NSCoding
    /// 归档
    func encode(with aCoder: NSCoder) -> Void
    {
        aCoder.encode(pictureImageURL, forKey: "pictureImageURL")
        aCoder.encode(webURL, forKey: "webURL")
    }
    
    /// 解档
    required convenience init?(coder aDecoder: NSCoder)
    {
        self.init()
        pictureImageURL = aDecoder.decodeObject(forKey: "pictureImageURL") as? String
        webURL = aDecoder.decodeObject(forKey: "webURL") as? String
    }
}

