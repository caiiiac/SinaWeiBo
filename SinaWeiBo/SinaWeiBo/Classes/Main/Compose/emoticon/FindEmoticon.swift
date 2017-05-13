//
//  FindEmoticon.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/13.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    //MARK: - 设计单例对象
    static let shareIntance : FindEmoticon = FindEmoticon()
    
    //MARK: - 表情属性
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    
    func findAttrString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        
        //如果statusText为nil
        guard let statusText = statusText else {
            return nil
        }
        
        //创建匹配规则 - 表情
        let pattern = "\\[.*?\\]"
        //创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options : []) else {
            return nil
        }
        
        //开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSMakeRange(0, statusText.characters.count))
        
        //获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        //倒序查找表情并替换
        for i in (0..<results.count).reversed() {
            
            let result = results[i]
            
            let chs = (statusText as NSString).substring(with: result.range)
            //根据chs,获取表情图片路径
            guard let pngPath = findPngPath(chs: chs) else {
                continue
            }
            
            //创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            //将属性字符串替换
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
            
        }
        
        return attrMStr
    }

    //按chs查找表情图片path
    fileprivate func findPngPath(chs : String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        
        return nil
    }
}
