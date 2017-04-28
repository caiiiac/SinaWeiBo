//
//  NSDate-Extension.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/28.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import Foundation


extension Date {
    
    static func creatDateString(createAtStr : String) -> String {
        //创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        //将字符串时间,转成Date
        guard let creatDate = fmt.date(from: createAtStr) else {
            return ""
        }
        //当前时间
        let nowDate = Date()
        //计算时间差
        let  interval = Int(nowDate.timeIntervalSince(creatDate))
        
        //时间间隔处理
        //刚刚
        if interval < 60 {
            return "刚刚"
        }
        //60分钟内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        //12小时内
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        //创建日历对象
        let calendar = Calendar.current
        
        //昨天
        if calendar.isDateInYesterday(creatDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }
        //一年以内
        let cmps = calendar.dateComponents([.year], from: creatDate, to: nowDate)
        
        if cmps.year! < 1{
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: creatDate)
            return timeStr
        }
        //超过一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: creatDate)
        return timeStr
        
        
        
    }
}
