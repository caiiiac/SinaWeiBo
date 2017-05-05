//
//  ComposeTextView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    //占位Label
    lazy var placeHolderLabel : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
}
//MARK: - 设置UI
extension ComposeTextView {
    fileprivate func setupUI() {
        addSubview(placeHolderLabel)
        //设置frame
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //设置placeHolderLabel属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        //设置默认语
        placeHolderLabel.text = "分享新微博"
        
        textContainerInset = UIEdgeInsetsMake(8, 8, 0, 8)
    }
}
