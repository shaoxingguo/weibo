//
//  UIButton+Extension.swift
//  weibo
//
//  Created by monkey on 2019/1/14.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

extension UIButton
{
    
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - backgroundImageName: 背景图片名称
    ///   - imageName: 图片名称
    ///   - target: 监听对象
    ///   - action: 监听方法
    convenience init(backgroundImageName:String,imageName:String,target:AnyObject?,action:Selector?)
    {
        self.init()
        setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: .highlighted)
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        if let target = target,
           let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
        sizeToFit()
    }
}
