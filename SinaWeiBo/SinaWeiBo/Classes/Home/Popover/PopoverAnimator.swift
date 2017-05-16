//
//  PopoverAnimator.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/22.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

    fileprivate var isPresented : Bool = false
    
    var presentedFrame : CGRect = .zero
    var callBack : ((Bool) -> ())
    
    //自定义构造函数 
    //注意:如果自定义了一个构造函数,但是没有对默认构造函数进行重写,那么自定义的构造函数会覆盖默认的init()
    init(callBack : @escaping (Bool) -> ()) {
        self.callBack = callBack
    }
}

//MARK: - 自定义转场代理 UIViewControllerTransitioningDelegate
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
   
    //改变弹出View尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = SANPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    //自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack(isPresented)
        return self
    }
    //自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack(isPresented)
        return self
    }
}

//MARK: - 自定义转场代理 UIViewControllerTransitioningDelegate
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    // 动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    //获取转场上下文,可获取弹出和消失的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresented(using: transitionContext) : animationForDismissed(using: transitionContext)
    }
    
    //弹出动画
    fileprivate func animationForPresented(using transitionContext: UIViewControllerContextTransitioning){
        //获取弹出的View
        let presentedView = transitionContext.view(forKey: .to)!
        //将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //执行动画,设置View初始状态
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //View最终状态
            presentedView.transform = CGAffineTransform.identity
        }) { (_) in
            //必须告诉转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
    //消失动画
    fileprivate func animationForDismissed(using transitionContext: UIViewControllerContextTransitioning){
        //获取消失的View
        let dismissedView = transitionContext.view(forKey: .from)
        
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
        }) { (_) in
            dismissedView?.removeFromSuperview()
            //告诉转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
