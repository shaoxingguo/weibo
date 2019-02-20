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
    open weak var presentedDelegate:XGPictureBrowserTransitioningAnimatorPresentedDelegate?
    /// dismiss动画代理
    open weak var dismissDelegate:XGPictureBrowserTransitioningAnimatorDismissDelegate?
    /// 选中的图片索引
    open var selecedIndex:Int = 0
    
    
    /// 设置代理信息
    ///
    /// - Parameters:
    ///   - presentedDelegate: presented动画代理
    ///   - dismissDelegate: dismiss动画代理
    ///   - selectedIndex: 选中的图片索引
    open func setDelegate(presentedDelegate:XGPictureBrowserTransitioningAnimatorPresentedDelegate,
                    dismissDelegate:XGPictureBrowserTransitioningAnimatorDismissDelegate,
                    selectedIndex:Int)
    {
        self.presentedDelegate = presentedDelegate
        self.dismissDelegate = dismissDelegate
        self.selecedIndex = selectedIndex
    }
    /// 是否是展现
    private var isPresented:Bool = false
    
    // 返回present动画对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresented = true
        return self
    }
    
    // 返回dismiss动画对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresented = false
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension XGPictureBrowserTransitioningAnimator: UIViewControllerAnimatedTransitioning
{
    // 返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    /// 转场动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        isPresented ? showPresentedAnimation(transitionContext: transitionContext) : showDismissAnimation(transitionContext: transitionContext)
    }
    
    // present转场动画
    private func showPresentedAnimation(transitionContext:UIViewControllerContextTransitioning) -> Void
    {
        guard let imageView = presentedDelegate?.showPresentedAnimationImageView?(index: selecedIndex),
              let fromRect = presentedDelegate?.presentedFromRect?(index: selecedIndex),
              let toRect = presentedDelegate?.presentedToRect?(index: selecedIndex),
              let toView = transitionContext.view(forKey: .to) else {
                return
        }
       
        // 转场动画的内容视图
        let contentView = transitionContext.containerView
        contentView.addSubview(toView) // 将目标视图(控制器的view)添加到容器中
        contentView.alpha = 0
        // 添加动画imageView
        imageView.frame = fromRect
        contentView.addSubview(imageView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            contentView.alpha = 1
            imageView.frame = toRect
        }) { (_) in
            // 移除动画imageView
            imageView.removeFromSuperview()
            // 一定要调用完成回调 否则无法正确进行modal控制器
            transitionContext.completeTransition(true)
        }
    }
    
    // dismiss转场动画
    private func showDismissAnimation(transitionContext:UIViewControllerContextTransitioning) -> Void
    {
        guard let imageView = dismissDelegate?.showDismissAnimationImageView?(),
              let currentIndex = dismissDelegate?.dismissImageViewIndex?(),
              let fromRect = dismissDelegate?.dismissFromRect?(),
              let toRect = presentedDelegate?.presentedFromRect?(index: currentIndex),
              let fromView = transitionContext.view(forKey: .from) else {
                return
        }
        
        fromView.removeFromSuperview() // 移除控制器的view
        // 转场动画的内容视图
        let contentView = transitionContext.containerView
        contentView.addSubview(imageView)
        imageView.frame = fromRect
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = toRect
        }) { (_) in
            // 移除动画imageView
            imageView.removeFromSuperview()
            // 一定要调用完成回调 否则无法正确进行modal控制器
           transitionContext.completeTransition(true)
        }
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

@objc public protocol XGPictureBrowserTransitioningAnimatorPresentedDelegate
{
    @objc optional func showPresentedAnimationImageView(index:Int) -> UIImageView
    @objc optional func presentedFromRect(index:Int) -> CGRect
    @objc optional func presentedToRect(index:Int) -> CGRect
}

// MARK: - XGPictureBrowserTransitioningAnimatorDismissDelegate

@objc public protocol XGPictureBrowserTransitioningAnimatorDismissDelegate
{
    @objc optional func showDismissAnimationImageView() -> UIImageView
    @objc optional func dismissFromRect() -> CGRect
    @objc optional func dismissImageViewIndex() -> Int
}
