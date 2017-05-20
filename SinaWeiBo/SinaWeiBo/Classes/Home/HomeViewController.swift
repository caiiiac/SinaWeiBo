//
//  HomeViewController.swift
//  SinaWeiBo
//
//  Created by 唐三彩 on 2017/4/15.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {

    //MARK: - 属性
    fileprivate lazy var titleBtn : SANTitleButton = SANTitleButton()
    //注意:在闭包中如果使用当前对象的属性或者调用方法,需要加self
    //两个地方需要使用self: 1>.函数中出现歧义 2>.闭包中使用当前对象的属性和方法
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (isPresented) in
        self!.titleBtn.isSelected = isPresented
    }
    //显示更新条数
    fileprivate lazy var tipLabel : UILabel = UILabel()
    fileprivate lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    //自定义动画
    fileprivate lazy var photoBrowserAnimator : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
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
//        loadStatuses()
        
        //设置上拉下拉
        setupHeaderView()
        setupFooterView()
        
        setupTipLabel()
        //设置cell自动适配高度
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        setupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: - 设置UI
extension HomeViewController {
    //导航
    fileprivate func setupNavigationBar() {
        
        //左右item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
    
        //titleView
        let title = UserAccountManager.shareInstance.account?.screen_name != nil ? UserAccountManager.shareInstance.account?.screen_name : "首页"
        
        titleBtn.setTitle(title, for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    //下拉控件
    fileprivate func setupHeaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatus))
//        header?.setTitle("下拉刷新", for: .idle)
//        header?.setTitle("释放更新", for: .pulling)
//        header?.setTitle("加载中...", for: .refreshing)
        
        //设置header
        tableView.mj_header = header
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    //上拉控件
    fileprivate func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatus))
    }
    
    //提示Label
    fileprivate func setupTipLabel () {
        
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        tipLabel.frame = CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: 0)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.systemFont(ofSize: 14)
//        tipLabel.isHidden = true
    }
    
    //监听通知
    fileprivate func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
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
    
    //图片浏览器通知事件
    @objc fileprivate func showPhotoBrowser(note : Notification) {
        //获取数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = note.userInfo![ShowPhotoBrowserUrlsKey] as! [URL]
        let object = note.object as! PicCollectionView
        
        //创建图片浏览器
        let photoBrowserVc = PhotoBrowserViewController(indexPath: indexPath, picURLs: picURLs)
        //设置modal类型
        photoBrowserVc.modalPresentationStyle = .custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        //设置动画代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        photoBrowserAnimator.indexPath = indexPath
        
        
        present(photoBrowserVc, animated: true, completion: nil)
        
    }
}

//MARK: - 数据请求
extension HomeViewController {
    //加载最新数据
    @objc fileprivate func loadNewStatus() {
        loadStatuses(isNewData: true)
    }
    //加载更多数据
    @objc fileprivate func loadMoreStatus() {
        loadStatuses(isNewData: false)
    }
    
    //加载微博数据
    fileprivate func loadStatuses(isNewData : Bool) {
        
        //获取since_id
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }
        else
        {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        //请求数据
        SANNetworkManager.shareInstance.loadStatuses(since_id: since_id, max_id : max_id) { (result, error) in
            if error != nil {
                return
            }
            //获取数据
            guard let resultArray = result else {
                return
            }
            
            //添加数据到Array
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)

            }
            
            self.viewModels = isNewData ?  (tempViewModel + self.viewModels) : (self.viewModels + tempViewModel)
            
            //刷新tableView
//            self.tableView.reloadData()
            self.cacheImages(viewModels: tempViewModel)
        }
    }
    //缓存图片
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
           
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(count: viewModels.count)
        }
    }
    //显示TipLabe
    fileprivate func showTipLabel(count : Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条新微博"
        
        UIView.animate(withDuration: 0.6, animations: {
            self.tipLabel.frame.size.height = 32
        }) { (_) in
            UIView.animate(withDuration: 0.6, delay: 1.0, options: [], animations: {
                self.tipLabel.frame.size.height = 0
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
    
}

