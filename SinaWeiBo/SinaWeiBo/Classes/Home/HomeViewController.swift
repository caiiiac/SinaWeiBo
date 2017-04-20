//
//  HomeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    lazy var titleBtn : SANTitleButton = SANTitleButton()
    
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
        popoverVC.modalPresentationStyle = .custom
        popoverVC.transitioningDelegate = self
        //弹出控制器
        present(popoverVC, animated: true, completion: nil)
        
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SANPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
