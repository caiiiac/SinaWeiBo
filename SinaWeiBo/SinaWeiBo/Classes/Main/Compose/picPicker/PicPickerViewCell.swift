//
//  PicPickerViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/7.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {

    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removePhotoBtn: UIButton!
    
    
    var image : UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
            }
            else
            {
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removePhotoBtn.isHidden = true
            }
        }
    }
    
    //添加删除事件
    @IBAction func addPhotoClick(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    @IBAction func removePhotoClick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }
    
}
