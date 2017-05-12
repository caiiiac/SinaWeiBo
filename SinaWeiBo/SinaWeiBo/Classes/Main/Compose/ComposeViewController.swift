//
//  ComposeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeTextView: ComposeTextView!
    //工具栏约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    //图片选择高度约束
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    
    //选择图片数组
    fileprivate var images : [UIImage] = [UIImage]()
    //自定义titleView
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    //选中的图片
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    //表情键盘
    fileprivate lazy var emoticonVc : EmotionViewController = EmotionViewController {[weak self] (emotion) in
        self?.composeTextView.insertEmoticon(emoticon: emotion)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置导航
        setupNavigationBar()
        //添加通知
        setupNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        composeTextView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}
//MARK: - UI
extension ComposeViewController {
    //设置导航
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        navigationItem.titleView = titleView
    }
    
    fileprivate func setupNotifications() {
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
        //添加图片通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //删除图片通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.removePhotoClick(noti:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
        
    }
    
}

//MARK: - 事件监听
extension ComposeViewController {
    
//关闭按钮
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    //发布按钮
    @objc fileprivate func sendItemClick() {
        
        //退出键盘
        composeTextView.resignFirstResponder()
        
        //获取发送微博的文字
        let statusText = composeTextView.getEmoticonString()
        
        //调用接口发送微博
        SANNetworkManager.shareInstance.sendStatus(statusText: statusText) { (isSucceed) in
            if !isSucceed {
                SVProgressHUD.showError(withStatus: "发布失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布成功")
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    //选择图片
    @IBAction func picPickerBtnClick(_ sender: Any) {
        //收回键盘
        composeTextView.resignFirstResponder()
        
        //显示图片选择
        picPicerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    //表情
    @IBAction func emoticonBtnClick(_ sender: Any) {
        //退出键盘
        composeTextView.resignFirstResponder()
        //切换键盘
        composeTextView.inputView = composeTextView.inputView != nil ? nil : emoticonVc.view
        //弹出键盘
        composeTextView.becomeFirstResponder()
    }
    
    //键盘通知事件
    @objc fileprivate func keyboardWillChangeFrame(note : NSNotification) {
        //获取动画执行时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
     
        //获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        //计算工具栏到底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        //动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
        
    }
}

//MARK: - 添加删除图片事件
extension ComposeViewController {
    @objc fileprivate func addPhotoClick () {
        //判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        //创建图片选择控制器
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        present(ipc, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func removePhotoClick(noti : NSNotification) {
        
        //获取image对象
        guard let image = noti.object as? UIImage else {
            return
        }
        
        guard let index = images.index(of: image) else {
            return
        }
        //删除图片
        images.remove(at: index)
        //选择图片重新赋值
        picPickerCollectionView.images = images
        
    }
}

extension ComposeViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选中照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        images.append(image)
        picPickerCollectionView.images = images
        print(images)
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextViewDelegate
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.composeTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        composeTextView.resignFirstResponder()
    }
}
