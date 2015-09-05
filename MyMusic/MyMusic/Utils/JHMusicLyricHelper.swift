//
//  JHMusicLyricHelper.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/26.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

/**
*解析歌词
*/
func parseLyricWithUrl(urlString:NSString, succeed:(NSArray?)->()){
    if ( urlString.length < 2 ){
        return
    }
    var url : NSURL = NSURL(string:urlString as String)!
    var lyc : NSString = NSString(contentsOfURL: url, encoding:NSUTF8StringEncoding, error: nil)!
//    NSLog("获取到歌词文件内容:%@", lyc)
    var result:NSMutableArray = NSMutableArray()
    for lStr in lyc.componentsSeparatedByString("\n") {
        
        //        var arr = lStr.componentsSeparatedByString("]")
        
        
        var item:NSString = lStr as! NSString
        if(item.length>0){
            var dic:NSDictionary = NSDictionary()
            var startrange:NSRange = item.rangeOfString("[")
            var stoprange:NSRange = item.rangeOfString("]")
            if stoprange.length == 0{
                //歌词没时间
                var songLrc:SongLrc = SongLrc()
                songLrc.total=NSNumber(int: -1)//开始显示的秒数
                songLrc.time=""//开始显示时间
                songLrc.text=item//显示的歌词
                result.addObject(songLrc)
                
            }else{
                var content:NSString = item.substringWithRange(NSMakeRange(startrange.location+1, stoprange.location-startrange.location-1))
                //歌词有时间
                if (content.length == 8) {
                    var minute:NSString = content.substringWithRange(NSMakeRange(0, 2))
                    var second:NSString = content.substringWithRange(NSMakeRange(3, 2))
                    var mm:NSString = content.substringWithRange(NSMakeRange(6, 2))
                    var time:NSString = NSString(format: "%@:%@.%@", minute,second,mm)
                    var total:NSNumber = NSNumber(integer: minute.integerValue * 60 + second.integerValue)
                    var lyric:NSString = item.substringFromIndex(10)
                    
                    var songLrc:SongLrc = SongLrc()
                    songLrc.total=total//开始显示的秒数
                    songLrc.time=time//开始显示时间
                    
                    if lyric.length == 0 {
                        lyric = "。。。。。。。"
                    }
                    
                    songLrc.text=lyric//显示的歌词
                    result.addObject(songLrc)
                }
            }
            
        }
    }
    if result.count > 0 {
        succeed(result)
    }
}
