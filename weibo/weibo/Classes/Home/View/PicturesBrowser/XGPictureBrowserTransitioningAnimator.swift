//
//  XGPictureBrowserTransitioningAnimator.swift
//  weibo
//
//  Created by monkey on 2019/2/20.
//  Copyright © 2019 itcast. All rights reserved.
//

import UIKit

class XGPictureBrowserTransitioningAnimator: NSObject,UIViewControllerTransitioningDelegate
{
    /// presented动画代理
    weak open var presentedDelegate:XGPictureBrowserTransitioningAnimatorPresentedDelegate?
    open var index:Int = 0
    
    /// 是否是展现
    private var isPresented:Bool = false
    
    // 返回present动画对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresented = true
        return self
    }
    
    // 返回dismiss动画对象
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        isPresented = false
//        return self
//    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension XGPictureBrowserTransitioningAnimator: UIViewControllerAnimatedTransitioning
{
    // 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 1
    }
    
    /// 转场动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        isPresented ? showPresentedAnimation(transitionContext: transitionContext) : showDismissAnimation(transitionContext: transitionContext)
    }
    
    // present转场动画
    private func showPresentedAnimation(transitionContext:UIViewControllerContextTransitioning) -> Void
    {
        guard let imageView = presentedDelegate?.showPresentedAnimationImageView?(index: index),
              let fromRect = presentedDelegate?.presentedFromRect?(index: index),
              let toRect = presentedDelegate?.presentedToRect?(index: index),
              let toView = transitionContext.view(forKey: .to) else {
                return
        }
       
        // 转场动画的内容视图
        let contentView = transitionContext.containerView
        // 目标视图
        contentView.addSubview(toView)
        contentView.alpha = 0
        
        imageView.frame = fromRect
        contentView.addSubview(imageView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            contentView.alpha = 1
            imageView.frame = toRect
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    // dismiss转场动画
    private func showDismissAnimation(transitionContext:UIViewControllerContextTransitioning) -> Void
    {
        
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

@objc public protocol XGPictureBrowserTransitioningAnimatorPresentedDelegate
{
    @objc optional func showPresentedAnimationImageView(index:Int) -> UIImageView
    @objc optional func presentedFromRect(index:Int) -> CGRect
    @objc optional func presentedToRect(index:Int) -> CGRect
}
