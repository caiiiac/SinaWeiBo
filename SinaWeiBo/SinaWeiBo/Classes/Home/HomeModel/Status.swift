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
    var created_at : String?       //创建时间
    var source : String?          //来源
    var text : String?              //正文
    var mid : Int  = 0              //ID
    
    var user : User?
    
    
    
    
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
