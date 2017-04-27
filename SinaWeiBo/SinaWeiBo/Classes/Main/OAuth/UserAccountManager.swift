//
//  UserAccountManager.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/26.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class UserAccountManager {
    //MARK: - 单例
    static let shareInstance : UserAccountManager = UserAccountManager()
    
    
    //MARK: - 属性
    var account : UserAccount?
    
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expireDate = account?.expires_date else {
            return false
        }
        
        return expireDate.compare(Date()) == .orderedDescending
    }
    
    //MARK: - 重写init函数
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
    
}
