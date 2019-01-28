//
//  XGStatusTableViewCell.swift
//  weibo
//
//  Created by monkey on 2019/1/25.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGNormalStatusTableViewCell: XGStatusTableViewCell
{
    // MARK: - 设置界面
    
    override func setUpUI()
    {
        super.setUpUI()
        
        // 设置配图视图自动布局
        picturesView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom)
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(200).priority(.high)
        }
    }
}
