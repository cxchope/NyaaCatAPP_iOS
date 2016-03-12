//
//  MoreMenuCellView.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/12.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

protocol MoreMenuCellViewDelegate {
    func 点击图标(按钮tag:Int)
}

class MoreMenuCellView: UIView {
    
    let 图片:UIImageView = UIImageView()
    let 文本:UILabel = UILabel()
    let 按钮:UIButton = UIButton(type: UIButtonType.Custom)
    var 代理:MoreMenuCellViewDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        let 文本高度:CGFloat = 20
        let 间隔:CGFloat = 10
        文本.frame = CGRectMake(0, frame.size.height - 文本高度, frame.size.width, 文本高度)
        文本.textAlignment = .Center
        图片.frame = CGRectMake(间隔, 0, frame.size.width - 间隔 - 间隔, frame.size.height - 文本高度)
        图片.contentMode = .ScaleAspectFit
        按钮.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        按钮.addTarget(self, action: "按下按钮", forControlEvents: UIControlEvents.TouchDown)
        按钮.addTarget(self, action: "点击按钮", forControlEvents: UIControlEvents.TouchUpInside)
        按钮.addTarget(self, action: "松开按钮", forControlEvents: UIControlEvents.TouchDragExit)
        self.addSubview(文本)
        self.addSubview(图片)
        self.addSubview(按钮)
    }
    
    func 按下按钮() {
        self.layer.shadowColor = 全局_导航栏颜色.CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
    }
    func 点击按钮() {
        按钮释放()
        代理?.点击图标(self.tag)
    }
    func 松开按钮() {
        按钮释放()
    }
    func 按钮释放() {
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowColor = nil
    }
    
    func 设置内容(改文本:String, 图片文件名:String) {
        文本.text = 改文本
        图片.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(图片文件名, ofType: "png")!)!
    }
    
    func 卸载() {
        self.代理 = nil
        文本.removeFromSuperview()
        图片.removeFromSuperview()
        按钮.removeFromSuperview()
        self.removeFromSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
