//
//  PicCollectionView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/3.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage


class PicCollectionView: UICollectionView {

    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}


//MARK: - DataSource方法
extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePicCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
    
    //图片点击
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //获取通知要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picURLs] as [String : Any]
        
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
        
    }
}

//MARK: - 自定义动画AnimatorPresentedDelegate
extension PicCollectionView : AnimatorPresentedDelegate {

    func startRect(indexPath: NSIndexPath) -> CGRect {
        //获取cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        
        //获取cell的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        return startFrame
    }
    
    func endRect(indexPath: NSIndexPath) -> CGRect {
        //获取image对象
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //计算结束后的frame
        let w = UIScreen.main.bounds.size.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if y > UIScreen.main.bounds.size.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //创建imageView对象
        let imageView = UIImageView()
        
        //获取image
        let picURL = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURL.absoluteString)
        
        //设置imageView
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}


class PicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    var picURL : URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    
}
