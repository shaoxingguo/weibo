//
//  XGEmotionTipView.swift
//  weibo
//
//  Created by monkey on 2019/2/12.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import pop

class XGEmotionTipView: UIImageView
{
    var emotionModel:XGEmotionModel? {
        willSet {
            // 如果已经选中该表情 直接返回
            if emotionModel == newValue {
                return
            }
            
            // 设置图片
            emotionImageView.image = newValue?.image
            // 设置动画
            let animation:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            animation.fromValue = 30
            animation.toValue = 8
            animation.springSpeed = 20
            animation.springBounciness = 20
            emotionImageView.layer.pop_add(animation, forKey: nil)
        }
    }
    
    // MARK: - 构造方法
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    
    /// 表情视图
    private lazy var emotionImageView:UIImageView = UIImageView()
}

 // MARK: - 设置界面

extension XGEmotionTipView
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 设置背景
        image = UIImage(named: "emoticon_keyboard_magnifier")
        sizeToFit()
        
        // 添加表情图片视图
        addSubview(emotionImageView)
        emotionImageView.size = CGSize(width: 36, height: 36)
        emotionImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        emotionImageView.layer.position = CGPoint(x: width / 2, y: 8)
    }
}
