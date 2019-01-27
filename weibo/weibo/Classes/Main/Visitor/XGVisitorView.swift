//
//  XGVisitorView.swift
//  weibo
//
//  Created by monkey on 2019/1/16.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit

class XGVisitorView: UIView
{
    var visitorInfo:[String:String]? {
        didSet {
            guard let imageName = visitorInfo?["imageName"],
            let title = visitorInfo?["title"] else {
                return
            }
            
            if imageName == "" {
                // 首页
                titleLabel.text = title
                startAnimation()
            } else {
                // 非首页
                houseImageView.isHidden = true
                maskImageView.isHidden = true
                circleImageView.image = UIImage(named: imageName)
                titleLabel.text = title
            }
        }
    }
    // MARK: - 构造方法
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        // 设置界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    
    /// 小房子
    private lazy var houseImageView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    /// 圆圈
    private lazy var circleImageView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    /// 标题
    private lazy var titleLabel:UILabel = UILabel(text: "关注一些人,回来看看有什么惊喜!关注一些人,回来看看有什么惊喜!", fontSize: 17, textColor: UIColor.lightGray, textAlignment: .center)
    /// 注册按钮
    open lazy var registerButton:UIButton = UIButton(title: "注册", backgroundImageName: "common_button_white_disable", fontSize: 15, normalColor: UIColor.orange, highlightedColor: UIColor.orange, target: nil, action: nil)
    /// 登录按钮
    open lazy var loginButton:UIButton = UIButton(title: "登录", backgroundImageName: "common_button_white_disable", fontSize: 15, normalColor: UIColor.darkGray, highlightedColor: UIColor.darkGray, target: nil, action: nil)
    /// 遮罩层
    private lazy var maskImageView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
}

// MARK: - 设置界面

extension XGVisitorView
{
    /// 开始动画
    private func startAnimation() -> Void
    {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2.0 * Double.pi
        animation.duration = 8
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        circleImageView.layer.add(animation, forKey: nil)
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        let margin:CGFloat = 30
        
        // 添加子控件
        addSubview(houseImageView)
        addSubview(circleImageView)
        addSubview(maskImageView)
        addSubview(titleLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 设置小房子自动布局
        houseImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }
        
        // 设置圆圈自动布局
        circleImageView.snp.makeConstraints { (make) in
            make.center.equalTo(houseImageView)
        }
        
        // 遮罩层自动布局
        maskImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(registerButton)
        }
        
        // 设置标题文字自动布局
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(houseImageView)
            make.top.equalTo(circleImageView.snp.bottom).offset(margin)
            make.left.equalTo(self).offset((margin))
            make.right.equalTo(self).offset((-margin))
        }
        
        // 注册按钮自动布局
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
            make.size.equalTo(CGSize(width: 100, height: 36))
        }
        
        // 登录按钮自动布局
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.top.equalTo(registerButton)
            make.size.equalTo(registerButton)
        }
    }
}
