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
    
    var image : UIImage? {
        didSet {
            if image != nil {
                addPhotoBtn.setBackgroundImage(image, for: .normal)
                addPhotoBtn.isUserInteractionEnabled = false
                
            }
            else
            {
                addPhotoBtn.setBackgroundImage(UIImage(named : "compose_pic_add"), for: .normal)
                addPhotoBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func addPhotoClick(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    
}
