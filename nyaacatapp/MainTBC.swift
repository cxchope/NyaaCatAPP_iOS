//
//  MainTBC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class MainTBC: UITabBarController, WKNavigationDelegate, LoginMenuVCDelegate {
    
    let 动态地图网址:String = "https://mcmap.90g.org"
    let 动态地图登录接口:String = "https://mcmap.90g.org/up/login"
    let 注册页面标题:String = "Minecraft Dynamic Map - Login/Register"
    let 地图页面标题:String = "Minecraft Dynamic Map"
    let 地图页面特征:String = "<!-- These 2 lines make us fullscreen on apple mobile products - remove if you don't like that -->"
    
    let 等待画面:WaitVC = WaitVC()
    let 登录菜单:LoginMenuVC = LoginMenuVC()
    var 提示框:UIAlertController? = nil
    var 网络模式:网络模式选项 = 网络模式选项.检查是否登录
    var 定时器:NSTimer? = nil
    var 新定时器:MSWeakTimer? = nil
//    var 新定时器
    var 解析引擎:DynmapAnalysisController = DynmapAnalysisController()
    
    enum 网络模式选项 {
        case 检查是否登录
        case 提交登录请求
        case 监视页面信息
    }
    
    //var 后台网页加载器:UIWebView = UIWebView(frame: CGRectMake(0,0,100,200))
    var 后台网页加载器:WKWebView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = 全局_导航栏颜色
        //navigationBar.layer.contents = (id)[UIImage imageWithColor:youColor].CGImage;
        tabBar.tintColor = UIColor.whiteColor()
        
        初始化WebView()
        
        //self.presentViewController(等待画面, animated: true, completion: nil)
        等待画面.view.frame = self.view.frame
        self.view.addSubview(等待画面.view) //release
//        self.view.insertSubview(等待画面.view, belowSubview: 后台网页加载器!) //debug
        检查登录网络请求(false)
        
        //WKWebView内存使用测试
//        for i in 0...100 {
//            let testweb:WKWebView = WKWebView(frame: CGRectMake(0, 0, 100, 100))
//            self.view.addSubview(testweb)
//            testweb.loadRequest(NSURLRequest(URL: NSURL(string: "http://163.com")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30))
//        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "收到重载通知", name: "reloadwebview", object: nil)
    }
    
    func 初始化WebView() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = "yashi_browser"
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        //浏览器偏好设置.minimumFontSize = 12.0
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = true
        //        let 用户脚本文本:String = "$('div img').remove();"
        //        let 用户脚本:WKUserScript = WKUserScript(source: 用户脚本文本, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
        //        浏览器设置.userContentController.addUserScript(用户脚本)
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        
        后台网页加载器 = WKWebView(frame: CGRect.zero, configuration: 浏览器设置)
        后台网页加载器?.userInteractionEnabled = false
        self.view.addSubview(后台网页加载器!)
        后台网页加载器!.navigationDelegate = self
        
        //        后台网页加载器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //        后台网页加载器!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    func 收到重载通知() {
        后台网页加载器!.reload()
    }
    
    func 检查登录网络请求(缓存:Bool) {
        let 要加载的网页URL:NSURL = NSURL(string: 动态地图网址)!
        var 网络请求:NSURLRequest? = nil
        if (缓存 == false) {
            网络请求 = NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        } else {
            网络请求 = NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30)
        }
        后台网页加载器!.loadRequest(网络请求!)
        等待画面.副标题.text = "连接到地图服务器中喵"
    }
    
    func 打开动态地图登录菜单() {
        等待画面.副标题.text = "请使用动态地图用户登录喵"
        登录菜单.代理 = self
        self.view.addSubview(登录菜单.view)
        登录菜单.进入动画(self.view.frame)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        请求页面源码()
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        等待画面.副标题.text = "网络连接失败喵"
        提示框 = UIAlertController(title: 等待画面.副标题.text, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                self.检查登录网络请求(false)
            }
        })
        提示框!.addAction(okAction)
        self.presentViewController(提示框!, animated: true, completion: nil)
    }
