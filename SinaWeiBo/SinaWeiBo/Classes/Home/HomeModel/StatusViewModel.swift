//
//  StatusViewModel.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/2.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    //MARK: - 属性
    var status : Status?
    var cellHeight : CGFloat = 0
    
    
    //对数据处理的属性
    //来源
    var sourceText : String?
    //时间
    var createAtText : String?
    //认证图标
    var verifiedImage : UIImage?
    //会员等级图标
    var vipImage : UIImage?
    //用户头像URL
    var profileURL : URL?
    //配图数据
    var picURLs : [URL] = [URL]()
    
    
    //MARK: - 构造函数
    init(status : Status) {
        self.status = status
        
        //处理来源
        if let source = status.source, status.source != "" {
            
            //source = "<a href=\"http://weibo.com/\" rel=\"nofollow\">iPad air2</a>";
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            //截取字符串
            sourceText = "来自" + (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }

        //处理时间
        if let created_at = status.created_at  {
            //得到时间处理后的结果
            createAtText = Date.creatDateString(createAtStr: created_at)
        }
        
        //处理认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        //处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        //处理用户头像
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
        
        //处理配图数据
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL(string: picURLString)!)
            }
        }
    }
}
