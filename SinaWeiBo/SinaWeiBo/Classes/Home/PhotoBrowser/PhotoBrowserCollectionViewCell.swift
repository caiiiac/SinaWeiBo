//
//  PhotoBrowserCollectionViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/16.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage

//图片点击代理
protocol PhotoBrowserViewCellDelegate : NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    //MARK: - 属性
    var picURL : URL? {
        didSet {
            setupContent(picURL: picURL)
        }
    }
    
    var delegate : PhotoBrowserViewCellDelegate?
    
    lazy var imageView : UIImageView = UIImageView()
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    //下载进度View
    fileprivate lazy var progressView : ProgressView = ProgressView()
    
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
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        
        //frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 15
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = contentView.center
        
        //进度View属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        //给imageView添加点击手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserCollectionViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
        
    }
}

//事件监听
extension PhotoBrowserCollectionViewCell {
    @objc fileprivate func imageViewClick() {
        delegate?.imageViewClick()
    }
}

extension PhotoBrowserCollectionViewCell {
    //设置图片
    fileprivate func setupContent(picURL : URL?) {
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
        
        //下载图片显示进度view
        progressView.isHidden = false
        
        //设置imageView的图片
        imageView.sd_setImageWithPreviousCachedImage(with: getBigURL(smallURL: picUrl), placeholderImage: image, options: [], progress: { (current, total, _) in
            //获取主线程刷新进度
            DispatchQueue.main.async {
                self.progressView.progress = CGFloat(current) / CGFloat(total)
            }
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        //设置contentSize
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    //大图链接
    fileprivate func getBigURL(smallURL : URL) -> URL {
        let smallURLString = smallURL.absoluteString as NSString
        let bigURLString = smallURLString.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigURLString)!
    }
}
