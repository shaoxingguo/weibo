//
//  UIImageView+Extension.swift
//  weibo
//
//  Created by monkey on 2019/1/23.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking

extension UIImageView
{
    
    /// 加载网络图片
    ///
    /// - Parameters:
    ///   - URLString: 图片URL
    ///   - placeholderImage: 占位图片
    
    
    
    /// 加载网络图片
    ///
    /// - Parameters:
    ///   - URLString: 图片URL
    ///   - placeholderImage: 占位图
    ///   - completion: 完成回调
    open func xg_setImage(URLString:String?,placeholderImage:UIImage?,completion:((UIImage?) -> Void)? = nil) -> Void
    {
        guard let URLString = URLString else {
            image = placeholderImage
            completion?(image)
            return
        }
        
        let cacheImage =  SDWebImageManager.shared().imageCache?.imageFromCache(forKey: URLString)
        if cacheImage != nil {
            // 本地有缓存 直接读取 使用sd_setImage可以取消之前的任务
            sd_setImage(with: URL(string: URLString)) { (image, _, _, _) in
                completion?(image)
            }
        } else if AFNetworkReachabilityManager.shared().isReachable {
            // 网络可用 网络加载
            sd_setImage(with: URL(string: URLString), placeholderImage: placeholderImage, options: [.retryFailed,.refreshCached]) { (image, _, _, _) in
                completion?(image)
            }
        } else {
            // 网络不可用
            image = placeholderImage
            completion?(image)
        }
    }
}
