//
//  ProgressView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/17.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    //MARK: - 属性
    var progress : CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    //MARK: - 重写drawRect方法
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = -(CGFloat.pi / 2)
        let endAngle = CGFloat.pi * 2 * progress + startAngle
        
        //创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制到中心点的线
        path.addLine(to: center)
        path.close()
        //设置绘制颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        
        //开始绘制
        path.fill()
        
    }
    
}
