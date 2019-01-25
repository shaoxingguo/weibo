//
//  XGStatusTableViewCell.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGNormalStatusTableViewCell: UITableViewCell
{
    // MARK: - 数据模型
    open var statusViewModel:XGStatusViewModel? {
        didSet {
            topView.statusViewModel = statusViewModel
            contentLabel.text = statusViewModel?.text
        }
    }
    
    // MARK: - 构造方法
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    /// 顶部视图
    private lazy var topView:XGStatusTopView = {
        let view = XGStatusTopView()
        view.backgroundColor = UIColor.white
        return view
    }()
    /// 文本
    private lazy var contentLabel:UILabel = UILabel(text: "测试文本", fontSize: 15, textColor: UIColor.lightGray, textAlignment: .left)
    
}


// MARK: - 设置界面

extension XGNormalStatusTableViewCell
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        
        // 自动布局
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(contentView).offset(kStatusCellPictureOuterMargin)
            make.right.equalTo(contentView).offset(-kStatusCellPictureOuterMargin)
            make.bottom.equalTo(contentView)
        }
    }
}
