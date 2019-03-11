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
                let URLString = statusViewModel!.picUrls![0].thumbnailPic!
                setImage(imageView: imageView, URLString: URLString, imageSize: imageView.size)
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
                    let URLString = statusViewModel!.picUrls![i].thumbnailPic!
                    setImage(imageView: imageView, URLString: URLString)
                    index += 1
                    statusViewModel?.picUrls?.count == 4 && index == 2 ? index += 1 : ()
                }
            }
        }
    }
    
    /// / 为imageView设置图片 如果有图片直接设置 如果没有进行网络加载
    ///
    /// - Parameters:
    ///   - imageView: 要设置图像imageView
    ///   - URLString: 图片地址
    ///   - imageSize: 图片尺寸
    private func setImage(imageView:UIImageView,URLString:String,imageSize:CGSize = CGSize(width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)) -> Void
    {
        // 是否显示gif提示
        imageView.subviews[0].isHidden = !(URLString.lowercased().hasSuffix("gif"))
        
        // 设置图片 下载完毕进行缩放
        XGImageCacheManager.shared.imageForKey(key: URLString, size: imageSize, backgroundColor: backgroundColor ?? UIColor.white) { (image) in
            imageView.image = image
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
        // 点击的图片索引 4张图特殊处理 因为中间隐藏了一个imageView
        index = picUrls.count == 4 && index > 1 ? index - 1 : index
        // 发布通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPicturesBrowserNotification), object: self, userInfo: [kPicturesBrowserSelectedIndexKey:index,                        kPicturesBrowserPicturesKey:picUrls])
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

// MARK: - XGPictureBrowserTransitioningAnimatorPresentedDelegate

extension XGStatusPicturesView: XGPictureBrowserTransitioningAnimatorPresentedDelegate
{
    func showPresentedAnimationImageView(index: Int) -> UIImageView
    {
        let key = statusViewModel?.picUrls?[index].thumbnailPic
        let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: key)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    func presentedFromRect(index: Int) -> CGRect
    {
        // 点击的图片索引 4张图特殊处理 因为中间隐藏了一个imageView
        let selectedIndex = statusViewModel?.picUrls?.count == 4 && index > 1 ? index + 1 : index
        let selectedImageView = (subviews[selectedIndex] as! UIImageView)
        let rect = convert(selectedImageView.frame, to: UIApplication.shared.keyWindow)
        return rect
    }
    
    func presentedToRect(index: Int) -> CGRect
    {
        guard let key = statusViewModel?.picUrls?[index].thumbnailPic,
              let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: key) else {
                return CGRect.zero
        }
        
        let width = kScreenWidth
        let height = width / image.size.width * image.size.height
        let y = height > kScreenHeight ? 0 : (kScreenHeight - height) * 0.5
        return CGRect(x: 0, y: y, width: width, height: height)
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
            imageView.frame = CGRect(x: x, y: y, width: kStatusPicturesViewItemWidth, height: kStatusPicturesViewItemWidth)
        
            // 添加gif标志
            let gifTipImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
            imageView.addSubview(gifTipImageView)
            addSubview(imageView)
            gifTipImageView.snp.makeConstraints { (make) in
                make.right.bottom.equalTo(imageView)
            }
        }
    } 
}
