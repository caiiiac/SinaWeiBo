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
        super.init()
        
        //最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        //根据id拼接info.plist的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        //根据plist文件的路径读取数据[[String : String]]
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]

        //遍历数组
        var index = 0
        
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/\(png)"
            }
            
            emoticons.append(Emoticon(dict: dict))
            index += 1
            
            //插入删除按钮
            if index == 20 {
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        
        //添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
}

extension EmoticonPackage {
    fileprivate func addEmptyEmoticon(isRecently : Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty : true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
    }
}
