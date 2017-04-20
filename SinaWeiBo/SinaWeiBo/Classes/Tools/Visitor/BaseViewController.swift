//
//  BaseViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    lazy var visitorView : VisitorView = VisitorView.visitorView()
    
    //MARK:- 变量
    var isLogin : Bool = true
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //导航栏添加"注册" "登录"
        setupNavigationItems()
    }

}

//MARK: - 设置UI
extension BaseViewController {
    func setupVisitorView() {
     view = visitorView
        
        //监听"注册" "登录"按钮点击事件
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
    
    //设置导航栏左右的Item
    func setupNavigationItems() {
        
        guard !isLogin else {
            return
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClick))
    }
}

//MARK: - 事件监听
extension BaseViewController {

    @objc fileprivate func registerBtnClick(){
        print("register")
    }
    
    @objc fileprivate func loginBtnClick()  {
        print("login")
    }
}
