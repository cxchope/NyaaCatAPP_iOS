//
//  TableVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/27.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var 链接:[[String]] = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 链接.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let 单元格ID:String = "ECell"
        let 行数:Int = indexPath.row
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格ID)
        if(单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: 单元格ID)
            单元格?.accessoryType = .DisclosureIndicator
//            单元格?.backgroundColor = UIColor.clearColor()
//            单元格?.detailTextLabel?.textColor = UIColor.lightGrayColor()
//            单元格?.textLabel?.textColor = UIColor.blackColor()
        }
        let 当前链接:[String] = 链接[行数]
        let 当前名称:String = 当前链接[0]
        单元格?.textLabel?.text = 当前名称.substringFromIndex(当前名称.startIndex.advancedBy(1))
        return 单元格!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let 行数:Int = indexPath.row
        let 当前链接:[String] = 链接[行数]
        let 当前名称:String = 当前链接[0]
        let 名称:String = 当前名称.substringFromIndex(当前名称.startIndex.advancedBy(1))
        let 网址:String = "\(全局_喵窩API["API域名"]!)\(当前链接[1])"
        let vc:BrowserVC = BrowserVC()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.装入网页(网址, 标题: 名称)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
