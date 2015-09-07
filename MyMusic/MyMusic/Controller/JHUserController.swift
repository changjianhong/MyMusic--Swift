//
//  JHUserController.swift
//  MyMusic
//
//  Created by 常健洪 on 15/9/7.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

class JHUserController: UIViewController {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBAction func sinaBtnClick(sender: AnyObject) {
   
        var request = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request.scope = "all"
       
        WeiboSDK.sendRequest(request)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

}
