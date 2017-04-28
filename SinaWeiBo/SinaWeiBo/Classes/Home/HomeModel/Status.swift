//
//  Status.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/27.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    //MARK: - 属性
    var created_at : String? {      //创建时间
        didSet {
            //校验nil
            guard let created_at = created_at else {
                return
            }
            //得到时间处理后的结果
            createAtText = Date.creatDateString(createAtStr: created_at)
        }
    }
    var source : String? {          //来源
        didSet {
            //校验nil
            guard let source = source, source != "" else {
                return
            }
            //对来源数据进行处理
            //source = "<a href=\"http://weibo.com/\" rel=\"nofollow\">iPad air2</a>";
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
            
        }
    }
    var text : String?              //正文
    var mid : Int  = 0              //ID
    
    var user : User?
    
    
    //数据处理后得到的属性
    var sourceText : String?
    var createAtText : String?
    
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
        //用户字典转model
        if let userDict = dict["user"] as? [String : Any] {
            user = User(dict: userDict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
