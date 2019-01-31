//
//  XGComposeTypeViewToolBar.swift
//  weibo
//
//  Created by monkey on 2019/1/31.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGComposeTypeViewToolBar: UIView
{
    // MARK: - 构造方法
    /// 代理
    open weak var delegate:XGComposeTypeViewToolBarDelegate?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        XGPrint("我去了")
    }
    
    // MARK: - 事件监听
    
    // 点击取消按钮
    @objc private func closeAction() -> Void
    {
        delegate?.composeTypeViewToolBarCloseButtonDidClick?()
    }
    
    // 点击返回按钮
    @objc private func goBackAction() -> Void
    {
        delegate?.composeTypeViewToolBarGoBackButtonDidClick?()
    }
    
    // MARK: - 懒加载
    
    /// 关闭按钮
    private lazy var closeButton:UIButton = {
        let button = UIButton(title: nil, imageName: "tabbar_compose_background_icon_close",target: self, action: #selector(closeAction))
        return button
    }()
    /// 返回按钮
    private lazy var goBackButton:UIButton = {
        let button = UIButton(title: nil, imageName: "tabbar_compose_background_icon_return",target: self, action: #selector(goBackAction))
        return button
    }()
}

// MARK: - 设置界面

extension XGComposeTypeViewToolBar
{
    private func setUpUI() -> Void
    {
        goBackButton.isHidden = true
        
        // 添加子控件
        addSubview(closeButton)
        addSubview(goBackButton)
        
        // 设置自动布局
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        goBackButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
// MARK: - XGComposeTypeViewToolBarDelegate

@objc public protocol XGComposeTypeViewToolBarDelegate
{

    /// 关闭按钮点击事件
    @objc optional func composeTypeViewToolBarCloseButtonDidClick() -> Void
    /// 返回按钮点事件
    @objc optional func composeTypeViewToolBarGoBackButtonDidClick() -> Void
}
