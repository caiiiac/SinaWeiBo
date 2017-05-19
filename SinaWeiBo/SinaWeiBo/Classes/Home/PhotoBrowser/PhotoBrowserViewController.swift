//
//  PhotoBrowserViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let PBCellIdentifier = "PhotoBrowserCell"

class PhotoBrowserViewController: UIViewController {
    
    //MARK: - 属性
    var indexPath : NSIndexPath
    var picURLs : [URL]
    
    
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    
    //MARK: - 自定义构造函数
    init(indexPath : NSIndexPath, picURLs : [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        //设置UI
        setupUI()
        
        //滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 15
    }
}

//MARK: - 设置UI
extension PhotoBrowserViewController {
    fileprivate func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        //设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-35)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        
        //设置collectionView
        collectionView.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PBCellIdentifier)
        collectionView.dataSource = self
        
        //监听按钮点击
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
    }
}

//MARK: - 事件监听
extension PhotoBrowserViewController {
    //关闭按钮
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveBtnClick() {
        
        //获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserCollectionViewCell
        guard let image = cell.imageView.image else {
            return
        }
        
        //将image保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : Error?, contextInfo : Any) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
        
    }
}

//MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PBCellIdentifier, for: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        cell.delegate = self
        
        return cell
    }
}

//MARK: - PhotoBrowserViewCellDelegate
extension PhotoBrowserViewController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        //设置itemSize
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        //设置属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
