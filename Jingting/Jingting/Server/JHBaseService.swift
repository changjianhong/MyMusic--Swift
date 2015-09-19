//
//  JHBaseService.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/21.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc protocol ServiceProtocol{
    func didRecieveResults(result:AnyObject)
}

class JHBaseService: NSObject {
   
    weak var delegate:ServiceProtocol?
    
    var error:NSError?
    
    var list = NSMutableArray()
    
    var listNum:Int?
    var num:Int = 0
    
    /**
    根据url 请求网络数据
    
    :param: urlStr
    */
    func getSongList(urlStr:String){
        
//        var error:NSError?
        
        weak var weakSelf:JHBaseService? = self
        
        
        Alamofire.request(.GET, urlStr)
            .responseJSON { _, _, result in
                print(result.isSuccess)
                debugPrint(result)
                
                weakSelf!.parseJsonData(result.value as! NSDictionary)
                
        }
    }
    
    /**
    解析JsonData song模型
    
    :param: jsonData
    */
    func parseJsonData(jsonData:NSDictionary) {
        
        let errorCode = jsonData["error_code"] as! NSInteger
        if errorCode == 22000 {
            
            let json = JSON(jsonData)
            let songlist = json["result"]["songlist"].array!
            
            listNum = songlist.count
            for songTmp in songlist {
                let songDic = songTmp.dictionaryObject
                let song = Song()
                song.setValuesForKeysWithDictionary(songDic!)
                weak var weakSelf:JHBaseService? = self
                getSongMP3(song, receiveBlock: { (url) -> () in
                    weakSelf?.addAtrribute(url, song: song)
                }, failBlock: { () -> () in
                    weakSelf?.addAtrribute(nil, song: nil)
                })
                
            }
        }
    }
    
    func addAtrribute(url:String?,song:Song?) {
        
        num = num + 1
        
        if let u = url {
            song!.songUrl = u
            list.addObject(song!)
        }
        
        if listNum == num {
            delegate?.didRecieveResults(list)
            num = 0
        }
    }
}

