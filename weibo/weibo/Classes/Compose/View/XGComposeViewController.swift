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
        registerNotification()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        XGPrint("我去了")
    }
    
    // MARK: - 监听方法
    
    /// 关闭按钮监听事件
    @objc private func closeAction() -> Void
    {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    /// 键盘frame改变事件监听
    @objc private func keyboardWillChangeFrameAction(notification:Notification) -> Void
    {
        /*
         // 开始
         ["UIKeyboardFrameBeginUserInfoKey": NSRect: {{0, 667}, {375, 260}}, 797}, AnyHashable("UIKeyboardAnimationCurveUserInfoKey"): 7,  260}}, "UIKeyboardFrameEndUserInfoKey": NSRect: {{0, 407}, {375, 260}}, "UIKeyboardAnimationDurationUserInfoKey": 0.4]
         
         // 结束
         ["UIKeyboardFrameBeginUserInfoKey": NSRect: {{0, 407}, {375, 260}}, "UIKeyboardAnimationCurveUserInfoKey": 7,  "UIKeyboardFrameEndUserInfoKey": NSRect: {{0, 667}, {375, 0}}, "UIKeyboardAnimationDurationUserInfoKey": 0.25] */
        
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat else {
                return
        }
        
        emotionKeyboardView.height = endFrame.size.height
        
        let offset = (view.height - endFrame.origin.y) * -1
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(offset)
        }
        
        UIView.animate(withDuration: TimeInterval(duration)) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func emotionKeyboardAction() -> Void
    {
        if XGEmotionsListViewModel.shared.emotionsGroupList.count > 0 {
            textView.inputView = textView.inputView == nil ? emotionKeyboardView : nil
            textView.reloadInputViews()
        }
    }
    
    // MARK: - 懒加载
    
    /// textView
    private lazy var textView:XGTextView = { [weak self] in
        let textView = XGTextView()
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        return textView
    }()
    
    /// 工具栏
    private lazy var toolBar:UIToolbar = UIToolbar()
    /// 表情键盘
    private lazy var emotionKeyboardView:XGEmotionKeyboardView = {
        let view = XGEmotionKeyboardView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return view
    }()
}

// MARK: - UITextViewDelegate

extension XGComposeViewController:UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        button?.isEnabled = textView.hasText
    }
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
    
    /// 设置工具栏
    private func setUpToolBar() -> Void
    {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emotionKeyboardAction"],
                            ["imageName": "compose_add_background"]]
        
        var items:[UIBarButtonItem] = [UIBarButtonItem]()
        for dictionary in itemSettings {
            if let imageName = dictionary["imageName"] {
                let button = UIButton(title: nil, imageName: imageName, target: nil, action: nil)
                if let actionName = dictionary["actionName"] {
                    button.addTarget(self, action: Selector(actionName), for: .touchUpInside)
                }
                
                items.append(UIBarButtonItem(customView: button))
                items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
            }
        }
        
        items.removeLast()
        toolBar.items = items
    }
    
    /// 注册通知
    private func registerNotification() -> Void
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrameAction(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
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
        let button = UIButton(title: "发布", backgroundImageName: "common_button_orange", fontSize: 15, normalColor: UIColor.white, highlightedColor: UIColor.white, target: nil, action: nil)
        button.setBackgroundImage(UIImage.stretchableImage(imageName: "common_button_white_disable"), for: .disabled)
        button.setTitleColor(UIColor.darkGray, for: .disabled)
        button.width = 60
        let item = UIBarButtonItem(customView: button)
        item.isEnabled = false
        return item
    }
}
