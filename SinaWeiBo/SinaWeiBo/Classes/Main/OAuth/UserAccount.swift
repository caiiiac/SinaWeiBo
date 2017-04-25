//
//  UserAccount.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/25.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    //MARK: - 属性
    //授权AccessToken
    var access_token : String?
    //过期时间 秒
    var expires_in : TimeInterval = 0.0{
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //用户ID
    var uid : String?
    //过期日期
    var expires_date: Date?
    
    
    //MARK: - 自定义构造
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
//    override func setValuesForKeys(_ keyedValues: [String : Any]) {}
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    
    //MARK: - 重写description
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid"]).description
    }
}
