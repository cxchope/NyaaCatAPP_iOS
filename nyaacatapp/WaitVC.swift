//
//  WaitVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

protocol WaitVCDelegate {
    func 返回登录请求(_ 用户名:String?,密码:String?)
    func 弹出代理提示框(_ 提示框:UIAlertController)
    func 重试按钮点击()
}

class WaitVC: UIViewController {

    @IBOutlet weak var 图标: UIImageView!
    @IBOutlet weak var 副标题: UILabel!
    @IBOutlet weak var 网点: UIView!
    @IBOutlet weak var 登录按钮: UIButton!

    var 图标原始位置:CGRect? = nil
    var 图标缩小位置:CGRect? = nil
    var 停止:Bool = false
    var 代理:WaitVCDelegate? = nil
    var 提示框:UIAlertController? = nil
    var 用户名:String = 全局_喵窩API["测试动态地图用户名"]!
    var 密码:String = 全局_喵窩API["测试动态地图密码"]!
    var 重试:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1
        登录按钮.isHidden = true
        网点.backgroundColor = UIColor(patternImage: UIImage(contentsOfFile: Bundle.main.path(forResource: "dot", ofType: "png")!)!)
        登录按钮.backgroundColor = UIColor(red: 0.5372549, green: 0.6745098, blue: 0.84705882, alpha: 0.8)
        图标原始位置 = 图标.frame
        图标缩小位置 = CGRect(x: 图标原始位置!.origin.x, y: 图标原始位置!.origin.y + (图标原始位置!.size.height * 0.1), width: 图标原始位置!.size.width, height: 图标原始位置!.size.height * 0.9)
        //图标动画(true)
    }
    
    @IBAction func 登录按钮点击(_ sender: UIButton) {
        登录按钮.isHidden = true
        if (重试 == true) {
            重试按钮模式(false)
            代理!.重试按钮点击()
        } else {
            提示框 = UIAlertController(title: "请输入用户名和密码", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(false)
            })
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(true)
            })
            提示框!.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "用户名"
                textField.text = self.用户名
            }
            提示框!.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "密码"
                textField.isSecureTextEntry = true
                textField.text = self.密码
            }
            提示框!.addAction(okAction)
            提示框!.addAction(cancelAction)
            代理!.弹出代理提示框(提示框!)
        }
    }
    
    func 重试按钮模式(_ 重试模式:Bool) {
        if (重试模式 == true) {
            登录按钮.setTitle("重试", for: UIControlState())
        } else {
            登录按钮.setTitle("登录", for: UIControlState())
        }
        重试 = 重试模式
    }
    
    @IBAction func 顶部按钮一点击(_ sender: UIButton) {
        
    }
    
    @IBAction func 顶部按钮二点击(_ sender: UIButton) {
        
    }
    
    @IBAction func 顶部按钮三点击(_ sender: UIButton) {
        登录按钮.isHidden = true
        self.代理!.返回登录请求(nil, 密码: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "guest"), object: nil)
    }
    
    func 退出() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: 0.5, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }, completion: { (aniok:Bool) in
                self.view.removeFromSuperview()
        })
    }
    
    
    func 提示框处理(_ 确定:Bool) {
        if (确定 == true) {
            let 用户名输入框:UITextField = 提示框!.textFields!.first! as UITextField
            let 密码输入框:UITextField = 提示框!.textFields!.last! as UITextField
            用户名 = 用户名输入框.text!
            密码 = 密码输入框.text!
            self.代理!.返回登录请求(用户名, 密码: 密码)
        } else {
            登录按钮.isHidden = false
        }
        提示框 = nil
    }
    
    func 图标动画(_ 前半段:Bool) {
        if (停止 == false) {
            UIView.animate(withDuration: 3.0, animations: { () -> Void in
                if (前半段) {
                    self.图标.frame = self.图标缩小位置!
                } else {
                    self.图标.frame = self.图标原始位置!
                }
                }) { (已完成:Bool) -> Void in
                    self.图标动画(!前半段)
            }
        } else {
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                self.view.alpha = 0
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + self.view.frame.size.height, width: self.view.frame.size.width,  height: self.view.frame.size.height)
                }) { (已完成:Bool) -> Void in
                    self.view.removeFromSuperview()
            }
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
