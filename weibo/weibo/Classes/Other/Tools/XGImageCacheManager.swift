//
//  XGImageCacheManager.swift
//  weibo
//
//  Created by monkey on 2019/3/11.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class XGImageCacheManager: NSObject
{
    /// 单例
    public static var shared:XGImageCacheManager = XGImageCacheManager()
    
    /// 图片缓存数组
    private var imageCacheDictioary = [String:UIImage]()
    
    // MARK: - 构造方法
    
    private override init()
    {
        super.init()
        // 注册内存警告通知
        NotificationCenter.default.addObserver(self, selector: #selector(removeCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 图片缓存

extension XGImageCacheManager
{
    /// 根据图片url返回渲染后的图片
    ///
    /// - Parameters:
    ///   - key: 图片url
    ///   - size: 图片尺寸
    ///   - backgroundColor: 背景色 默认白色
    ///   - isUserIcon: 是否是用户头像(进行圆角处理) 默认false
    ///   - completion: 完成回调
    open func imageForKey(key:String?,size:CGSize,backgroundColor:UIColor = UIColor.white,isUserIcon:Bool = false,completion:@escaping (UIImage?) -> Void) -> Void
    {
        guard let key = key else {
            completion(nil)
            return
        }
        
        // 如果已经缓存了 直接返回
        if imageCacheDictioary[key] != nil {
            completion(imageCacheDictioary[key])
            return
        }
        
        // 图片不存在 进行下载
        SDWebImageManager.shared().loadImage(with: URL(string: key), options: [.retryFailed,.refreshCached], progress: nil) { (image, _, error, _, _, _) in
            if image == nil || error != nil {
                completion(nil)
                return
            }
            
            // 进行处理
            let newImage = isUserIcon ? image?.circleIconImage(imageSize: size, backgroundColor: backgroundColor) : image?.scaleToSize(imageSize: size, backgroundColor: backgroundColor)
            // 保存到内存中
            self.imageCacheDictioary[key] = newImage!
            
            // 完成回调
            completion(newImage)
        }
    }
    
    /// 清除缓存
    @objc private func removeCache() -> Void
    {
        imageCacheDictioary.removeAll();
    }
}
