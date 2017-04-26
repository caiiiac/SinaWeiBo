//
//  ProfileNetwork.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/25.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Foundation

//MARK: - 我的相关数据请求
//请求用户信息
extension SANNetworkManager {
    func loadUserInfo(accessToken : String, uid : String, finished : @escaping ([String : Any]?, Error?) -> ()) {
        //url
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token" : accessToken, "uid" : uid]
        
        request(methodType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
        
    }
}
