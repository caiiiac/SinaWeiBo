//
//  ComposeNetwork.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/12.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

extension SANNetworkManager {
    //发送文字微博
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
    //发送带图片的微博
    func sendStatus(statusText : String, image : UIImage, isSuccess : @escaping (_ isSucceed : Bool) -> ())  {
        //请求的url
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        //请求的参数
        let parameters = ["access_token" : (UserAccountManager.shareInstance.account?.access_token)!,
                          "status" : statusText]
        
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            //将图片转成data上传
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "img.png", mimeType: "image/png")
            }
            
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, _) in
            isSuccess(false)
        }

    }
}
