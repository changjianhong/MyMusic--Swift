//
//  AppDelegateExtension.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/24.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

extension AppDelegate {
    func setupShareSdk() {
        ShareSDK.registerApp(MobKey,
            activePlatforms : [SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,
                SSDKPlatformType.TypeQQ.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey(SinaKey,
                        appSecret : SinaSecret,
                        redirectUri : SinaRedirect_uri,
                        authType : SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId(WXAppID, appSecret: WXAppSecret)
                    break
                    
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId(QQAppID,
                        appKey : QQAppKey,
                        authType : SSDKAuthTypeWeb)
                    break
                    
                default:
                    break
                }
        })
    }
}
