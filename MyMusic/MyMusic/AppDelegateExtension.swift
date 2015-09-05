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
//                SSDKPlatformType.TypeTencentWeibo.rawValue,
//                SSDKPlatformType.TypeDouBan.rawValue,
//                SSDKPlatformType.TypeCopy.rawValue,
//                SSDKPlatformType.TypeFacebook.rawValue,
//                SSDKPlatformType.TypeTwitter.rawValue,
//                SSDKPlatformType.TypeMail.rawValue,
//                SSDKPlatformType.TypeSMS.rawValue,
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
                    
                case SSDKPlatformType.TypeTencentWeibo:
                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                        redirectUri : "http://www.sharesdk.cn")
                    break
                    
                case SSDKPlatformType.TypeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    appInfo.SSDKSetupFacebookByAppKey("107704292745179",
                        appSecret : "38053202e1a5fe26c80c753071f0b573",
                        authType : SSDKAuthTypeBoth)
                    break
                    
                case SSDKPlatformType.TypeTwitter:
                    //设置Twitter应用信息
                    appInfo.SSDKSetupTwitterByConsumerKey("LRBM0H75rWrU9gNHvlEAA2aOy",
                        consumerSecret : "gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G",
                        redirectUri : "http://mob.com")
                    break
                    
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId(QQAppID,
                        appKey : QQAppKey,
                        authType : SSDKAuthTypeWeb)
                    break
                    
                case SSDKPlatformType.TypeDouBan:
                    //设置豆瓣应用信息
                    appInfo.SSDKSetupDouBanByApiKey("02e2cbe5ca06de5908a863b15e149b0b", secret: "9f1e7b4f71304f2f", redirectUri: "http://www.sharesdk.cn")
                    break
                default:
                    break
                }
        })
    }
}
