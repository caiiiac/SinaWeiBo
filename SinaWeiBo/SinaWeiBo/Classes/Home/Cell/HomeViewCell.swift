//
//  HomeViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/2.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage

//private let edgeMargin : CGFloat = 15

class HomeViewCell: UITableViewCell {

    //MARK: - 属性
    //正文
    @IBOutlet weak var contentLabel: UILabel!
    //来源
    @IBOutlet weak var sourceLabel: UILabel!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    //昵称
    @IBOutlet weak var screenNameLabel: UILabel!
    //认证
    @IBOutlet weak var verifiedView: UIImageView!
    //头像
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    //MARK: - 约束属性
//    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
    var viewModel : StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            iconImageView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            //认证图标
            verifiedView.image = viewModel.verifiedImage
            //昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            //会员图标
            vipImageView.image = viewModel.vipImage
            //时间
            timeLabel.text = viewModel.createAtText
            //来源
            sourceLabel.text = viewModel.sourceText
            //微博正文
            contentLabel.text = viewModel.status?.text
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //微博正文宽度约束
//        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
