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
    var verified_type : Int = -1 {
        didSet {
            switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
            }
        }
    }
    //会员等级
    var mbrank : Int = 0 {
        didSet {
            if mbrank > 0 && mbrank <= 6 {
                vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
    
    //计算属性
    var verifiedImage : UIImage?
    var vipImage : UIImage?
    
    
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    

}
