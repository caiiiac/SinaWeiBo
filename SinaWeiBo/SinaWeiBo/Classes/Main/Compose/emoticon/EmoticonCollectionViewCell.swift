//
//  EmoticonCollectionViewCell.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/9.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class EmoticonCollectionViewCell: UICollectionViewCell {
    
    
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    
    var emoticon : Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            
            guard !emoticon.isEmpty else {
                emoticonBtn.setImage(nil, for: .normal)
                emoticonBtn.setTitle("", for: .normal)
                return
            }
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - UI
extension EmoticonCollectionViewCell {
    fileprivate func setupUI() {
        contentView.addSubview(emoticonBtn)
        
        emoticonBtn.frame = contentView.bounds
        //关闭Btn的交互,用cell的didSelected
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
