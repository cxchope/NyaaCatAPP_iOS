//
//  WaitVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class WaitVC: UIViewController {

    @IBOutlet weak var 图标: UIImageView!
    @IBOutlet weak var 副标题: UILabel!

    var 图标原始位置:CGRect? = nil
    var 图标缩小位置:CGRect? = nil
    var 停止:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 1
        图标原始位置 = 图标.frame
        图标缩小位置 = CGRectMake(图标原始位置!.origin.x, 图标原始位置!.origin.y + (图标原始位置!.size.height * 0.1), 图标原始位置!.size.width, 图标原始位置!.size.height * 0.9)
        图标动画(true)
    }
    
    func 图标动画(前半段:Bool) {
        if (停止 == false) {
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                if (前半段) {
                    self.图标.frame = self.图标缩小位置!
                } else {
                    self.图标.frame = self.图标原始位置!
                }
                }) { (已完成:Bool) -> Void in
                    self.图标动画(!前半段)
            }
        } else {
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                self.view.alpha = 0
                self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width,  self.view.frame.size.height)
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
