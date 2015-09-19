//
//  JHShareHelper.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/24.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import pop
    
func showShareEditor(image:UIImage) {
    
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : image,
            url : NSURL(string:"http://jingting.com"),
            title : "分享标题",
            type : SSDKContentType.Image)
        //2.显示分享编辑页面
        ShareSDK.showShareEditor(SSDKPlatformType.TypeSinaWeibo, otherPlatformTypes: nil, shareParams: shareParames) { (state :SSDKResponseState, platformType : SSDKPlatformType, userData: [NSObject : AnyObject]!, contentEntity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
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
            
        case SSDKResponseState.Success: print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user.credential)")
        case SSDKResponseState.Fail:    print("授权失败,错误描述:\(error)")
        case SSDKResponseState.Cancel:  print("操作取消")
            
        default:
            break
        }
    })
}


func configPlatformTypeAndShare(index:Int){
    
    var platformType:SSDKPlatformType
    
    switch index {
    case 0:
        platformType = SSDKPlatformType.TypeQQ
    case 1:
        platformType = SSDKPlatformType.SubTypeQZone
    case 2:
        platformType = SSDKPlatformType.TypeSinaWeibo
    case 3:
        platformType = SSDKPlatformType.TypeWechat
    case 4:
        platformType = SSDKPlatformType.SubTypeWechatTimeline
    default:
        platformType = SSDKPlatformType.TypeUnknown
        break
    }
    
    share(platformType)
    
}


func share(platformType:SSDKPlatformType) {
    //1.创建分享参数
    let shareParames = NSMutableDictionary()
    shareParames.SSDKSetupShareParamsByText("ad",
        images : UIImage(named: "640x1136.png"),
        url : NSURL(string:"https://github.com/changjianhong/--Swift.git"),
        title : "静听(cjh)",
        type : SSDKContentType.Auto)
    shareParames.SSDKEnableUseClientShare()
    
    ShareSDK.share(platformType, parameters: shareParames) { (state, userdata, contentEnity, error) -> Void in
        
        switch state{
        case SSDKResponseState.Success: print("分享成功")
        case SSDKResponseState.Fail: print("分享失败,错误描述:\(error)")
        case SSDKResponseState.Cancel: print("分享取消")
        
        default:
            break
        }
        
    }
}


