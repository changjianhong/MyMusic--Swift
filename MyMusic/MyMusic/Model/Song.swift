//
//  Song.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/21.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

class Song: NSObject {
   
    var artist_id:String        = ""
    var pic_small:String        = ""
    var pic_big:String          = ""
    var pic_huge:String         = ""
    var lrclink:String          = ""
    var song_id:String          = ""
    var title:String            = ""
    var author:String           = ""
    var has_mv_mobile:NSInteger = 0
    var songUrl:String          = ""
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
}
/*
"artist_id": "1208",
"language": "国语",
"pic_big": "http://c.hiphotos.baidu.com/ting/pic/item/bd315c6034a85edfae73b2be48540923dc5475ab.jpg",
"pic_small": "http://a.hiphotos.baidu.com/ting/pic/item/0823dd54564e9258fbcbca739d82d158cdbf4eab.jpg",
"country": "港台",
"area": "1",
"publishtime": "2009-11-20",
"album_no": "14",
"lrclink": "http://musicdata.baidu.com/data2/lrc/13882195/%E7%88%B1%E4%B8%80%E7%9B%B4%E5%AD%98%E5%9C%A8.lrc",
"versions": "",
"copy_type": "1",
"file_duration": "272",
"hot": "",
"all_artist_ting_uid": "7910",
"pic_premium": "http://a.hiphotos.baidu.com/ting/pic/item/d31b0ef41bd5ad6e8121287780cb39dbb7fd3c56.jpg",
"pic_huge": "http://c.hiphotos.baidu.com/ting/pic/item/2e2eb9389b504fc2dea0fc98e4dde71191ef6dab.jpg",
"pic_singer": "",
"all_rate": "128,320,192,64,24,256,flac",
"resource_type": "0",
"all_artist_id": "1208",
"compose": "Song Wei Ma,陈孟奇",
"songwriting": "",
"del_status": "0",
"has_mv_mobile": 0,
"song_id": "209225",
"title": "爱一直存在",
"ting_uid": "7910",
"author": "梁文音",
"album_id": "7314022",
"album_title": "爱,一直存在",
"is_first_publish": 0,
"havehigh": 2,
"charge": 0,
"has_mv": 1,
"learn": 1,
"song_source": "web",
"piao_id": "0",
"korean_bb_song": "0",
"resource_type_ext": "2"
*/