//
//  XGWelcomeViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/23.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit

/// 头像宽度
private let kIconWith:CGFloat = 100

class XGWelcomeViewController: UIViewController
{
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        setUpUI()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // FIXME:测试
        iconImageView.image = UIImage(named: "icon")
//        iconImageView.xg_setImage(URLString:  XGAccountViewModel.shared.avatarLarge, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        showAnimation()
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 懒加载
    
    /// 背景图片
    private lazy var backgroundImageView:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    /// 用户头像
    private lazy var iconImageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        imageView.size = CGSize(width: kIconWith, height: kIconWith)
        imageView.layer.cornerRadius = kIconWith * 0.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// 欢迎文字
    private lazy var titleLabel:UILabel = UILabel(text: "欢迎回来", fontSize:17, textColor: UIColor.lightGray, textAlignment: .center)
}

// MARK: - 设置界面

extension XGWelcomeViewController
{
    private func setUpUI() -> Void
    {
        view = backgroundImageView
        
        backgroundImageView.addSubview(iconImageView)
        backgroundImageView.addSubview(titleLabel)
        
        // 设置自动布局
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backgroundImageView)
            make.centerY.equalTo(backgroundImageView.height * 0.7)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.centerX.equalTo(iconImageView)
        }
        
        // 更新约束否则 无法正常显示动画
        view.layoutIfNeeded()
    }
    
    /// 展示欢迎动画
    private func showAnimation() -> Void
    {
        titleLabel.alpha = 0
        
        // 开始动画
        iconImageView.snp.updateConstraints { (make) in
            make.centerY.equalTo(backgroundImageView.height * 0.3)
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: [], animations: {
            self.backgroundImageView.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.titleLabel.alpha = 1
            }, completion: { (_) in
                // 发送通知 从欢迎页面切换到主界面
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kSwitchApplicationRootViewControllerNotification), object: kFromWelcomeToMain, userInfo: nil)
            })
        }
    }
}
