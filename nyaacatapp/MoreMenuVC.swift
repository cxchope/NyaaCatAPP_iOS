//
//  MoreMenuVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/12.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import SafariServices

class MoreMenuVC: UIViewController, MoreMenuCellViewDelegate {
    
    var TAG组:Int = 0
    let 按钮文本和对应图片:[[String]] = [["喵窩通知","rss-icon"],["喵窩维基","notebook-icon"],["游戏录像","video-icon"],["游戏直播","tv-icon"],["☍官方网站","lcd-icon"],["☍G+社群","GooglePlus-logos-02"],["☍开源项目","calculator-icon"],["封禁查询","mike-icon"],["关于反馈","msg-icon"]]
    var 表格数据:Dictionary<String,[[String]]>? = nil
    var 正在进入Tag:Int = -1
    var 等待提示:UIAlertController? = nil
    var 收到html:String = ""
    var 延迟计时器:MSWeakTimer? = nil
    var 右上按钮:UIBarButtonItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.自动点击按钮), name: "MoreMenuVCButton", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.下载表格数据), name: "MoreMenuVCReload", object: nil)
        右上按钮 = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(self.右上按钮点击))
        navigationItem.rightBarButtonItem = 右上按钮
    }
    
    func 自动点击按钮() {
        let MinoriWiki解析:MinoriWikiAnalysis = MinoriWikiAnalysis()
        MinoriWiki解析.html = 收到html
        收到html = ""
        self.表格数据 = MinoriWiki解析.获取主菜单()
        if (正在进入Tag >= 0) {
            延迟计时器 = MSWeakTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.延迟进入功能), userInfo: nil, repeats: false, dispatchQueue: dispatch_get_main_queue())
        }
    }
    func 延迟进入功能() {
        self.点击图标(self.正在进入Tag)
        延迟计时器?.invalidate()
        延迟计时器 = nil
    }
    func 右上按钮点击() {
        正在进入Tag = -1
        下载表格数据()
    }
    
    override func viewWillAppear(animated: Bool) {
        加载UI(nil)
    }
    override func viewWillDisappear(animated: Bool) {
        卸载UI()
    }
    
    func 加载UI(新尺寸:CGSize?) {
        if (TAG组 == 0) {
            //NSLog("加载UI")
            var 输入尺寸:CGSize? = 新尺寸
            if (输入尺寸 == nil) {
                输入尺寸 = view.frame.size
            }
            let 上栏高度 = navigationController!.navigationBar.frame.size.height + 20
            let 下栏高度 = tabBarController!.tabBar.frame.size.height
            let 底栏:UIView = UIView(frame: CGRectMake(0, 上栏高度, 输入尺寸!.width, 输入尺寸!.height-上栏高度-下栏高度))
            底栏.alpha = 0
            let 按钮尺寸:CGSize =  CGSizeMake(底栏.frame.size.width/3, 底栏.frame.size.height/3)
            let 每行列数:CGFloat = 2
            var 列:CGFloat = 0
            var 行:CGFloat = 0
            for 序号:Int in 0...按钮文本和对应图片.count-1 {
                let 当前按钮位置:CGRect = CGRectMake(按钮尺寸.width*列, 按钮尺寸.height*行, 按钮尺寸.width, 按钮尺寸.height)
                let 当前按钮显示:[String] = 按钮文本和对应图片[序号]
                let 当前按钮:MoreMenuCellView = MoreMenuCellView(frame: 当前按钮位置)
                当前按钮.设置内容(当前按钮显示[0], 图片文件名: 当前按钮显示[1])
                TAG组 += 1
                当前按钮.tag = TAG组
                当前按钮.代理 = self
                底栏.addSubview(当前按钮)
                列++
                if (列 > 每行列数) {
                    列 = 0
                    行++
                }
            }
            底栏.tag = 0
            view.addSubview(底栏)
            UIView.animateWithDuration(0.5) { () -> Void in
                底栏.alpha = 1
            }
        }
    }
    
    func 卸载UI() {
        if (TAG组 > 0) {
            //NSLog("卸载UI")
            self.view.viewWithTag(0)?.removeFromSuperview()
            for nowTag:Int in 1...TAG组 {
                let nowView:UIView? = self.view.viewWithTag(nowTag)
                if (nowView != nil) {
                    let now:MoreMenuCellView = nowView as! MoreMenuCellView
                    now.卸载()
                } else {
                    NSLog("release err")
                }
            }
            TAG组 = 0
        }
    }
    
    func 点击图标(按钮tag:Int) {
        正在进入Tag = 按钮tag
        let 当前选择:[String] = 按钮文本和对应图片[按钮tag-1]
        switch (按钮tag) {
        case 1:
            进入表格(按钮tag, 名称: 当前选择[0], 类型名: "通知")
            break;
        case 2:
            //进入表格(按钮tag, 名称: 当前选择[0], 类型名: "维基")
            break;
        case 3:
            进入表格(按钮tag, 名称: 当前选择[0], 类型名: "录像")
            break;
        case 4:
            let vc:BrowserVC = BrowserVC()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.装入网页(全局_喵窩API["游戏直播"]!, 标题: 当前选择[0])
            break;
        case 5:
            let ob:OpenBrowser = OpenBrowser()
            ob.打开浏览器("https://nyaa.cat/")
            break;
        case 6:
            let ob:OpenBrowser = OpenBrowser()
            ob.打开浏览器("https://plus.google.com/communities/106016758621697881816", 浏览器尝试顺序: [Browser.Google＋, Browser.Chrome, Browser.Firefox, Browser.Safari])
            break;
        case 7:
            let ob:OpenBrowser = OpenBrowser()
            ob.打开浏览器("https://github.com/NyaaCat")
            break;
        case 8:
            进入表格(按钮tag, 名称: 当前选择[0], 类型名: "处罚")
            break;
        case 9:
            let vc:BrowserVC = BrowserVC()
            self.navigationController?.pushViewController(vc, animated: true)
            vc.装入网页(全局_喵窩API["关于和许可"]!, 标题: 当前选择[0])
            break;
        default:
            break;
        }
    }
    
    func 进入表格(tag:Int, 名称:String, 类型名:String) {
        if (表格数据 == nil) {
            下载表格数据()
        } else {
            let vc:TableVC = TableVC()
            vc.title = 名称
            vc.链接 = 表格数据![类型名]!
            self.navigationController?.pushViewController(vc, animated: true)
            vc.tableView.reloadData()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        卸载UI()
        加载UI(size)
    }
    
    func 下载表格数据() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if (等待提示 == nil) {
            等待提示 = UIAlertController(title: "⌛️正在下载数据", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.等待提示 = nil
            })
            等待提示!.addAction(取消按钮)
            self.presentViewController(等待提示!, animated: true, completion: nil)
        }
        let AF任务管理:AFHTTPSessionManager = AFHTTPSessionManager()
        //AF任务管理.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        AF任务管理.responseSerializer = AFHTTPResponseSerializer()
        AF任务管理.GET(全局_喵窩API["API路径"]!, parameters: nil, progress: { (downloadProgress:NSProgress) in
            //请求中
            self.等待提示?.message = "\(downloadProgress.totalUnitCount)"
            }, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) in
                //请求成功
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.关闭加载提示()
                let 返回数据:NSData = responseObject as! NSData
                self.收到html = String(data: 返回数据, encoding: NSUTF8StringEncoding)!
                NSNotificationCenter.defaultCenter().postNotificationName("MoreMenuVCButton", object: nil)
                
        }) { (task:NSURLSessionDataTask?, error:NSError) in
            //请求失败
//            self.关闭加载提示()
//            let 提示:UIAlertController = UIAlertController(title: "信息载入失败", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//            let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            })
//            提示.addAction(取消按钮)
//            self.presentViewController(提示, animated: true, completion: nil)
            self.等待提示?.title = "信息载入失败"
            self.等待提示?.message = error.localizedDescription
        }
    }
    
    func 关闭加载提示() {
        if (等待提示 != nil) {
            等待提示?.dismissViewControllerAnimated(false, completion: nil)
            等待提示 = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
