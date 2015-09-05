//
//  JHMacros.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/21.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit


let kScreenWidth = UIScreen.mainScreen().bounds.width
let kScreenHeight = UIScreen.mainScreen().bounds.height


/// 歌曲列表
let kMusicListURL:String = "http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.getSmartSongList&page_no=1&page_size=50&scene_id=42&item_id=115&version=5.2.1&from=ios&channel=appstore"

/// 歌曲mp3
func kMusic(title:String, author:String) -> String{
    
    var url = "http://box.zhangmen.baidu.com/x?op=12&count=1&title=\(title)$$\(author)$$$$"
    
    return url
    
}

func kUIColorFromRGB(rgbValue:Int) -> UIColor{

    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0 , green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha:1.0);
}


/**
解析字符串 删除字符串中的非法字符

:param: str 

:returns:
*/
func parseString(str:String) -> String {

    var string = str as NSString
    
    if string.isEqualToString("A-Lin") {
        return string as String
    }
    
    if string.isEqualToString("G.E.M.邓紫棋") {
        string = "邓紫棋"
    }
    
    if string.hasSuffix(".") {
        string = string.substringToIndex(string.length - 1)
    }
    
    if string.containsString("(") {
        var loc = string.rangeOfString("(").location
        string = string.substringToIndex(loc)
    }
    
    if string.containsString("-") {
        var loc = string.rangeOfString("-").location
        string = string.substringToIndex(loc)
    }
 
    return string as String
}


















