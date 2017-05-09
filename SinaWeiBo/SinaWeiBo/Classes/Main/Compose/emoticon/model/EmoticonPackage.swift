//
//  EmoticonPackage.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/9.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    var emoticons : [Emoticon] = [Emoticon]()
    
    init(id : String) {
        //最近分组
        if id == "" {
            return
        }
        
        //根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        //根据plist文件的路径读取数据[[String : String]]
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]

        //遍历数组
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/\(png)"
            }
            emoticons.append(Emoticon(dict: dict))
        }
    }
    
}
