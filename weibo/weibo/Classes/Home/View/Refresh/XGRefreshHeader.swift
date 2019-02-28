//
//  XGRefreshHeader.swift
//  02-DIYRefresh
//
//  Created by monkey on 2019/1/29.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import MJRefresh

/// 刷新控件高度
private let kRefreshViewHeight:CGFloat = 150
/// 地球显示高度
private let kEarthDisplayHeight:CGFloat = 50
/// scrollView初始化顶部间距
private var kInitScrollViewTopInset:CGFloat = 0

class XGRefreshHeader: MJRefreshHeader
{
    // MARK: - 重写方法
    
    override func prepare()
    {
        super.prepare()
        
        // 在这里做一些初始化配置（比如添加子控件）
        setUpUI()
        setUpContentView()
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        
        // 监听scrollView的contentOffset改变
        guard  let offset = change["new"] as? CGPoint else {
            return
        }
        
        kInitScrollViewTopInset == 0 ? kInitScrollViewTopInset = scrollView.contentInset.top : ()
        // 当不处于下拉刷新时 隐藏视图
        contentView.isHidden = offset.y >= -(kInitScrollViewTopInset)
        if offset.y > -(scrollView.contentInset.top) {
            // 上拉刷新 正常滚动
            return
        }
        
        // 缩放袋鼠
        let kMaxOffset = mj_h + kInitScrollViewTopInset
        let kMinOffset = kEarthDisplayHeight + kInitScrollViewTopInset
        if offset.y < -kMaxOffset || offset.y > -kMinOffset {
            // 最大下拉偏移为 -(mj_h + scrollView.contentInset.top) 最小为-(kEarthDisplayHeight + scrollView.contentInset.top) 超过最大或低于最小袋鼠不进行缩放
            return
        }
        
        // 50 + 64 = 114  scale = 0.2
        // 150 + 64 = 214 scale = 1.0
        let scale = (abs(offset.y) - kMinOffset) / (kMaxOffset - kMinOffset) * 0.8 + 0.2
        kangarooImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    // MARK: - 懒加载
    
    /// 容器视图
    private lazy var contentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /// 建筑物图像
    private lazy var buildingImageView:UIImageView = {
        let image1 = UIImage(named: "icon_building_loading_1") ?? UIImage()
        let image2 = UIImage(named: "icon_building_loading_2") ?? UIImage ()
        let animationImage = UIImage.animatedImage(with: [image1,image2], duration: 1)
        let imageView = UIImageView(image: animationImage)
        return imageView
    }()
    
    /// 地球图像
    private lazy var earthImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_earth"))
        return imageView
    }()
    
    /// 袋鼠图像
    private lazy var kangarooImageView:UIImageView = {
        let image1 = UIImage(named: "icon_small_kangaroo_loading_1") ?? UIImage()
        let image2 = UIImage(named: "icon_small_kangaroo_loading_2") ?? UIImage ()
        let animationImage = UIImage.animatedImage(with: [image1,image2], duration: 0.3)
        let imageView = UIImageView(image: animationImage)
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        return imageView
    }()
}

// MARK: - 设置界面

extension XGRefreshHeader
{
    private func setUpUI() -> Void
    {
        // 设置下拉刷新控件
        mj_h = kRefreshViewHeight
        backgroundColor = UIColor.white
        clipsToBounds = true
        let screenWidth = UIScreen.main.bounds.width
        
        // 添加子控件
        addSubview(contentView)
        // 设置位置
        contentView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: mj_h)
    }
    
    private func setUpContentView() -> Void
    {
        // 添加子控件
        contentView.addSubview(buildingImageView)
        contentView.addSubview(earthImageView)
        contentView.addSubview(kangarooImageView)
        
        // 设置子控件位置
        buildingImageView.frame = CGRect(origin: CGPoint(x: (contentView.bounds.width - buildingImageView.bounds.width) / 2, y: 0), size: buildingImageView.bounds.size)
        earthImageView.frame = CGRect(origin: CGPoint(x: (contentView.bounds.width - earthImageView.bounds.width) / 2, y: mj_h - kEarthDisplayHeight), size: earthImageView.bounds.size)
        kangarooImageView.frame = CGRect(origin: CGPoint(x: (contentView.bounds.width - kangarooImageView.bounds.width) / 2, y: earthImageView.frame.origin.y - kangarooImageView.bounds.height), size: kangarooImageView.bounds.size)
        
        // 添加地球旋转核心动画
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 6
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        earthImageView.layer.add(rotationAnimation, forKey: nil)
        
        kangarooImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
    }
}
