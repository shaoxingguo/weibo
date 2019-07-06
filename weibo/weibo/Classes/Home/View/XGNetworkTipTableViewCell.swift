//
//  XGNetworkTipTableViewCell.swift
//  weibo
//
//  Created by monkey on 2019/7/6.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGNetworkTipTableViewCell: UITableViewCell {

    // MARK: - 构造方法
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.text = "世界上最遥远的距离就是没有网络!"
        textLabel?.textColor = UIColor.white
        contentView.backgroundColor = UIColor.corlorWith(red: 245, green: 90, blue: 93)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
