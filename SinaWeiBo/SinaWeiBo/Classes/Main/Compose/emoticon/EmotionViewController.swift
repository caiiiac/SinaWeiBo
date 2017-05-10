//
//  EmotionViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/8.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

fileprivate let emoticonCellIdentifier = "emoticonCell"
fileprivate let itemTag = 50

class EmotionViewController: UIViewController {

    //MARK: - 属性
    var emoticonCallBack : (_ emoticon : Emoticon) -> ()
    
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    //表情包
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
    }
    
    //MARK: - 自定义构造函数
    //UIViewController重写init(),必须用super.init(nibName: nil, bundle: nil)
    init(emoticonCallBack : @escaping (_ emoticon : Emoticon) -> ()) {
        
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        //准备toolBar
        prepareForToolBar()
    }
    
    //注册cell 设置数据源
    fileprivate func prepareForCollectionView() {
        collectionView.register(EmoticonCollectionViewCell.self, forCellWithReuseIdentifier: emoticonCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
      
    }
    
    fileprivate func prepareForToolBar() {
        //定义titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        //创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmotionViewController.itemClick(item:)))
            item.tag = itemTag + index
            index += 1
            item.tintColor = UIColor.orange
            
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        //将创建好的items赋值给toolBar
        toolBar.items = tempItems
        
    }
    
}

//MARK: - 事件
extension EmotionViewController {
    @objc fileprivate func itemClick(item : UIBarButtonItem) {
        //获取点击item的tag
        let tag = item.tag - itemTag
        //根据tag获取到当前组
        let indexPath = NSIndexPath(item: 0, section: tag) as IndexPath
        //滚动到相应位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    
    }
}


//MARK: - UICollectionViewDataSource
extension EmotionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonCellIdentifier, for: indexPath) as! EmoticonCollectionViewCell
        
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        cell.emoticon = emoticon
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        //将点击的表情插入最近分组中
        insertRecentlyEmoticon(emotion: emoticon)
 
        //回调表情点击事件
        emoticonCallBack(emoticon)
    }
    
    //将点击的表情插入最近分组
    fileprivate func insertRecentlyEmoticon(emotion : Emoticon) {
        //点击了空白 删除不做处理
        if emotion.isRemove || emotion.isEmpty {
            return
        }
        
        //如果之前点击过这个表情,将其移动到最前
        if manager.packages.first!.emoticons.contains(emotion) {
            let index = (manager.packages.first!.emoticons.index(of: emotion))!
            manager.packages.first!.emoticons.remove(at: index)
        }
        //最近分组没有刚点击的表情
        else
        {
            manager.packages.first!.emoticons.remove(at: 19)
        }
        
        //插入将点击的表情
        manager.packages.first!.emoticons.insert(emotion, at: 0)
        collectionView.reloadSections([0])
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
