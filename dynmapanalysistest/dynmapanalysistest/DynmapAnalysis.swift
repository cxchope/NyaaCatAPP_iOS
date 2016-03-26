//
//  DynmapAnalysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/11.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Cocoa

class DynmapAnalysis: NSObject {
    
    
    var html:String? = nil
    var 解析:Analysis = Analysis()
    let 页面特征:String = "<div id=\"mcmap\" class=\"dynmap\">"
    
    //    override init() {
    //        NSLog("构造：DynmapAnalysis")
    //    }
    //
    //    deinit {
    //        NSLog("析构：DynmapAnalysis")
    //    }
    
    func 有效性校验() -> Bool {
        if (html?.rangeOfString(页面特征) != nil) {
            return true
        }
        return false
    }
    
    func 取得世界列表() -> [String] {
        var 世界名称:[String] = Array<String>()
        let 起始点到结束点字符串:String = 解析.抽取区间(html!, 起始字符串: "<ul class=\"worldlist\"", 结束字符串: "</a></li></ul></li></ul>", 包含起始字符串: true, 包含结束字符串: false)
        let classworld分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"world\">")
        if (classworld分割.count < 2) {
            return 世界名称
        }
        for classworld分割循环 in 1...classworld分割.count-1 {
            autoreleasepool {
                var 当前classworld分割:String = classworld分割[classworld分割循环]
                let 当前地图名称结束位置:Range = 当前classworld分割.rangeOfString("<")!
                当前classworld分割 = 当前classworld分割.substringToIndex(当前地图名称结束位置.startIndex)
                世界名称.append(当前classworld分割)
            }
        }
        //        NSLog("取得世界名称：\(世界名称)")
        return 世界名称
    }
    
    func 取得时间和天气() -> [String] {
        let 起始点到结束点字符串:String = 解析.抽取区间(html!, 起始字符串: "<div class=\"timeofday digitalclock", 结束字符串: "</div></div></div>", 包含起始字符串: false, 包含结束字符串: false)
        let 时间字符串:String = 解析.抽取区间(起始点到结束点字符串, 起始字符串: "\">", 结束字符串: "</div>", 包含起始字符串: false, 包含结束字符串: false)
        let 天气字符串:String = 解析.抽取区间(起始点到结束点字符串, 起始字符串: "weather ", 结束字符串: "\">", 包含起始字符串: false, 包含结束字符串: false)
        let 天气分割:[String] = 天气字符串.componentsSeparatedByString("_")
        var 天气:String = ""
        var 时段:String = ""
        if (天气分割.count == 2) {
            天气 = 天气分割[0]
            时段 = 天气分割[1]
        } else {
            天气 = 天气字符串
        }
        //        NSLog("时间：\(时间字符串)，时段：\(时段)，天气：\(天气)")
        //let 时段中文数据:Dictionary<String,String> = ["day":"白天","night":"夜晚"]
        //let 天气中文数据:Dictionary<String,String> = ["stormy":"雨","sunny":"晴","thunder":"雷"]
        return [时间字符串,时段,天气]
    }
    
    func 取得在线玩家() -> [[String]] {
        let 起始点到结束点字符串:String = 解析.抽取区间(html!, 起始字符串: "<ul class=\"playerlist\"", 结束字符串: "</ul><div class=\"scrolldown\"", 包含起始字符串: true, 包含结束字符串: true)
        let li分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"player")
        var 在线玩家头像:[String] = Array<String>()
        var 在线玩家名:[String] = Array<String>()
        var 在线玩家名带字体格式:[String] = Array<String>()
        if (li分割.count < 2) {
            return [在线玩家名, 在线玩家头像, 在线玩家名带字体格式]
        }
        for li分割循环 in 1...li分割.count-1 {
            autoreleasepool {
                let 当前li分割:String = li分割[li分割循环]
                let 图片相对路径:String = 解析.抽取区间(当前li分割, 起始字符串: "<img src=\"", 结束字符串: "\"></span><a href=\"#\"", 包含起始字符串: false, 包含结束字符串: false)
                let 图片相对路径分割:[String] = 图片相对路径.componentsSeparatedByString("/")
                let 图片文件名:String = 图片相对路径分割[图片相对路径分割.count-1]
                在线玩家头像.append(图片文件名)
                let 玩家名带格式:String = 解析.抽取区间(当前li分割, 起始字符串: "title=\"Center on player\">", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: false)
                在线玩家名带字体格式.append(玩家名带格式)
                let 玩家名:[String] = 解析.去除HTML标签(玩家名带格式,需要合成: true)
                在线玩家名.append(玩家名[0])
            }
        }
        /*
         使用 在线玩家头像 时应补充：
         let 头像网址:String = "https://mcmap.90g.org/tiles/faces/"
         let 图片补路径:String = 头像网址 + "16x16/" + 在线玩家头像 //支持32x32
         
         使用 在线玩家名带字体格式 时应补充：
         let 网页头:String = "<html><meta http-equiv=Content-Type content=\"text/html;charset=utf-8\"><body>"
         let 网页尾:String = "</body></html>"
         */
        //        NSLog("在线玩家头像：\(在线玩家头像)")
        //        NSLog("在线玩家名：\(在线玩家名)")
        //        NSLog("在线玩家名带字体格式：\(在线玩家名带字体格式)")
        let 合并二维数组:[[String]] = [在线玩家名, 在线玩家头像, 在线玩家名带字体格式]
        return 合并二维数组
    }
    
    //返回值= 在线玩家名:[在线玩家头像, 在线玩家名带字体格式,在线玩家血量宽度,在线玩家护甲宽度,在线玩家位置]
    func 取得在线玩家和当前世界活动状态() -> Dictionary<String,[String]> {
        var 在线玩家:Dictionary<String,[String]> = 转换玩家二维数组格式(取得在线玩家())
        var 活动玩家:Dictionary<String,[String]> = 转换玩家二维数组格式(取得当前世界活动玩家状态())
        for key in 活动玩家.keys
        {
            autoreleasepool {
                var 在线玩家当前值:[String] = 在线玩家[key]!
                let 活动玩家当前值:[String] = 活动玩家[key]!
                for i in 0...活动玩家当前值.count-1 {
                    autoreleasepool {
                        在线玩家当前值.append(活动玩家当前值[i])
                    }
                }
                在线玩家[key] = 在线玩家当前值
            }
        }
        //        NSLog("在线玩家\(在线玩家.count)=\(在线玩家)");
        return 在线玩家
        //果然不用字典用数组的话好麻烦：
        //        let 修改前玩家数量:Int = 在线玩家.count
        //        for (var 在线玩家循环 = 1; 在线玩家循环 < 修改前玩家数量; 在线玩家循环++) {
        //            var 当前在线玩家:[String] = 在线玩家[在线玩家循环]
        //            let 当前在线玩家名称:String = 当前在线玩家[0]
        //            for (var 世界活动玩家状态循环 = 0; 世界活动玩家状态循环 < 世界活动玩家状态.count; 世界活动玩家状态循环++) {
        //                var 当前世界活动玩家状态:[String] = 世界活动玩家状态[世界活动玩家状态循环]
        //                let 当前世界活动玩家名称:String = 当前世界活动玩家状态[0]
        //                if (当前世界活动玩家名称 == 当前在线玩家名称) {
        //                    NSLog("添加详情到：\(当前世界活动玩家名称)")
        //                    let 修改前属性数量:Int = 当前世界活动玩家状态.count
        //                    for (var 当前世界活动玩家状态循环 = 0; 当前世界活动玩家状态循环 < 修改前属性数量; 当前世界活动玩家状态循环++) {
        //                        let 当前要补充的属性:String = 当前世界活动玩家状态[当前世界活动玩家状态循环]
        //                        当前世界活动玩家状态.append(当前要补充的属性)
        //                        在线玩家[在线玩家循环] = 当前世界活动玩家状态
        //                        //当前在线玩家.append(当前要补充的属性)
        //                    }
        //                }
        //            }
        //        }
        //        NSLog("在线玩家：\(在线玩家.count)：\(在线玩家)")
        //NSLog("新在线玩家：\(新在线玩家.count)：\(新在线玩家)")
    }
    
    func 转换玩家二维数组格式(数组:[[String]]) -> Dictionary<String,[String]> {
        let 在线玩家二维数组:[[String]] = 数组
        let 在线玩家名:[String] = 在线玩家二维数组[0]
        var 玩家信息:Dictionary<String,[String]> = Dictionary<String,[String]>()
        if (在线玩家名.count < 1) {
            return 玩家信息
        }
        for 在线玩家名循环 in 0...在线玩家名.count-1 {
            autoreleasepool {
                var 当前玩家信息:[String] = Array<String>()
                var 当前玩家名:String = ""
                for 在线玩家二维数组循环 in 0...在线玩家二维数组.count-1 {
                    autoreleasepool {
                        let 当前玩家名数组:[String] = 在线玩家二维数组[在线玩家二维数组循环]
                        let 当前信息:String = 当前玩家名数组[在线玩家名循环]
                        if (在线玩家二维数组循环 > 0) {
                            当前玩家信息.append(当前信息)
                        } else {
                            当前玩家名 = 当前信息
                        }
                    }
                }
                玩家信息[当前玩家名] = 当前玩家信息
            }
        }
        //NSLog("玩家信息：\(玩家信息)")
        return 玩家信息
    }
    
    func 取得当前世界活动玩家状态() -> [[String]] {
        let 活动玩家块起始:String = "<div class=\"Marker playerMarker leaflet-marker-icon leaflet-clickable\""
        let 活动玩家块:String = 解析.抽取区间(html!, 起始字符串: 活动玩家块起始, 结束字符串: "<div class=\"leaflet-popup-pane\">", 包含起始字符串: true, 包含结束字符串: false)
        let 活动玩家块分割:[String] = 活动玩家块.componentsSeparatedByString(活动玩家块起始)
        var 在线玩家名称:[String] = Array<String>()
        var 在线玩家血量宽度:[String] = Array<String>()
        var 在线玩家护甲宽度:[String] = Array<String>()
        var 在线玩家位置:[String] = Array<String>()
        if (活动玩家块分割.count < 2) {
            return [在线玩家名称,在线玩家血量宽度,在线玩家护甲宽度,在线玩家位置]
        }
        for 活动玩家块分割循环 in 1...活动玩家块分割.count-1 {
            autoreleasepool {
                let 当前活动玩家块分割:String = 活动玩家块分割[活动玩家块分割循环]
                //NSLog("当前活动玩家块分割：\(当前活动玩家块分割)")
                var 玩家名称:String = 解析.抽取区间(当前活动玩家块分割, 起始字符串: "<span class=\"playerNameSm\">", 结束字符串: "<div c", 包含起始字符串: false, 包含结束字符串: false)
                玩家名称 = 解析.去除HTML标签(玩家名称, 需要合成: true)[0]
                let 玩家位置:String = translate3d标签抽取(当前活动玩家块分割)
                //NSLog("玩家translate3d位置：\(玩家translate3d位置)")
                let 玩家血量宽度:String = 解析.抽取区间(当前活动玩家块分割, 起始字符串: "<div class=\"playerHealth\" style=\"width: ", 结束字符串: "px;\">", 包含起始字符串: false, 包含结束字符串: false)
                let 玩家护甲宽度:String = 解析.抽取区间(当前活动玩家块分割, 起始字符串: "<div class=\"playerArmor\" style=\"width: ", 结束字符串: "px;\">", 包含起始字符串: false, 包含结束字符串: false)
                在线玩家名称.append(玩家名称)
                在线玩家血量宽度.append(玩家血量宽度)
                在线玩家护甲宽度.append(玩家护甲宽度)
                在线玩家位置.append(玩家位置)
            }
        }
        //        NSLog("玩家名称：\(在线玩家名称)")
        //        NSLog("玩家translate3d位置：\(在线玩家位置)")
        //        NSLog("玩家血量宽度：\(在线玩家血量宽度)")
        //        NSLog("玩家护甲宽度：\(在线玩家护甲宽度)")
        let 合并二维数组:[[String]] = [在线玩家名称,在线玩家血量宽度,在线玩家护甲宽度,在线玩家位置]
        return 合并二维数组
    }
    
    func 取得当前聊天记录() -> [[String]] {
        let 聊天信息块:String = 解析.抽取区间(html!, 起始字符串: "<div class=\"messagelist", 结束字符串: "</div><button", 包含起始字符串: false, 包含结束字符串: true)
        let 聊天信息块分割:[String] = 聊天信息块.componentsSeparatedByString("</div>")
        var 聊天:[[String]] = Array<Array<String>>()
        if (聊天信息块分割.count < 1) {
            return 聊天
        }
        for 聊天信息块分割循环 in 0...聊天信息块分割.count-1 {
            autoreleasepool {
                var 已处理:Bool = false
                let 当前聊天信息块:String = 聊天信息块分割[聊天信息块分割循环]
                let 聊天图标单元:String = "<div class=\"messageicon\">"
                let 当前聊天信息块分割:[String] = 当前聊天信息块.componentsSeparatedByString(聊天图标单元)
                if (当前聊天信息块分割.count > 0) { //玩家消息
                    let 分割信息字段:[String] = 当前聊天信息块.componentsSeparatedByString("<span class=\"message")
                    var 类型:String = "0" //0=游戏内聊天，1=上下线消息，2=电报等第三方平台，3=手机
                    if (分割信息字段.count > 1) {
                        var 玩家头像:String = 解析.抽取区间(分割信息字段[1], 起始字符串: "icon\">", 结束字符串: "</span>", 包含起始字符串: false, 包含结束字符串: false)
                        if (玩家头像 != "") {
                            let 图片相对路径 = 解析.抽取区间(玩家头像, 起始字符串: "<img src=\"", 结束字符串: "\" class=", 包含起始字符串: false, 包含结束字符串: false)
                            let 图片相对路径分割:[String] = 图片相对路径.componentsSeparatedByString("/")
                            玩家头像 = 图片相对路径分割[图片相对路径分割.count-1]
                        }
                        var 玩家名称:String = 解析.抽取区间(分割信息字段[2], 起始字符串: "text\"> ", 结束字符串: "</span>", 包含起始字符串: false, 包含结束字符串: false)
                        var 玩家消息:String = 解析.抽取区间(分割信息字段[3], 起始字符串: "text\">", 结束字符串: "</span>", 包含起始字符串: false, 包含结束字符串: false)
                        if (玩家名称 == "") {
                            类型 = "2"
                            let 玩家消息分割:[String] = 玩家消息.componentsSeparatedByString("] ")
                            玩家名称 = 解析.抽取区间(玩家消息分割[0], 起始字符串: "[", 结束字符串: "", 包含起始字符串: false, 包含结束字符串: false)
                            if (玩家消息分割.count > 1) {
                                玩家消息 = 玩家消息分割[1]
                            } else {
                                玩家消息 = "<APP发生了错误QAQ>"
                            }
                        }
                        let 手机关键字:Range? = 玩家消息.rangeOfString("Mobile") //全局_手机发送消息关键字
                        if (手机关键字 != nil) {
                            类型 = "3"
                            玩家消息 = 玩家消息.substringFromIndex(手机关键字!.endIndex)
                        }
                        //                    NSLog("玩家头像：\(玩家头像)")
                        //                    NSLog("玩家名称：\(玩家名称)")
                        //                    NSLog("来自第三方聊天软件：\(来自第三方聊天软件)")
                        //                    NSLog("玩家消息：\(玩家消息)")
                        聊天.append([玩家头像,玩家名称,类型,玩家消息])
                        已处理 = true
                    }
                    if (已处理 == false) { //系统消息
                        let 上下线提示分割:[String] = 当前聊天信息块.componentsSeparatedByString("</span> ")
                        let 上下线玩家名:String = 解析.抽取区间(上下线提示分割[0], 起始字符串: "<div class=\"messagerow\">", 结束字符串: "", 包含起始字符串: false, 包含结束字符串: false)
                        if (上下线提示分割.count > 1) {
                            let 上下线行为:String = 上下线提示分割[1]
                            //                        NSLog("上下线玩家名：\(上下线玩家名)")
                            //                        NSLog("上下线行为：\(上下线行为)")
                            聊天.append(["",上下线玩家名,"1",上下线行为])
                            已处理 = true
                        }
                    }
                } else { //系统消息
                    NSLog("[ERR]溢出聊天信息块：\(当前聊天信息块)")
                }
            }
        }
        //        NSLog("聊天：\(聊天)")
        return 聊天
    }
    
    func 取得商店和地点列表() -> [[[String]]] {
        var 商店:[[String]] = Array<Array<String>>()
        var 地点:[[String]] = Array<Array<String>>()
        let 商店块起始:String = "Marker mapMarker "
        let 商店块结束:String = "playerMarker"
        let 商店块:String = 解析.抽取区间(html!, 起始字符串: 商店块起始, 结束字符串: 商店块结束, 包含起始字符串: true, 包含结束字符串: false)
        let 商店块分割:[String] = 商店块.componentsSeparatedByString(商店块起始)
        if (商店块分割.count < 2) {
            return [商店,地点]
        }
        for 商店块分割循环 in 1...商店块分割.count-1 {
            autoreleasepool {
                let 商店描述:String = 商店块分割[商店块分割循环]
                let 商店判定:Range? = 商店描述.rangeOfString("markerName_SignShopMarkers")
                let 商店名:String = 解析.抽取区间(商店描述, 起始字符串: "markerName16x16\">", 结束字符串: "</span>", 包含起始字符串: false, 包含结束字符串: false)
                let 商店位置:String = translate3d标签抽取(商店描述)
                if (商店判定 == nil) {
                    地点.append([商店名,商店位置])
                } else {
                    商店.append([商店名,商店位置])
                }
            }
        }
        //        NSLog("商店：\(商店)")
        //        NSLog("地点：\(地点)")
        return [商店,地点]
    }
    
    func translate3d标签抽取(源:String) -> String {
        let translate3d位置描述:String = 解析.抽取区间(源, 起始字符串: "translate3d(", 结束字符串: "px, 0px);", 包含起始字符串: false, 包含结束字符串: false)
        let translate3d位置数组:[String] = translate3d位置描述.componentsSeparatedByString("px, ")
        let 位置描述:String = translate3d位置数组.joinWithSeparator(",")
        return 位置描述
    }
    
    func 取得弹出提示() -> [String] {
        //<div class="alertbox" style>Could not update map: error</div>
        var 对话框正在被显示:String = "0"
        var 起始点到结束点字符串:String = ""
        let alertbox起始点位置:Range? = html!.rangeOfString("<div class=\"alertbox\"")
        if (alertbox起始点位置 != nil) {
            起始点到结束点字符串 = html!.substringFromIndex(alertbox起始点位置!.startIndex)
            let 搜索结束点:Range = 起始点到结束点字符串.rangeOfString("</div>")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.startIndex)
            let 检查对话框是否隐藏:Range? = html!.rangeOfString("display: none")
            
            if (检查对话框是否隐藏 == nil) { //没有被隐藏
                对话框正在被显示 = "1"
            }
            let 提示信息起始点位置:Range = 起始点到结束点字符串.rangeOfString(">")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringFromIndex(提示信息起始点位置.endIndex)
        }
        let 弹出提示信息:[String] = [ 对话框正在被显示, 起始点到结束点字符串 ]
        //        NSLog("弹出提示信息：\(弹出提示信息)")
        return 弹出提示信息
    }
}
