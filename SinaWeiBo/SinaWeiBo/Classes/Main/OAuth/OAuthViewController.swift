//
//  OAuthViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/25.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    //MARK: - 属性
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: - 系统函数
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置导航
        setupNavigationBar()
        //加载页面
        loadPage()
    }

}

//MARK: - UI
extension OAuthViewController {
    fileprivate func setupNavigationBar() {
        //左侧按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        //右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        //设置标题
        title = "登录页面"
    }
    
    fileprivate func loadPage() {
        //登录页面的url
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
}

//MARK: - 事件监听

extension OAuthViewController {
    @objc fileprivate func closeItemClick() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fillItemClick() {
        //注入js的代码
        let jsCode = "document.getElementById('userId').value='@163.com';document.getElementById('passwd').value='';"
        //注入js
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}
//MARK: - webView代理
extension OAuthViewController: UIWebViewDelegate {
    //开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    //网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    //网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //准备加载网页
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获取加载网页的URL
        guard let url = request.url else {
            return true
        }
        //获取url中的字符串
        let urlString = url.absoluteString
        //判断字符串中是否包含code
        guard urlString.contains("code") else {
            return true
        }
        //将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        //请求AccessToken
        loadAccessToken(code: code)
        return false
    }
}

//MARK: - 请求数据 
extension OAuthViewController {
    fileprivate func loadAccessToken(code: String) {
        SANNetworkManager.shareInstance.loadAccessToken(code: code) { (result, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let accountDict = result else {
                return
            }
            //将字典转成对象
            let account = UserAccount(dict: accountDict)
            //请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    fileprivate func loadUserInfo(account : UserAccount) {
        guard let accessToken = account.access_token else {
            return
        }
        
        guard let uid = account.uid else {
            return
        }
        
        SANNetworkManager.shareInstance.loadUserInfo(accessToken: accessToken, uid: uid) { (result, error) in
            
            if error != nil {
                return
            }
            //拿到用户信息
            guard let userInfoDict = result else {
                return
            }
            //取出昵称 头像
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            //将用户信息归档
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountManager.shareInstance.accountPath)
        }
    }
}

