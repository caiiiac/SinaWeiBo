//
//  VisitorView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options:nil)!.first as! VisitorView
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
