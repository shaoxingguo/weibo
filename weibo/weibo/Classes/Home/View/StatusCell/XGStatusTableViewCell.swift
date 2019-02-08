//
//  XGStatusTableViewCell.swift
//  weibo
//
//  Created by monkey on 2019/1/27.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import FFLabel

class XGStatusTableViewCell: UITableViewCell
{
    // MARK: - 数据模型
    
    open var statusViewModel:XGStatusViewModel? {
        didSet {
            topView.statusViewModel = statusViewModel
            contentLabel.attributedText = statusViewModel?.text
            bottomView.statusViewModel = statusViewModel
            picturesView.statusViewModel = statusViewModel
            // 更新高度
            picturesView.snp.updateConstraints { (make) in
                make.height.equalTo(statusViewModel?.picturesViewSize.height ?? 0).priority(.high)
            }
        }
    }
    
    // MARK: - 构造方法
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 设置界面
        setUpUI()
        
        // 选中样式
        selectionStyle = .none
        
        // 异步绘制
        layer.drawsAsynchronously = true
        
        // 栅格化
        layer.shouldRasterize = true
        layer.rasterizationScale = kScreenScale
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
    private(set) open lazy var contentLabel:UILabel = {
        let label = FFLabel(text: "测试文本", fontSize: kContentTextFontSize, textColor: kContentTextColor, textAlignment: .left)
        return label
    }()
    /// 配图视图
    private(set) open lazy var picturesView:XGStatusPicturesView = {
        let view = XGStatusPicturesView()
        view.backgroundColor =  UIColor.white
        return view
    }()
    /// 底部视图
   private lazy var bottomView:XGStatusBottomView = {
        let view = XGStatusBottomView()
        view.backgroundColor = UIColor.corlorWith(red: 243, green: 243, blue: 243)
        return view
    }()


    // MARK: - 设置界面
    
    /// 设置界面
    open func setUpUI() -> Void
    {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(picturesView)
        contentView.addSubview(bottomView)
        
        // 自动布局
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalTo(contentView).offset(kStatusCellPictureOuterMargin)
            make.right.equalTo(contentView).offset(-kStatusCellPictureOuterMargin)
        }

        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(kToolBarHeight)
        }
    }
}

