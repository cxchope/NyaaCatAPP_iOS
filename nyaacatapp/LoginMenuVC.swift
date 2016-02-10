//
//  LoginMenuVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class LoginMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var 选项表格: UITableView!
    var 行标题 = ["用户名：","密码：","记住用户名和密码","登录","","我还没注册过动态地图","我还没有入服"]
    var 提示框:UIAlertController? = nil
    var 用户名:String = ""
    var 密码:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        选项表格.backgroundColor = UIColor.clearColor()
        选项表格.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        选项表格.separatorColor = UIColor.clearColor()
        选项表格.delegate = self
        选项表格.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 行标题.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let 单元格ID:String = "Cell"
        let 行数:Int = indexPath.row
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格ID)
        if(单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: 单元格ID)
            单元格?.backgroundColor = UIColor.clearColor()
            
            单元格?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        if(行数 == 3) {
            单元格?.textLabel?.textColor = UIColor.redColor()
            单元格?.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)
            单元格?.textLabel?.frame = 单元格!.frame
            
            单元格?.textLabel?.textAlignment = NSTextAlignment.Center;
        } else {
            单元格?.textLabel?.textColor = UIColor.whiteColor()
            单元格?.textLabel?.textAlignment = NSTextAlignment.Left;
        }
        if (行数 == 0) {
            单元格?.textLabel?.text = 行标题[行数] + 用户名
        } else if (行数 == 1) {
            var 隐藏密码:String = ""
            for (var i = 0; i < 密码.lengthOfBytesUsingEncoding(NSUTF8StringEncoding); i++) {
                隐藏密码 += "*"
            }
            单元格?.textLabel?.text = 行标题[行数] + 隐藏密码
        } else {
            单元格?.textLabel?.text = 行标题[行数]
        }
        //单元格?.detailTextLabel?.text = "1234567890"
        return 单元格!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let 行数:Int = indexPath.row
        if (行数 < 2) {
//            提示框 = UIAlertView(title: "请输入用户名和密码", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
//            提示框?.alertViewStyle = UIAlertViewStyle.LoginAndPasswordInput
//            let 用户名输入框:UITextField = (提示框?.textFieldAtIndex(0))!
//            let 密码输入框:UITextField = (提示框?.textFieldAtIndex(1))!
//            用户名输入框.text = 用户名
//            密码输入框.text = 密码
//            提示框?.show()
            提示框 = UIAlertController(title: "请输入用户名和密码", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(false)
            })
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(true)
            })
            提示框!.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.placeholder = "用户名"
                textField.text = self.用户名
            }
            提示框!.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.placeholder = "密码"
                textField.secureTextEntry = true
                textField.text = self.密码
            }
            提示框!.addAction(cancelAction)
            提示框!.addAction(okAction)
            
            self.presentViewController(提示框!, animated: true, completion: nil)
        } else if (行数 == 3) {
            /*
            NSURL *url = [NSURL URLWithString: @"http://"];
            NSString *body = [NSString stringWithFormat: @"arg1=%@&arg2=%@", @"val1",@"val2"]; NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
            [request setHTTPMethod: @"POST"];
            [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
            [webView loadRequest: request];
*/
        }
    }
    
    func 提示框处理(确定:Bool) {
        if (确定 == true) {
            let 用户名输入框 = 提示框!.textFields!.first! as UITextField
            let 密码输入框 = 提示框!.textFields!.last! as UITextField
            用户名 = 用户名输入框.text!
            密码 = 密码输入框.text!
            选项表格.reloadData()
            
        }
        
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
