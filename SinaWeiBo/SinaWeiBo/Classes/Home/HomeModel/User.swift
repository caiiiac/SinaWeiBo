//
//  User.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/28.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class User: NSObject {
    
    //头像
    var profile_image_url : String?
    //昵称
    var screen_name : String?
    //认证类型
    var verified_type : Int = -1 
    //会员等级
    var mbrank : Int = 0     
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    

}
