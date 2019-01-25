//
//  XGStatusTopView.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit
import SnapKit

class XGStatusTopView: UIView
{
    // MARK: - 数据模型
    open var statusViewModel:XGStatusViewModel? {
        didSet {
            if statusViewModel?.profileImage != nil {
                iconImageView.image = statusViewModel?.profileImage
            } else {
                iconImageView.xg_setImage(URLString: statusViewModel?.profileImageUrl, placeholderImage: kPlaceholderImage) { [weak self] (image) in
                    if image != nil {
                        let circleImage = image?.circleIconImage(imageSize: CGSize(width: 60, height: 60), backgroundColor: self?.backgroundColor ?? UIColor.white)
                        self?.iconImageView.image = circleImage
                    }
                }
            }
            nameLabel.text = statusViewModel?.screenName
            vipImageView.image = statusViewModel?.vipImage
            verifiedImageView.image = statusViewModel?.verifiedImage
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
    /// 分割线
    private lazy var separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithHexString(hexadecimal: "#F2F2F2")
        return view
    }()
    /// 头像
    private lazy var iconImageView:UIImageView = UIImageView()
    /// 昵称
    private lazy var nameLabel:UILabel = UILabel(text: "菠萝吹雪", fontSize: 15, textColor: UIColor.colorWithHexString(hexadecimal: "#F33E00"), textAlignment: .left)
    /// VIP
    private lazy var vipImageView:UIImageView = UIImageView()
    /// 认证图片
    private lazy var verifiedImageView:UIImageView = UIImageView()
    /// 发布时间
    private lazy var createTimeLabel:UILabel = UILabel(text: "刚刚", fontSize: 13, textColor: UIColor.colorWithHexString(hexadecimal: "#FF6C00"))
    /// 来源
    private lazy var soureLabel:UILabel = UILabel(text: "微博", fontSize: 13, textColor: UIColor.colorWithHexString(hexadecimal: "#828282"))
    
}
// MARK: - 设置界面

extension XGStatusTopView
{
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 添加子控件
        addSubview(separatorView)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(vipImageView)
        addSubview(verifiedImageView)
        addSubview(createTimeLabel)
        addSubview(soureLabel)
        
        // 设置自动布局
        separatorView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(8)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorView.snp.bottom).offset(kStatusCellPictureOuterMargin)
            make.left.equalTo(self).offset(kStatusCellPictureOuterMargin)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalTo(self).offset((-kStatusCellPictureOuterMargin))
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(kStatusCellPictureOuterMargin)
        }
        
        vipImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset((3))
        }
        
        verifiedImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImageView.snp.right)
            make.centerY.equalTo(iconImageView.snp.bottom)
        }
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView)
            make.left.equalTo(nameLabel)
        }
        
        soureLabel.snp.makeConstraints { (make) in
            make.left.equalTo(createTimeLabel.snp.right).offset(kStatusCellPictureOuterMargin)
            make.top.equalTo(createTimeLabel)
        }
    }
}
