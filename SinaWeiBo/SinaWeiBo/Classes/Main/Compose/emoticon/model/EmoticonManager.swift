//
//  EmoticonManager.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/9.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class EmoticonManager {

    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        //最近表情
        packages.append(EmoticonPackage(id: ""))
        
        //默认表情
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        //emoji表情
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        //浪小花表情
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
    
}
