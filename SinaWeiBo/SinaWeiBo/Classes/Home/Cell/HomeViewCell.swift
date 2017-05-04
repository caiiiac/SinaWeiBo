//
//  HomeViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/2.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let edgeMargin : CGFloat = 15
fileprivate let itemMargin : CGFloat = 10

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
    //配图view
    @IBOutlet weak var picCollectionView: PicCollectionView!
    //转发微博正文
    @IBOutlet weak var retweetedContentLabel: UILabel!
    
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var bottomToolView: UIView!
    
    //MARK: - 约束属性
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
//    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedLabelTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
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
            
            //计算picView的宽高
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            //配图数据
            picCollectionView.picURLs = viewModel.picURLs
        
            //设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                    let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName):" + retweetedText
                
                    //有转发正文,顶部约束15
                    retweetedLabelTopCons.constant = 15
                }
                //设置背景显示
                retweetedBgView.isHidden = false
            }
            else
            {
                retweetedContentLabel.text = nil
                //隐藏灰色背景
                retweetedBgView.isHidden = true
                
                //没有转发正文,顶部约束0
                retweetedLabelTopCons.constant = 0
            }
            
            if viewModel.cellHeight == 0 {
                //强制布局
                layoutIfNeeded()
                //cell高度赋值
                viewModel.cellHeight = bottomToolView.frame.maxY
            }
            
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

//MARK: - 高度计算
extension HomeViewCell {
    fileprivate func calculatePicViewSize(count : Int) -> CGSize {
        //没有配图
        if count == 0 {
            //距离底部约束为0
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        //有配图,距离底部约束为10
        picViewBottomCons.constant = 10
        
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //一张配图
        if count == 1 {
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
            
            let size = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            layout.itemSize = size
            
            return size
        }
        //计算imageWH
        let imageWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3.0
        layout.itemSize = CGSize(width: imageWH, height: imageWH)

        //四张配图
        if count == 4 {
            let picWH = imageWH * 2 + itemMargin
            return CGSize(width: picWH, height: picWH)
        }
        
        //其它数量配图
        //计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //picView的宽高
        let picViewH = rows * imageWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}
