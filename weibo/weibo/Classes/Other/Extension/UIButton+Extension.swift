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
    
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - imageName: 图片名
    ///   - fontSize: 标题字体大小
    ///   - normalColor: 默认颜色 默认darkGray
    ///   - highlightedColor: 高亮颜色 默认orange
    ///   - target: 监听者
    ///   - action: 监听方法
    convenience init(title:String,imageName:String? = nil,fontSize:CGFloat = 15,normalColor:UIColor = UIColor.darkGray,highlightedColor:UIColor = UIColor.orange,target:AnyObject?,action:Selector?)
    {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightedColor, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
            setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        if let target = target,
            let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
        sizeToFit()
    }
    
    
     /// 便利构造方法
     ///
     /// - Parameters:
     ///   - title: 标题
     ///   - backgroundImageName: 背景图片名
     ///   - fontSize:  标题字体大小
     ///   - normalColor: 默认颜色
     ///   - highlightedColor: 高亮颜色
     ///   - target: 监听者
     ///   - action: 监听方法
     convenience init(title:String,backgroundImageName:String,fontSize:CGFloat = 15,normalColor:UIColor = UIColor.darkGray,highlightedColor:UIColor = UIColor.orange,target:AnyObject?,action:Selector?)
     {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightedColor, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setBackgroundImage(UIImage.stretchableImage(imageName: backgroundImageName), for: .normal)
        setBackgroundImage(UIImage.stretchableImage(imageName: backgroundImageName), for: .highlighted)

        
        if let target = target,
            let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
        sizeToFit()
    }
}
