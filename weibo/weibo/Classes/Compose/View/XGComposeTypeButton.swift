//
//  XGComposeTypeButton.swift
//  weibo
//
//  Created by monkey on 2019/1/31.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGComposeTypeButton: UIControl
{
    // MARK: - 构造方法
    
    init(title:String?,imageName:String?)
    {
        super.init(frame: CGRect.zero)
        
        // 设置界面
        setUpUI()
        
        // 设置数据
        titleLabel.text = title
        imageName != nil ? imageView.image = UIImage(named: imageName!) : ()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    
    /// 标题
    private lazy var titleLabel:UILabel = UILabel(text: "测试文本", fontSize: 17, textColor: UIColor.lightGray, textAlignment: .center)
    /// 图片
    private lazy var imageView:UIImageView = UIImageView()
}

// MARK: - 设置界面

extension XGComposeTypeButton
{
    private func setUpUI() -> Void
    {
        // 添加子控件
        addSubview(imageView)
        addSubview(titleLabel)
        
        // 设置自动布局
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.height.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
        }
    }
}
