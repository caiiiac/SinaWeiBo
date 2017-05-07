//
//  PicPickerCollectionView.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/6.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

fileprivate let picIdentifier = "picPickerCell"
fileprivate let edgeMargin : CGFloat = 12

class PicPickerCollectionView: UICollectionView {
    
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        //设置collectionView属性
        register(UINib(nibName : "PicPickerViewCell", bundle : nil), forCellWithReuseIdentifier: picIdentifier)
        dataSource = self
        
        //设置内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }

}


extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picIdentifier, for: indexPath) as! PicPickerViewCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.row] : nil
                
        return cell
    }
}
