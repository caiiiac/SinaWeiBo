//
//  UIButton-Extension.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/16.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init (imageName: String, bgImageName: String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
}
