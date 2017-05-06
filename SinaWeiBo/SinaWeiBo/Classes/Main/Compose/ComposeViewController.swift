//
//  ComposeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/5/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeTextView: ComposeTextView!
    //工具栏约束
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    //图片选择高度约束
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置导航
        setupNavigationBar()
        
        //监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)

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
}

//MARK: - 事件监听
extension ComposeViewController {
    //关闭按钮
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    //发布按钮
    @objc fileprivate func sendItemClick() {
        
    }
    
    @IBAction func picPickerBtnClick(_ sender: Any) {
        //收回键盘
        composeTextView.resignFirstResponder()
        
        //显示图片选择
        picPicerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
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
