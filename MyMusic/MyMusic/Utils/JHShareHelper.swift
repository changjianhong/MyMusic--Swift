//
//  JHShareHelper.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/24.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

    
func showShareEditor(image:UIImage) {
    
        // 1.创建分享参数
        var shareParames = NSMutableDictionary()
        
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : image,
            url : NSURL(string:"http://jingting.com"),
            title : "分享标题",
            type : SSDKContentType.Image)
        //2.显示分享编辑页面
        ShareSDK.showShareEditor(SSDKPlatformType.TypeSinaWeibo, otherPlatformTypes: nil, shareParams: shareParames) { (state :SSDKResponseState, platformType : SSDKPlatformType, userData: [NSObject : AnyObject]!, contentEntity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: println("分享成功")
            case SSDKResponseState.Fail:    println("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  println("分享取消")
                
            default:
                break
            }
        }
    }
    

/**
* 获取授权用户信息
*/
func OAuth() {
    //授权
    ShareSDK.authorize(SSDKPlatformType.TypeSinaWeibo, settings: nil, onStateChanged: { (state : SSDKResponseState, user : SSDKUser!, error : NSError!) -> Void in
        
        switch state{
            
        case SSDKResponseState.Success: println("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
        case SSDKResponseState.Fail:    println("授权失败,错误描述:\(error)")
        case SSDKResponseState.Cancel:  println("操作取消")
            
        default:
            break
        }
    })
}


func showShareMenu(view:UIView,songTitle:String) {
    
    //1.创建分享参数
    var shareParames = NSMutableDictionary()
    shareParames.SSDKSetupShareParamsByText(songTitle,
        images : UIImage(named: "640x1136.png"),
        url : NSURL(string:"https://github.com/changjianhong/--Swift.git"),
        title : "静听(cjh)",
        type : SSDKContentType.Auto)
    //2.进行分享
    ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
        
        switch state{
            
        case SSDKResponseState.Success: println("分享成功")
        case SSDKResponseState.Fail:    println("分享失败,错误描述:\(error)")
        case SSDKResponseState.Cancel:  println("分享取消")
            
        default:
            break
        }
    }
}