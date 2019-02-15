//
//  XGImagePickerCollectionViewCell.swift
//  weibo
//
//  Created by monkey on 2019/2/15.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGImagePickerCollectionViewCell: UICollectionViewCell
{
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
    
    /// 图片按钮
    private lazy var pictureButton:UIButton = UIButton(title: nil, imageName: "compose_pic_add",target: nil, action: nil)
    /// 删除按钮
    private lazy var removeButton:UIButton = UIButton(title: nil, backgroundImageName: "compose_photo_close",target: nil, action: nil)
}

// MARK: - 设置界面

extension XGImagePickerCollectionViewCell
{
    private func setUpUI() -> Void
    {
        // 添加子控件
        contentView.addSubview(pictureButton)
        contentView.addSubview(removeButton)
        
        // 设置自动布局
        pictureButton.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.top.right.equalTo(contentView)
        }
    }
}
