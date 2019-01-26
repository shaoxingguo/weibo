//
//  XGPicturesView.swift
//  weibo
//
//  Created by monkey on 2019/1/26.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage

class XGStatusPicturesView: UIView
{
    // MARK: - 数据模型
    
    open var statusViewModel:XGStatusViewModel? {
        didSet {
            if statusViewModel?.picUrls == nil || statusViewModel?.picUrls?.count == 0 {
                // 没有配图
                return
            }
            
            // 隐藏所有图片视图
            for view in subviews {
                view.isHidden = true
            }
            
            // 设置图片数据并显示
            var index:Int = 0
            for i in 0..<(statusViewModel?.picUrls?.count ?? 0) {
                let imageView = subviews[index] as! UIImageView
                imageView.isHidden = false
                setImage(imageView: imageView, image: statusViewModel?.pictures?[i], URLString: statusViewModel?.picUrls?[i].thumbnailPic)
                index += 1
                statusViewModel?.picUrls?.count == 4 && index == 2 ? index += 1 : ()
            }
        }
    }
    
    /// 为imageView设置图片 如果有图片直接设置 如果没有进行网络加载
    ///
    /// - Parameters:
    ///   - imageView: UIImageView
    ///   - image: image
    ///   - URLString: URLString
    private func setImage(imageView:UIImageView,image:UIImage? = nil,URLString:String? = nil) -> Void
    {
        if image != nil {
            imageView.image = image
        } else if URLString != nil {
            imageView.xg_setImage(URLString: URLString, placeholderImage: kPlaceholderImage) { [weak self](image) in
                if image != nil {
                    // 缩放图片
                    let newImage = image?.scaleToSize(imageSize: CGSize(width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth), backgroundColor: self?.backgroundColor ?? UIColor.white)
                    imageView.image = newImage
                    
                    // 重新保存图片
                    SDWebImageManager.shared().imageCache?.store(newImage, forKey: URLString)
                }
            }
        }
    }
    
    // MARK: - 构造方法
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置界面

extension XGStatusPicturesView
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        clipsToBounds = true
        
        for i in 0..<kStatusPicturesViewColumns * kStatusPicturesViewColumns {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.orange
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            addSubview(imageView)
            
            let row = i / kStatusPicturesViewColumns
            let column = i % kStatusPicturesViewColumns
            let x = CGFloat(column) * (kStatusCellPictureInnerMargin + kStatusPicturesViewItemWidth)
            let y = kStatusCellPictureOuterMargin + CGFloat(row) * (kStatusCellPictureInnerMargin + kStatusPicturesViewItemWidth)
            imageView.frame = CGRect(x: x, y: y, width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)
        }
    }
}
