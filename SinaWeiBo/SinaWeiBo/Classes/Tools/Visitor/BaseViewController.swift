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
    var isLogin : Bool = false
    
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension BaseViewController {
    func setupVisitorView() {
     view = visitorView
    }
}
