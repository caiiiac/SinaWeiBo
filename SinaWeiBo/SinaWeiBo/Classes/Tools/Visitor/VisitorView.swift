//
//  VisitorView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/20.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // MARK:- 控件属性
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabe: UILabel!
    
    // MARK:- 提供xib创建方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options:nil)!.first as! VisitorView
    }
    
    // MARK:- 自定义函数
    
    func setupVisitorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage(named: iconName)
        tipLabe.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnim() {
        //创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        //设置动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        
        //将动画添加到layer
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}
