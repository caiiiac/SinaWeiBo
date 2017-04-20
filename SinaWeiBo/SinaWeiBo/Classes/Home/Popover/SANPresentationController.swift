//
//  SANPresentationController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class SANPresentationController: UIPresentationController {

    fileprivate lazy var coverView : UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //改变frame大小
        presentedView?.frame = CGRect(x: (containerView!.frame.width - 180) * 0.5, y: 55, width: 180, height: 250)
        
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
