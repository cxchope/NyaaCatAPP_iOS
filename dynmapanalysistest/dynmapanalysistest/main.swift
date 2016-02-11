 //
//  main.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/11.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Foundation

print("Hello, World!")

let path = NSBundle.mainBundle().pathForResource("html", ofType: "txt")
var html:String = ""
var contents: String? = nil
 if (path != nil) {
    do {
        contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
    } catch _ {
        contents = nil
    }
    if (contents != nil) {
        let dma:DynmapAnalysis = DynmapAnalysis()
        dma.html = contents!
        dma.start()
    } else {
        print("contents null")
    }
 } else {
    print("path null")
 }