//
//  AppDelegate.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/11.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var 主视图:MainTBC? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        应用初始化()
        let 屏幕尺寸:CGRect = UIScreen.mainScreen().bounds
        let 主窗口:UIWindow = UIWindow(frame: 屏幕尺寸)
        let 主故事板:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        主视图 = 主故事板.instantiateViewControllerWithIdentifier("MainTBC") as? MainTBC
        主视图!.delegate = self
        主窗口.rootViewController = 主视图
        self.window = 主窗口
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (全局_用户名 == nil) {
            if ((viewController as? StatusNC) != nil || (viewController as? DMChatNC) != nil || (viewController as? MapNC) != nil) {
                主视图?.游客模式阻止(viewController.title)
                return false
            }
        }
        return true
    }
    
    func 应用初始化() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        APILoader().loadPrivateConstant()
        
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        NSLog("URL scheme:%@", url.scheme);
        //NSLog("URL query: %@", url.query!);
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

func 全局_调整计时器延迟(电池供电时:NSTimeInterval,外接电源时:NSTimeInterval) {
    if (全局_设备信息.batteryState == .Charging || 全局_设备信息.batteryState == .Full){
        全局_刷新延迟 = 外接电源时
    } else {
        全局_刷新延迟 = 电池供电时
    }
    NSNotificationCenter.defaultCenter().postNotificationName("timerset", object: nil)
}

//全局
let 全局_导航栏颜色:UIColor = UIColor(red: 1, green: 153/255.0, blue: 203/255.0, alpha: 1)
var 全局_刷新延迟:NSTimeInterval = 2.5 //1.0快速，2.5标准, 6.0节能，0.2模拟器压力测试，0.5真机压力测试
var 全局_综合信息:Dictionary<String,NSObject>? = nil
var 全局_用户名:String? = nil
var 全局_密码:String? = nil
var 全局_游客模式:Bool = false
let 全局_手机发送消息关键字:String = "[NyaaCatAPP] "
let 全局_设备信息:UIDevice = UIDevice.currentDevice()
var 全局_喵窩API:Dictionary<String,String> = Dictionary<String,String>()
let 全局_浏览器标识 = "Mozilla/5.0 (kagurazaka-browser)"