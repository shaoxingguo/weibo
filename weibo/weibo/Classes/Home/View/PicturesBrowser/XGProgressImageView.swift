//
//  XGProgressImageView.swift
//  weibo
//
//  Created by monkey on 2019/2/18.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGProgressImageView: UIImageView
{
    /// 进度
    open var progress:CGFloat = 0 {
        didSet {
            progressView.progress = progress
        }
    }
    
    // MARK: - 构造方法
    
    init()
    {
        super.init(frame: CGRect.zero)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    
    private lazy var progressView:XGProgressView = XGProgressView()
}

// MARK: - 设置界面

extension XGProgressImageView
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        progressView.frame = bounds
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        addSubview(progressView)
    }
}

// MARK: - XGProgressImageView

private class XGProgressView:UIView
{
    /// 进度
    open var progress:CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = min(center.x, center.y)
        let startAngle = CGFloat(Double.pi / 2 * -1)
        let endAngle = startAngle + 2 * CGFloat(Double.pi) * progress
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: center)
        path.close()
        UIColor.white.withAlphaComponent(0.3).set()
        path.fill()
    }
}
