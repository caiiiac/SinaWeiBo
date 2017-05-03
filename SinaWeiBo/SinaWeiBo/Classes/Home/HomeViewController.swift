//
//  HomeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {

    //MARK: - 属性
    fileprivate lazy var titleBtn : SANTitleButton = SANTitleButton()
    //注意:在闭包中如果使用当前对象的属性或者调用方法,需要加self
    //两个地方需要使用self: 1>.函数中出现歧义 2>.闭包中使用当前对象的属性和方法
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (isPresented) in
        self!.titleBtn.isSelected = isPresented
    }
    
    fileprivate lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //没有登录时
        if !isLogin {
            visitorView.addRotationAnim()
            return
        }
        //设置导航
        setupNavigationBar()
        //请求数据
        loadStatuses()
        
        //设置cell自动适配高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }

}

//MARK: - 设置UI
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        
        //左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
    
        //titleView
        titleBtn.setTitle("红茶绅士", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

//MARK: - 事件监听
extension HomeViewController{

    @objc fileprivate func titleBtnClick() {
        //改变按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        //创建弹出控制器
        let popoverVC = PopoverViewController()
        //设置控制器modal样式
        popoverVC.modalPresentationStyle = .custom
        //设置转场代理
        popoverVC.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: (view.frame.width - 180) * 0.5, y: 55, width: 180, height: 250)
        
        //弹出控制器
        present(popoverVC, animated: true, completion: nil)
        
    }
}

//MARK: - 数据请求
extension HomeViewController {
    fileprivate func loadStatuses() {
        SANNetworkManager.shareInstance.loadStatuses { (result, error) in
            if error != nil {
                return
            }
            //获取数据
            guard let resultArray = result else {
                return
            }
            //添加数据到Array
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
                dprint("来源:\(viewModel.sourceText!)----时间:\(viewModel.createAtText!)----博主:\((viewModel.status?.user?.screen_name)!)")
            }
            
            //刷新tableView
//            self.tableView.reloadData()
            self.cacheImages(viewModels: self.viewModels)
        }
    }
    
    fileprivate func cacheImages(viewModels : [StatusViewModel]) {
        //创建group
        let group = DispatchGroup()
        //缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                    group.leave()
                })
            }
        }
        //刷新表格
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
}

//MARK: - tableView代理
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeStatusCell") as! HomeViewCell
        
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
}

