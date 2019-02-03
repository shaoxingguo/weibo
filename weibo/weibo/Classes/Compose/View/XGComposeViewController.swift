//
//  XGComposeViewController.swift
//  weibo
//
//  Created by monkey on 2019/1/31.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGComposeViewController: UIViewController
{
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        super.loadView()
        
        setUpUI()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUpNavigationItem()
        setUpToolBar()
    }
    
    // MARK: - 监听方法
    
    @objc private func closeAction() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    
    /// textView
    private lazy var textView:XGTextView = {
        let textView = XGTextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    /// 工具栏
    private lazy var toolBar:UIToolbar = UIToolbar()
}

// MARK: - 设置界面

extension XGComposeViewController
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        view.backgroundColor = UIColor.white
        
        // 添加子控件
        view.addSubview(textView)
        view.addSubview(toolBar)
        
        // 设置自动布局
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(kToolBarHeight)
        }
    }
    
    /// 设置导航栏
    private func setUpNavigationItem() -> Void
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(closeAction))
        navigationItem.titleView = titleLabel()
        navigationItem.rightBarButtonItem  = publishButtonItem()
    }
    
    /// 导航栏标题按钮
    private func titleLabel() -> UILabel
    {
        let title1 = NSAttributedString(string: "发微博\n", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:UIColor.black])
        let attributedStringM = NSMutableAttributedString(attributedString: title1)
        let title2 = NSAttributedString(string: XGAccountViewModel.shared.screenName ?? "", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        attributedStringM.append(title2)
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = attributedStringM.copy() as? NSAttributedString
        label.sizeToFit()
        return label
    }
    
    /// 发布按钮
    private func publishButtonItem() -> UIBarButtonItem
    {
        let button = UIButton(title: "发布", backgroundImageName: "common_button_orange", fontSize: 15, normalColor: UIColor.lightGray, highlightedColor: UIColor.lightGray, target: nil, action: nil)
        button.setBackgroundImage(UIImage.stretchableImage(imageName: "common_button_white_disable"), for: .disabled)
        button.width = 60
        let item = UIBarButtonItem(customView: button)
        item.isEnabled = false
        return item
    }
    
    private func setUpToolBar() -> Void
    {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var items:[UIBarButtonItem] = [UIBarButtonItem]()
        for dictionary in itemSettings {
            let imageName = dictionary["imageName"]
            if imageName != nil {
                let item = UIBarButtonItem(customView: UIButton(title: nil, imageName: imageName, target: nil, action: nil))
                items.append(item)
                items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
            }
        }
        
        items.removeLast()
        toolBar.items = items
    }
}
