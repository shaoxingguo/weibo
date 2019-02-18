//
//  XGImagePickerCollectionViewCell.swift
//  weibo
//
//  Created by monkey on 2019/2/15.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

private let kDefaultImage = UIImage(named: "compose_pic_add")

public class XGImagePickerCollectionViewCell: UICollectionViewCell
{
    /// 代理
    open weak var delegate:XGImagePickerCollectionViewCellDelegate?
    
    /// 图片
    open var image:UIImage? {
        didSet {
            pictureButton.setBackgroundImage(image != nil ? image : kDefaultImage, for: .normal)
            removeButton.isHidden = image == nil
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
    
    // MARK: - 事件监听
    
    /// 添加图片
    @objc private func addPictureAction() -> Void
    {
        delegate?.imagePickerCollectionViewCellAddPicture?(cell: self)
    }
    
    /// 移除图片
    @objc private func removePictureAction() -> Void
    {
        delegate?.imagePickerCollectionViewCellRemovePicture?(cell: self)
    }
    
    // MARK: - 懒加载
    
    /// 图片按钮
    private lazy var pictureButton:UIButton = { [weak self] in
        let button = UIButton()
        button.setBackgroundImage(kDefaultImage, for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(addPictureAction), for: .touchUpInside)
        return button
    }()
    /// 删除按钮
    private lazy var removeButton:UIButton = UIButton(title: nil, backgroundImageName: "compose_photo_close",target: self, action: #selector(removePictureAction))
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

// MARK: - XGImagePickerCollectionViewCellDelegate

@objc public protocol XGImagePickerCollectionViewCellDelegate
{
    @objc optional func imagePickerCollectionViewCellAddPicture(cell:XGImagePickerCollectionViewCell) -> Void
    @objc optional func imagePickerCollectionViewCellRemovePicture(cell:XGImagePickerCollectionViewCell) -> Void
}
