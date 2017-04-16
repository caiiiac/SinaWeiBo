//
//  MainViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK:- 懒加载属性
    lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    // MARK:- 自有函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupComposeBtn()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupTabBarItems()
    }


}

// MARK:- UI
extension MainViewController {
    //设置发布按钮
    func setupComposeBtn() {
        //添加按钮
        tabBar.addSubview(composeBtn)
        
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
    }
    
}