//    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
//        NSLog("didCommitNavigation")
//    }
//    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        NSLog("didStartProvisionalNavigation")
//    }
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if (keyPath != nil) {
//            if (keyPath == "estimatedProgress") {
//                print("网页加载进度：\(后台网页加载器?.estimatedProgress)")
//            } else if (keyPath == "title") {
//                print("网页标题：\(后台网页加载器?.estimatedProgress)")
//            }
//        }
//    }
    
    func 定时器触发() {
        请求页面源码()
    }
    
    func 处理返回源码(源码:[String]) {
        if (网络模式 == 网络模式选项.检查是否登录) {
            let 网页标题:String? = 源码[0]
            if (网页标题 != nil && 网页标题 == 注册页面标题) {
                打开动态地图登录菜单()
            }
        } else if (网络模式 == 网络模式选项.提交登录请求) {
            let 网页标题:String? = 源码[0]
            if (网页标题 == 地图页面标题) {
                let 网页内容:String? = 源码[1]
                if (网页内容?.rangeOfString(地图页面特征) != nil) {
                    等待画面.副标题.text = "登录成功~撒花~"
                    网络模式 = 网络模式选项.监视页面信息
                    新定时器 = MSWeakTimer.scheduledTimerWithTimeInterval(全局_刷新速度, target: self, selector: "定时器触发", userInfo: nil, repeats: true, dispatchQueue: dispatch_get_main_queue())
//                    定时器 = NSTimer.scheduledTimerWithTimeInterval(全局_刷新速度, target: self, selector: "定时器触发", userInfo: nil, repeats: true)
                    等待画面.停止 = true
                }
            } else if (网页标题 != nil) {
                检查登录网络请求(true)
            } else {
                全局_用户名 = nil
                全局_密码 = nil
                等待画面.副标题.text = "登录失败喵"
                提示框 = UIAlertController(title: 等待画面.副标题.text, message: "服务暂时不可用或用户名密码不匹配喵QAQ", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "重试喵", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
                    if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                        self.打开动态地图登录菜单()
                    }
                })
                提示框!.addAction(okAction)
                self.presentViewController(提示框!, animated: true, completion: nil)
            }
        } else if (网络模式 == 网络模式选项.监视页面信息) {
            解析引擎.html = 源码[1]
            解析引擎.start()
        }
    }
    
    func 请求页面源码() {
        let 获取网页标题JS:String = "document.title"
        let 获取网页源码JS:String = "document.documentElement.innerHTML"
        var 网页源码:[String] = Array<String>()
        后台网页加载器!.evaluateJavaScript(获取网页标题JS) { (对象:AnyObject?, 错误:NSError?) -> Void in
            if (对象 == nil) {
                return
            }
            网页源码.append(对象 as! String)
            self.后台网页加载器!.evaluateJavaScript(获取网页源码JS) { (对象:AnyObject?, 错误:NSError?) -> Void in
                网页源码.append(对象 as! String)
                self.处理返回源码(网页源码)
            }
        }
    }
    
    func 返回登录请求(用户名:String,密码:String) {
        等待画面.副标题.text = "正在登录喵..."
        登录菜单.代理 = nil
        登录菜单.退出动画()
        网络模式 = 网络模式选项.提交登录请求
        let 网络参数:String = "j_username=" + 用户名 + "&j_password=" + 密码
        let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
        let 要加载的网页URL:NSURL = NSURL(string: 包含参数的网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        网络请求.HTTPMethod = "POST"
        //网络请求.HTTPBody = 网络参数.dataUsingEncoding(NSUTF8StringEncoding)
        全局_用户名 = 用户名
        全局_密码 = 密码
        后台网页加载器!.loadRequest(网络请求)
    }
    
//    func 解析完成(综合信息输入:Dictionary<String,NSObject>?,信息数据量 信息数据量输入:Dictionary<String,Int>?) {
//        全局_综合信息 = 综合信息输入
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //后台网页加载器.reload()
    }
}
