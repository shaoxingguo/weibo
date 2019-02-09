//
//  XGEmotionCollectionViewCell.swift
//  weibo
//
//  Created by monkey on 2019/2/8.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

/// 表情页列数
public let kEmotionColumns:Int = 7
/// 表情页行数
public let kEmotionRows:Int = 3
/// 每页表情个数
public let kEmotionPageCount = kEmotionColumns * kEmotionRows - 1

class XGEmotionCollectionViewCell: UICollectionViewCell
{
    // MARK: - 数据模型
    
    /// 代理
    open weak var delegate:XGEmotionCollectionViewCellDelegate?
    
    var emotions:[XGEmotionModel]? {
        didSet {
            // 隐藏所有表情按钮
            for button in contentView.subviews {
                button.isHidden = true
            }
            
            // 显示删除按钮
            contentView.subviews.last?.isHidden = false
            
            // 设置表情图片
            if let emotions = emotions {
                for (index,emotionModel) in emotions.enumerated() {
                    let button = contentView.subviews[index] as? UIButton
                    button?.setBackgroundImage(emotionModel.image, for: .normal)
                    button?.isHidden = false
                }
            }
        }
    }
    
    // MARK: - 监听方法
    
    /// 表情选中事件
    @objc private func emotionDidSelectedAction(button:UIButton) -> Void
    {
        // tag = 20 是删除传nil 其他根据索引取表情模型传入
        let emotionModel:XGEmotionModel? = (button.tag == kEmotionPageCount ? nil : emotions?[button.tag])
        delegate?.emotionCollectionViewCellEmotionDidSelected?(emotionModel: emotionModel)
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
    
    deinit {
        XGPrint("我去了")
    }
}

// MARK: - 设置界面

extension XGEmotionCollectionViewCell
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        // 布局子控件
        var x:CGFloat = 0
        var y:CGFloat = 0
        var row:Int = 0     // 行
        var column:Int = 0  // 列
        let itemWidth:CGFloat = 36 // 表情大小
        let hMargin:CGFloat = (contentView.width - CGFloat(kEmotionColumns) * itemWidth) / CGFloat(kEmotionColumns - 1 + 2) // 水平间距
        let vMargin = (contentView.height - CGFloat(kEmotionRows) * itemWidth) / CGFloat(kEmotionRows) // 垂直间距
        for (index,button) in contentView.subviews.enumerated() {
            row = index / kEmotionColumns
            column = index % kEmotionColumns
            x = hMargin + CGFloat(column) * (itemWidth + hMargin)
            y = vMargin + CGFloat(row) * (itemWidth + vMargin)
            button.frame = CGRect(x: x, y: y, width: itemWidth, height: itemWidth)
        }
    }
    /// 设置界面
    private func setUpUI() -> Void
    {
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        // 添加子控件
        for i in 0..<(kEmotionColumns * kEmotionRows) {
            let button = UIButton()
            button.addTarget(self, action: #selector(emotionDidSelectedAction(button:)), for: .touchUpInside)
            if i == (kEmotionColumns * kEmotionRows - 1) {
                button.setBackgroundImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            
            button.tag = i
            contentView.addSubview(button)
        }
    }
}

@objc public protocol XGEmotionCollectionViewCellDelegate
{
    /// 表情选中事件
    ///
    /// - Parameter emotionModel: 选中的表情 emotionModel == nil时代表删除
    @objc optional func emotionCollectionViewCellEmotionDidSelected(emotionModel:XGEmotionModel?) -> Void
}
