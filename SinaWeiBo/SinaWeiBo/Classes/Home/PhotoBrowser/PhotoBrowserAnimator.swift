//
//  PhotoBrowserAnimator.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/19.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit


//协议
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexPath : NSIndexPath) -> CGRect
    func endRect(indexPath : NSIndexPath) -> CGRect
    func imageViewForPresented(indexPath : NSIndexPath) -> UIImageView
}


class PhotoBrowserAnimator: NSObject {

    var isPresented : Bool = false
    var presentedDelegate : AnimatorPresentedDelegate?
    var indexPath : NSIndexPath?
    
    
}



extension PhotoBrowserAnimator : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(using: transitionContext) : animationForDismissView(using: transitionContext)
    }
    
    func animationForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        //取出弹出的View
        let presentedView = transitionContext.view(forKey: .to)!
        
        //将presentedView添加到containerView
        transitionContext.containerView.addSubview(presentedView)
        
        //获取动画imageView
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageViewForPresented(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        //执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
        
    }
    
    func animationForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        //取出消失的view
        let dismissView = transitionContext.view(forKey: .from)!
        
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView.alpha = 0.0
        }) { (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
