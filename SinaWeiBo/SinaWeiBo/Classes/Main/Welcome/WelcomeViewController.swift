//
//  WelcomeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/26.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage


class WelcomeViewController: UIViewController {
    
    //约束属性
    @IBOutlet weak var iconViewCenterCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置头像
        let profileURLString = UserAccountManager.shareInstance.account?.avatar_large
        // ?? : 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        //如果??前面的可选类型为nil,那么直接使用??后面的值
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //改变约束
        iconViewCenterCons.constant = -200
        
        //动画
        //Damping : 阻力系数,阻力越大,弹动效果越不明显
        //initialSpringVelocity : 初始化速度
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }

}
