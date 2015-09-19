//
//  JHSongMP3Service.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/27.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import Alamofire


func getSongMP3(song:Song, receiveBlock:(String)->() = {param in} ,failBlock:()->()) {
    
    let author = parseString(song.author)
    let title = parseString(song.title)
    
//    let urlstr = kMusic(title as String, author: author as String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    
    
    let urlstr = kMusic(title as String, author: author as String).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
    

    
    Alamofire.request(.GET,urlstr).responseString(encoding: NSUTF8StringEncoding) { (request, response, receiveString) -> Void in
        
        if receiveString.value == nil{
            failBlock()
            return
        }
        
        var strArr = receiveString.value!.componentsSeparatedByString("<![CDATA[") as Array
        
        if strArr.count > 2 {
            var s1:String = strArr[1] as String
            s1 = s1.stringByReplacingOccurrencesOfString("$]]></encode><decode>", withString: "")
            s1 = s1.stringByReplacingOccurrencesOfString("]]></encode><decode>", withString: "")
            let sArr = s1.componentsSeparatedByString("/") as Array
            let lastS:String = sArr.last!
            
            let s2Arr:NSArray = strArr[2].componentsSeparatedByString("]]") as NSArray
            
            s1 = s1.stringByReplacingOccurrencesOfString(lastS as String, withString:(s2Arr[0] as! String) as String)
            
            receiveBlock(s1)
        } else {
            failBlock()
        }
    }
}

/**
路径为 song.title.mp3

:param: song <#song description#>
*/
func downloadSongMP3(song:Song){
    
    Alamofire.download(.GET, song.songUrl){(temporaryURL, response) -> NSURL in
        let fileManager = NSFileManager.defaultManager()
        
        if let directoryURL:NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]{
            
            let mp3DirectoryURL = directoryURL.URLByAppendingPathComponent("MP3")
            
            do {
                try fileManager.createDirectoryAtURL(mp3DirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
            
            let pathComponent = song.title.stringByAppendingString(".mp3")
            let directory = mp3DirectoryURL.URLByAppendingPathComponent(pathComponent)
            return directory
        }
        return temporaryURL
    }.progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
        if totalBytesRead == totalBytesExpectedToRead {
            saveSongMP3Info(song)
        }
    }
}

/**
存储歌曲信息到数据库

:param: song <#song description#>
*/
func saveSongMP3Info(song:Song) {
    dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
        let dbStore = YTKKeyValueStore(DBWithName: "songSqlite.db")
        dbStore.createTableWithName("songs")
        dbStore.putModelObject(song, withId: song.title, intoTable: "songs")
    })
}


/**
获取本地歌曲url

:returns:
*/
func getNativeSongURL(songTitle:String) -> NSURL?{
    let fileManager = NSFileManager.defaultManager()
    if let directoryURL:NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] {
        let mp3DirectoryURL:NSURL? = directoryURL.URLByAppendingPathComponent("MP3").URLByAppendingPathComponent("\(songTitle).mp3")
        if mp3DirectoryURL != nil {
           return mp3DirectoryURL
        }
        return nil
    }
    return nil
}

func getNativeSongList() -> NSArray! {
    let dbStore = YTKKeyValueStore(DBWithName: "songSqlite.db")
    if dbStore.isTableExists("songs") {
        let items = dbStore.getAllModelObjectByClassName(Song.classForCoder(), fromTable: "songs") as! NSArray
        return items
    } else {
        dbStore.createTableWithName("songs")
        return NSArray()
    }
}

func deleteNativeSong(songTitle:String) {
    let dbStore = YTKKeyValueStore(DBWithName: "songSqlite.db")
    if dbStore.isTableExists("songs") {
        dbStore.deleteObjectById(songTitle, fromTable: "songs")
    }
    let fileManager = NSFileManager.defaultManager()
    let url = getNativeSongURL(songTitle)
    if url != nil {
//        fileManager.removeItemAtURL(url!, error: nil)
        
        do {
            try fileManager.removeItemAtURL(url!)
        }catch {
            
        }
    }
    
}




