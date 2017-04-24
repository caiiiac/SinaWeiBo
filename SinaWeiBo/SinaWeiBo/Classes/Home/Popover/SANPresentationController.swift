//
//  SANPresentationController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANPresentationController: UIPresentationController {

    var presentedFrame : CGRect = CGRect.zero
    
    fileprivate lazy var coverView : UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //改变frame大小
        presentedView?.frame = presentedFrame
        
        //添加蒙版
        setupCoverView()
    }
}

//MARK: - 设置UI
extension SANPresentationController {

    fileprivate func setupCoverView() {
        containerView?.insertSubview(coverView, at: 0)
        
        coverView.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
        coverView.frame = containerView!.bounds
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(SANPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

//MARK: - 事件监听
extension SANPresentationController {
    @objc fileprivate func coverViewClick() {
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
