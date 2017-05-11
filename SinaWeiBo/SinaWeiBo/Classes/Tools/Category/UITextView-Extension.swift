//
//  UITextView-Extension.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/11.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

extension UITextView {
    
    //获取属性字符串对应的表情字符串
    func getEmoticonString() -> String {
        //获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        //遍历属性字符串
        let range = NSMakeRange(0, attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        
        return attrMStr.string
    }
    
    //将表情插入到textView
    func insertEmoticon(emoticon : Emoticon) {
        //空白表情
        if emoticon.isEmpty {
            return
        }
        //删除表情
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        //emoji表情
        if emoticon.emojiCode != nil {
            //获取光标所在位置
            let textRange = self.selectedTextRange!
            //替换emoju表情
            replace(textRange, withText: emoticon.emojiCode!)
            
            return
        }
        
        //普通表情:图文混排
        //根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        attachment.chs = emoticon.chs
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //创建可变的属性字符串
        let attMStr = NSMutableAttributedString(attributedString: attributedText)
        //获取光标所在位置
        let range = selectedRange
        //替换属性字符串
        attMStr.replaceCharacters(in: range, with: attrImageStr)
        //将最终属性字符串赋值给textView
        attributedText = attMStr
        
        //重置文字大小
        self.font = font
        //设置光标位置
        selectedRange = NSMakeRange(range.location + 1, 0)
        replace(selectedTextRange!, withText: "")
    }

    
}
