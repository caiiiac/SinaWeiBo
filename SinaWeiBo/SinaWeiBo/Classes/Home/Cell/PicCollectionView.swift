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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil, userInfo: userInfo)
        
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
