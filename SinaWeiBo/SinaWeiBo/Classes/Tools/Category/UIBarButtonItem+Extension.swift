//
//  UIBarButtonItem+Extension.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName : String) {
        self.init()
        
        let btn = UIButton()
        btn.setImage(UIImage(named : imageName), for: .normal)
        btn.setImage(UIImage(named : imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.customView = btn
    }
}
