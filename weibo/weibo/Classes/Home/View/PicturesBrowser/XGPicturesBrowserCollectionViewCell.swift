//
//  XGPicturesBrowserCollectionViewCell.swift
//  weibo
//
//  Created by monkey on 2019/2/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class XGPicturesBrowserCollectionViewCell: UICollectionViewCell
{
    /// 代理
    open weak var delegate:XGPicturesBrowserCollectionViewCellDelegate?
    
    // MARK: - 数据模型
    
    var pictureModel:XGPictureModel? {
        didSet {
            resetCell()
            setImage()
        }
    }
    
    // MARK: - 构造方法
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpUI()
        setUpScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 事件监听
    
    @objc private func tapImageViewAction() -> Void
    {
        delegate?.picturesBrowserCollectionViewCellDidTapImageView?()
    }
    
    // MARK: - 懒加载
    
    /// 占位图片
    private lazy var placeImageView:XGProgressImageView = XGProgressImageView()
    /// 大图
    private(set) open lazy var bigImageView:FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    /// scrollView
    private lazy var scrollView:UIScrollView = UIScrollView()
}

// MARK: - UIScrollViewDelegate

extension XGPicturesBrowserCollectionViewCell:UIScrollViewDelegate
{
    // 缩放哪个视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return bigImageView
    }
    
    // 正在缩放
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        delegate?.picturesBrowserCollectionViewCellDidZoom?(scale: bigImageView.transform.a)
    }
    
     // 停止缩放
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        // 更新内容边距 要获取缩放视图的大小要使用frame,缩放时frame改变 bounds不改变 缩放时会自动设置contentSize
        var verMargin = (scrollView.height - view!.frame.height) / 2
        verMargin = verMargin < 0 ? 0 : verMargin
        var horMargin = (scrollView.width - view!.frame.width) / 2
        horMargin = horMargin < 0 ? 0 : horMargin

        scrollView.contentInset = UIEdgeInsets(top: verMargin, left: horMargin, bottom: verMargin, right: horMargin)
    }
}

// MARK: - 设置界面

extension XGPicturesBrowserCollectionViewCell
{
    /// 重置cell
    private func resetCell() -> Void
    {
        bigImageView.transform = CGAffineTransform.identity
        
        scrollView.contentOffset = CGPoint.zero
        scrollView.contentSize = CGSize.zero
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    /// 设置图片
    private func setImage() -> Void
    {
        guard let pictureModel = pictureModel,
            let placeImage = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: pictureModel.thumbnailPic) else {
                return
        }
        
        // 设置占位图片
        placeImageView.isHidden = false
        placeImageView.image = placeImage
        placeImageView.sizeToFit()
        placeImageView.center = CGPoint(x: width / 2, y: height / 2)
        
        // 设置高清大图
        if let bigImageData = SDWebImageManager.shared().imageCache?.diskImageData(forKey: pictureModel.bmiddlePic){
            // 有大图 设置大图
            setBigImage(imageData: bigImageData)
        } else {
            // 没有大图 进行下载
            SDWebImageManager.shared().loadImage(with: URL(string: pictureModel.bmiddlePic!), options: [.retryFailed,.refreshCached], progress: { [weak self] (current, total, _) in
                // 主线程更新进度
                DispatchQueue.main.async {
                    self?.placeImageView.progress = CGFloat(current) / CGFloat(total)
                }
            }) { [weak self] (_, imageData, error, _, _, _) in
                if error != nil || imageData == nil {
                    XGPrint("大图下载失败")
                    return
                }
                
                // 设置大图
                self?.setBigImage(imageData: imageData!)
            }
        }
    }
    
    /// 设置大图
    private func setBigImage(imageData:Data) -> Void
    {
        placeImageView.isHidden = true
        
        if pictureModel?.isGif == true {
            // gif图片
            bigImageView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        } else {
            // 普通图片
            bigImageView.image = UIImage(data: imageData)
        }
        
        // 等比例缩放图片
        let width = scrollView.width
        let height = width / bigImageView.image!.size.width * bigImageView.image!.size.height
        bigImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 设置内容边距
        var margin = (scrollView.height - height) / 2
        margin = margin < 0 ? 0 : margin
        scrollView.contentInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
        // 设置滚动范围
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    /// 设置界面
    private func setUpUI() -> Void
    {
        backgroundColor = UIColor.black
        
        // 添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(placeImageView)
        
        // 设置布局
        var rect = contentView.bounds
        rect.size.width -= kPicturesCellMargin
        scrollView.frame = rect
    }
    
    /// 设置scrollView
    private func setUpScrollView() -> Void
    {
        // 设置scrollView
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        // 设置缩放
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        // 设置代理
        scrollView.delegate = self
        
        // 添加imageView
        bigImageView.isUserInteractionEnabled = true
        bigImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageViewAction)))
        scrollView.addSubview(bigImageView)
    }
}

// MARK: - XGPicturesBrowserCollectionViewCellDelegate

@objc public protocol XGPicturesBrowserCollectionViewCellDelegate
{
    @objc optional func picturesBrowserCollectionViewCellDidTapImageView() -> Void
    @objc optional func picturesBrowserCollectionViewCellDidZoom(scale:CGFloat) -> Void
}
