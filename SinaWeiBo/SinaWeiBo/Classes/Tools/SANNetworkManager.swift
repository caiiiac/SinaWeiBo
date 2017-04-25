//
//  SANNetworkManager.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/25.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import AFNetworking

enum RequestType : String{
    case GET = "GET"
    case POST = "POST"
}

class SANNetworkManager: AFHTTPSessionManager {
    
    static let shareInstance : SANNetworkManager = {
        let manager = SANNetworkManager()
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return manager
    }()
}


//MARK: - 封装请求方法
extension SANNetworkManager {
    func request(methodType : RequestType, urlString : String, parameters : [String : Any], finished : @escaping
        (Any?, Error?) -> ()) {
        
        //定义成功后的回调
        let successCallBack = { (task : URLSessionDataTask, result : Any?) in
            finished(result, nil)
        }
        //定义失败后的回调
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) in
            finished(nil, error)
        }
        
        
        if methodType == .GET {
            self.get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        else
        {
            self.post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

//MARK: - 请求AccessToken
extension SANNetworkManager {
    func loadAccessToken(code: String, finished : @escaping ([String : Any]?, Error?) -> ())  {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id" : app_key,
                          "client_secret" : app_secret,
                          "grant_type" : "authorization_code",
                          "redirect_uri" : redirect_uri,
                          "code" : code]
        
        request(methodType: .POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result as? [String : Any], error)
        }
    }
}
