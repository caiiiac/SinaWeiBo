//
//  Emoticon.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/9.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit


class Emoticon: NSObject {
    //MARK: - 属性
    //emoji的code
    var code : String? {
        didSet {
            guard let code = code else {
                return
            }
            //创建扫描器
            let  scanner = Scanner(string: code)
            //扫描出code中的值
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            //将value转成字符
            let c = Character(UnicodeScalar(value)!)
            emojiCode = String(c)
            
        }
    }
    //普通表情对应的图片名称
    var png : String? {
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    //普通表情对应的文字
    var chs : String?
    
    //MARK: - 计算属性
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    
    //MARK: - 自定义构造函数
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isRemove : Bool) {
        super.init()
        
        self.isRemove = isRemove
    }
    
    init(isEmpty : Bool) {
        super.init()
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["code", "pngPath", "chs"]).description
    }
}
