
# Jingting
一个学习swift写的简单的音乐项目

昨天升级了iphone，无法再用Xcode6.4在真机调试，就直接升到了Xocde7，Swift也随之要使用2.0，升级后可想而知，下面总结一下遇到的问题：

1.首先所用的第三方库都要更新

LiquidFloatingActionButton.git', :branch => 'swift-2.0'

pod 'FMDB'

pod 'pop', '~> 1.0'

pod 'Alamofire', '~> 2.0'

pod 'Kingfisher', '~> 1.5'

pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git', :branch => 'swift-2.0'

pod 'MJExtension'

pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git', :branch => 'xcode7'

这些都是支持Swift2.0版的

2.iOS9都要面临的问题(ATS)

iOS9引入了新特性App Transport Security (ATS)。

新特性要求App内访问的网络必须使用HTTPS协议。

但是现在公司的项目使用的是HTTP协议，使用私有加密方式保证数据安全。现在也不能马上改成HTTPS协议传输。

解决办法：

在Info.plist中添加NSAppTransportSecurity类型Dictionary。

在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES

3.Bitcode 

在Xcode 7中，我们新建一个iOS程序时，bitcode选项默认是设置为YES的（”Build Settings”->”Enable Bitcode”）

如果我们用的第三方库又不支持Bitcode的 就需要把其设置为NO

4.-canOpenURL: failed for URL: "cydia://package/com.example.package" - error: "This app is not allowed 

--Bugtags.startWithAppKey(BugAppkey, invocationEvent: BTGInvocationEventBubble) 引起的

5.MyMusic was compiled with optimization - stepping may behave oddly; variables may not be available. 

---崩溃  

---- WeiboSDK.registerApp(SinaKey) 引起的

6.启动Xcode  load bundle cocoapods 插件失败 Xocde就打不开了 一直启动失败 ，最后卸载重装才好的

7.building file list ... rsync: link_stat "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphonesimulator/libswiftSecurity.dylib" failed: No such file or directory (2)

done

sent 29 bytes  received 20 bytes  98.00 bytes/sec

total size is 0  speedup is 0.00

rsync error: some files could not be transferred (code 23) at /SourceCache/rsync/rsync-45/rsync/main.c(992) [sender=2.6.9]

Command /bin/sh failed with exit code 23

//MARK: 真机可以运行  虚拟机不可以 最后 google 也没有找到解决办法，最后不得已重新创建个新项目

8.Swift2.0 对类型检查更为严格了，let var 分的很清，unused 要用_代替，好几百warning都是这个引起的，看着warning就蛋疼，改了很大一会才消除所有warning，有些方法也因此改变了：例如

func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  ==> Swift2.0

func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)    




