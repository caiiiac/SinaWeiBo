//
//  ComposeNetwork.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/12.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Foundation

extension SANNetworkManager {
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSucceed : Bool) -> ()) {
        //请求的url
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //请求的参数
        let parameters = ["access_token" : (UserAccountManager.shareInstance.account?.access_token)!,
                          "status" : statusText]
        
        //发送请求
        request(methodType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSuccess(true)
            }
            else
            {
                isSuccess(false)
            }
        }
        
        
    }
}
