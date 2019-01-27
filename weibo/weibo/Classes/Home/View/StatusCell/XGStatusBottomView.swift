//
//  XGStatusBottomView.swift
//  weibo
//
//  Created by monkey on 2019/1/26.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGStatusBottomView: UIView
{

    // MARK: - 数据模型
    
    open var statusViewModel:XGStatusViewModel? {
        didSet {
            retweetButton.setTitle(statusViewModel?.repostsCountString, for: .normal)
            commentButton.setTitle(statusViewModel?.commentsCountString, for: .normal)
            likeButton.setTitle(statusViewModel?.attitudesCountString, for: .normal)
        }
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

    // MARK: - 懒加载
    
    /// 转发按钮
    private lazy var retweetButton:UIButton = {
       let button = UIButton(title: "转发", imageName: "timeline_icon_retweet", fontSize: 15, normalColor: UIColor.lightGray, highlightedColor: UIColor.lightGray, target: nil, action: nil)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return button
    }()
    /// 评论按钮
    private lazy var commentButton:UIButton = {
        let button = UIButton(title: "评论", imageName: "timeline_icon_comment", fontSize: 15, normalColor: UIColor.lightGray, highlightedColor: UIColor.lightGray, target: nil, action: nil)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return button
    }()
    /// 点赞按钮
    private lazy var likeButton:UIButton = {
        let button = UIButton(title: "点赞", imageName: "timeline_icon_unlike", fontSize: 15, normalColor: UIColor.lightGray, highlightedColor: UIColor.lightGray, target: nil, action: nil)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        return button
    }()
    
}

// MARK: - 设置界面

extension XGStatusBottomView
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 添加子控件
        let backgroundImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_background"))
        addSubview(backgroundImageView)
        addSubview(retweetButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        // 自动布局
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        retweetButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
        }
        
        commentButton.snp.makeConstraints { (make) in
            make.left.equalTo(retweetButton.snp.right)
            make.centerY.equalTo(retweetButton)
            make.size.equalTo(retweetButton)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.left.equalTo(commentButton.snp.right)
            make.right.equalTo(self)
            make.centerY.equalTo(retweetButton)
            make.size.equalTo(retweetButton)
        }
        
    }
}
