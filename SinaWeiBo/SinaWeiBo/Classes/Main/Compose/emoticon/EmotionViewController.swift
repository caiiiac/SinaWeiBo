//
//  EmotionViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/8.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

fileprivate let emoticonCellIdentifier = "emoticonCell"

class EmotionViewController: UIViewController {

    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }

}

//MARK: - 设置UI
extension EmotionViewController {
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        //约束 (手写约束必须为false)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["toolBar" : toolBar, "collectionView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        //准备collectionView
        prepareForCollectionView()
    }
    
    //注册cell 设置数据源
    fileprivate func prepareForCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: emoticonCellIdentifier)
        collectionView.dataSource = self
        
        //设置布局
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
    }
    
}

extension EmotionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCellIdentifier, for: indexPath)
        
        cell.backgroundColor = indexPath.item%2==0 ? UIColor.red : UIColor.blue
        return cell
        
    }
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        
        super.prepare()
        //计算WH
        let itemWH = UIScreen.main.bounds.width / 7
        //设置layout属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        //设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0)
        
    }
}
