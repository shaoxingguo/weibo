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
        guard let appName = (infoDictionary?[kCFBundleNameKey as String] as? String) else {
            return nil
        }
        
        return appName + "."
    }
}
