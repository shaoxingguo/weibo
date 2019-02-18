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
            // 隐藏所有图片视图
            for view in subviews {
                view.isHidden = true
            }
            
            if statusViewModel?.picUrls == nil || statusViewModel?.picUrls?.count == 0 {
                // 没有配图
                return
            }
            
            if statusViewModel?.picUrls?.count == 1 {
                // 单图
                
                // 重设第一个imageView尺寸
                let width = statusViewModel!.picturesViewSize.width
                let height = (statusViewModel!.picturesViewSize.height - kStatusCellPictureOuterMargin)
                let imageView = subviews[0] as! UIImageView
                imageView.isHidden = false
                imageView.frame = CGRect(x: 0, y: kStatusCellPictureOuterMargin, width: width, height: height)
                
                // 设置图片
                setImage(imageView: imageView, image: statusViewModel?.pictures?[0], URLString: statusViewModel?.picUrls?.first?.thumbnailPic, imageSize: imageView.size)
                return
            } else {
                // 多图
                
                // 恢复第一个imageView尺寸
                let imageView = subviews[0] as! UIImageView
                imageView.frame = CGRect(x: 0, y: kStatusCellPictureOuterMargin, width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)
                
                // 设置图片
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
    }
    
    /// 为imageView设置图片 如果有图片直接设置 如果没有进行网络加载
    ///
    /// - Parameters:
    ///   - imageView: UIImageView
    ///   - image: image
    ///   - URLString: URLString
    ///   - imageSize: 图片尺寸
    private func setImage(imageView:UIImageView,image:UIImage? = nil,URLString:String? = nil,imageSize:CGSize = CGSize(width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)) -> Void
    {
        // 是否显示gif提示
        imageView.subviews[0].isHidden = !(URLString?.lowercased() ?? "").hasSuffix("gif")
        
        // 设置图片
        if image != nil {
            imageView.image = image
        } else if URLString != nil {
            imageView.xg_setImage(URLString: URLString, placeholderImage: kPlaceholderImage) { [weak self](image) in
                if image != nil {
                    // 缩放图片
                    let newImage = image?.scaleToSize(imageSize: imageSize, backgroundColor: self?.backgroundColor ?? UIColor.white)
                    imageView.image = newImage
                    
                    // 重新保存图片
                    SDWebImageManager.shared().imageCache?.store(newImage, forKey: URLString)
                }
            }
        }
    }
    
    // MARK: - 监听方法
    
    @objc private func tapImageViewAction(tap:UITapGestureRecognizer) -> Void
    {
        guard let picUrls = statusViewModel?.picUrls,
              let imageView = tap.view as? UIImageView else {
            return
        }
      
        var index = imageView.tag
        // 点击的图片索引
        index = picUrls.count == 4 && index > 1 ? index - 1 : index
        // 发布通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPicturesBrowserNotification), object: nil, userInfo: [kPicturesBrowserSelectedIndexKey:index,                        kPicturesBrowserPicturesKey:picUrls])
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
        for i in 0..<kStatusPicturesViewColumns * kStatusPicturesViewColumns {
            // 添加图片视图
            let row = i / kStatusPicturesViewColumns
            let column = i % kStatusPicturesViewColumns
            let x = CGFloat(column) * (kStatusCellPictureInnerMargin + kStatusPicturesViewItemWidth)
            let y = kStatusCellPictureOuterMargin + CGFloat(row) * (kStatusCellPictureInnerMargin + kStatusPicturesViewItemWidth)
            
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.orange
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageViewAction(tap:))))
        
            // 添加gif标志
            let gifTipImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
            gifTipImageView.origin = CGPoint(x: kStatusPicturesViewItemWidth - gifTipImageView.width, y: kStatusPicturesViewItemWidth - gifTipImageView.height)
            imageView.addSubview(gifTipImageView)
            
            addSubview(imageView)
            imageView.frame = CGRect(x: x, y: y, width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)
        }
    } 
}
