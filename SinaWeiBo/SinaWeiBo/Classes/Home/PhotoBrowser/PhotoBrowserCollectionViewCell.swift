//
//  PhotoBrowserCollectionViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/16.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    //MARK: - 属性
    var picURL : URL? {
        didSet {
            //校验nil
            guard let picUrl = picURL else {
                return
            }
            //取出image
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString)
            
            //计算imageView的Frame
            
            let width = UIScreen.main.bounds.width
            let height = width / (image?.size.width)! * (image?.size.height)!
            
            
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.height {
                y = 0
            } else {
                y = (UIScreen.main.bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            
            //设置imageView的图片
            imageView.image = image
            
        }
    }
    
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    fileprivate lazy var imageView : UIImageView = UIImageView()
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - UI
extension PhotoBrowserCollectionViewCell {
    fileprivate func setupUI() {
        //添加控件
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        
        scrollView.frame = contentView.bounds
    }
}
