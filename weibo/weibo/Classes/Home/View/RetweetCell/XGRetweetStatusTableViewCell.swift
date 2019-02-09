//
//  XGRetweetStatusTableViewCell.swift
//  weibo
//
//  Created by monkey on 2019/1/27.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import FFLabel

class XGRetweetStatusTableViewCell: XGStatusTableViewCell
{

    // MARK: - 数据模型
    override var statusViewModel: XGStatusViewModel? {
        didSet {
            retweetTextLabel.attributedText = statusViewModel?.retweetedStatusText
        }
    }
    
    // MARK: - 设置界面
    
    override func setUpUI()
    {
        super.setUpUI()
        
        picturesView.backgroundColor = backgroundButton.backgroundColor
        
        // 添加子控件
        contentView.insertSubview(backgroundButton, at: 0)
        contentView.addSubview(retweetTextLabel)
        
        // 设置自动布局
        backgroundButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(kStatusCellPictureOuterMargin)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(picturesView)
        }
        
        retweetTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundButton).offset(kStatusCellPictureInnerMargin)
            make.left.right.equalTo(contentLabel)
        }
        
        picturesView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetTextLabel.snp.bottom)
            make.left.right.equalTo(retweetTextLabel)
            make.height.equalTo(200).priority(.high)
        }
    }
    
    // MARK: - 懒加载
    
    /// 背景按钮
    private lazy var backgroundButton:UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return button
    }()
    
    /// 转发微博文字
    private lazy var retweetTextLabel:UILabel = { [weak self] in
       let label = FFLabel(text: "测试文本", fontSize: kContentTextFontSize, textColor: kContentTextColor, textAlignment: .left)
        label.labelDelegate = self
        return label
    }()
}
