//
//  SongPlay.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/23.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol SongPlayDelegate{
     func songPlayBackDidFinish(palyResource:SongPlayResource)
}


enum SongPlayPlaybackState{
    case Play
    case Pause
    case Stop
    case Unknown
}

enum SongPlayResource{
    case Unknown
    case Native
    case Online
}

class SongPlay: NSObject {
    
    class func shareInstance() -> SongPlay{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:SongPlay? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance=SongPlay()
            }
        )
        return YRSingleton.instance!
    }
    
    var playResource = SongPlayResource.Unknown
    
    var currentSong:Song!
    var songList:NSArray!
    var delegate:SongPlayDelegate!
    var audioPlayer = MPMoviePlayerController()
    var currentTime:NSTimeInterval {
        get {
            return audioPlayer.currentPlaybackTime
        }
    }
    var duration:NSTimeInterval {
        get {
            return audioPlayer.duration
        }
    }
    var playbackState:SongPlayPlaybackState {
        get {
            
            if audioPlayer.playbackState == MPMoviePlaybackState.Playing {
                return SongPlayPlaybackState.Play
            } else if audioPlayer.playbackState == MPMoviePlaybackState.Paused {
                return SongPlayPlaybackState.Pause
            } else {
                return SongPlayPlaybackState.Unknown
            }
        }
    }
    
    
    override init() {
        super.init()
        
        initData()
    }
    
    func initData() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish", name: MPMoviePlayerPlaybackDidFinishNotification, object: self.audioPlayer)
    }
    
    func moviePlayBackDidFinish() {
        delegate?.songPlayBackDidFinish(playResource)
    }
    
    //开始播放音乐
    func songBegin(song:Song, playSucceed:()->(), playFail:()->()) {
        
        playResource = SongPlayResource.Online
        
        if currentSong == song && self.audioPlayer.playbackState == MPMoviePlaybackState.Paused{
            self.audioPlayer.play()
            
            return
        }
        weak var weakSelf:SongPlay? = self
        currentSong = song
        
        self.audioPlayer.contentURL = NSURL(string: song.songUrl)
        self.audioPlayer.play()
        playSucceed()
        
    }
    
    //恢复播放
    func songPlay(){
        self.audioPlayer.play()
    }
    
    //暂停播放
    func songPause() {
        self.audioPlayer.pause()
    }
    
    //停止播放
    func songStop() {
        self.audioPlayer.stop()
    }
    
    func songNext() {
        var index = songList?.indexOfObject(currentSong!)
        var song = songList[index! + 1] as! Song
        songBegin(song, playSucceed: { () -> () in
            
        }) { () -> () in
            
        }
    }
    
    func nativeSongPlay(song:Song) {
        
        playResource = SongPlayResource.Native
        
        var url = getNativeSongURL(song.title)
        
        if let u = url {
            self.audioPlayer.contentURL = url!
            self.audioPlayer.play()
        }
        currentSong = song
    }
    
    
}








