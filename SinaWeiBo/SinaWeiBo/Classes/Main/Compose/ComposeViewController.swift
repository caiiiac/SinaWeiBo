//
//  ComposeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置导航
        setupNavigationBar()
    }


}

extension ComposeViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.titleView = titleView
    }
}

extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func sendItemClick() {
        
    }
}
