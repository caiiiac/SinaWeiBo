//
//  HomeNetwork.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/27.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Foundation


//MARK: - 首页数据
extension SANNetworkManager {
    
    func loadStatuses(since_id : Int, max_id : Int, finished : @escaping ([[String : Any]]?, Error?) -> ()) {
        //url
        //公共接口:https://api.weibo.com/2/statuses/public_timeline.json
        //个人关注:https://api.weibo.com/2/statuses/home_timeline.json
        let urlString = "https://api.weibo.com/2/statuses/public_timeline.json"
        //参数
        let parameters = ["access_token" : (UserAccountManager.shareInstance.account?.access_token)!,
                          "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        //发送请求
        request(methodType: .GET, urlString: urlString, parameters: parameters) { (result, error) in
            //获取字典
            guard let resultDict = result as? [String : Any] else {
                finished(nil, error)
                return
            }
            //将数据回调
            finished(resultDict["statuses"] as? [[String : Any]], error)
        }
        
    }
}
