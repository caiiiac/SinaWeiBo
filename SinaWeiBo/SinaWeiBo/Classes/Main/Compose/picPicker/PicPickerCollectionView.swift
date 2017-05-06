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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        //设置collectionView属性
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: picIdentifier)
        dataSource = self
        
        //设置内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }

}


extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.yellow
        
        return cell
    }
}
