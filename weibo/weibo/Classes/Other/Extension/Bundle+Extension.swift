//
//  Bundle+Extension.swift
//  weibo
//
//  Created by monkey on 2019/1/31.
//  Copyright © 2019 itcast. All rights reserved.
//

import Foundation

extension Bundle
{
    /// 命名空间
    open var nameSpace:String? {
        guard let progectName = (infoDictionary?[kCFBundleNameKey as String] as? String) else {
            return nil
        }
        
        return progectName + "."
    }
    
    /// 应用程序名称
    open var appName:String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
}
