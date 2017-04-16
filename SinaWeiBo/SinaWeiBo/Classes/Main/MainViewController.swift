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
    lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    lazy var composeBtn : UIButton = UIButton()
    
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

extension MainViewController {
    //设置发布按钮
    func setupComposeBtn() {
        //添加按钮
        tabBar.addSubview(composeBtn)
        
        //设置属性
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        composeBtn.sizeToFit()
        
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        
    }
    
    func setupTabBarItems() {
        //遍历所有item
        for i in 0..<tabBar.items!.count {
            //获取item
            let item = tabBar.items![i]
            
            //如果下标为2,则item不可以交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
            //设置item选中时的图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
}
