//
//  HomeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    //MARK: - 属性
    fileprivate lazy var titleBtn : SANTitleButton = SANTitleButton()
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //没有登录时
        if !isLogin {
            visitorView.addRotationAnim()
            return
        }
        
        setupNavigationBar()
    }

}

//MARK: - 设置UI
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        
        //左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
    
        //titleView
        titleBtn.setTitle("红茶绅士", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

//MARK: - 事件监听
extension HomeViewController{

    @objc fileprivate func titleBtnClick() {
        //改变按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        //创建弹出控制器
        let popoverVC = PopoverViewController()
        //设置控制器modal样式
        popoverVC.modalPresentationStyle = .custom
        //设置转场代理
        popoverVC.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: (view.frame.width - 180) * 0.5, y: 55, width: 180, height: 250)
        
        //弹出控制器
        present(popoverVC, animated: true, completion: nil)
        
    }
}

