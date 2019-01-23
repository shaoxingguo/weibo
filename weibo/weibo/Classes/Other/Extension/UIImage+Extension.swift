//
//  UIImage+Extension.swift
//  weibo
//
//  Created by monkey on 2019/1/16.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

extension UIImage
{
    func stretchableImage() -> UIImage
    {
        return stretchableImage(withLeftCapWidth: Int(size.width * 0.5), topCapHeight: Int(size.height * 0.5))
    }
    
    /// 创建一张不拉伸图片
    ///
    /// - Parameter imageName: 图片名称
    /// - Returns:UIImage
    class func stretchableImage(imageName:String) -> UIImage?
    {
        return UIImage(named: imageName)?.stretchableImage()
    }
}

