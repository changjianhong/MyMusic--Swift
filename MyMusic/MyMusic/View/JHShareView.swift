//
//  JHShareView.swift
//  MyMusic
//
//  Created by 常健洪 on 15/9/9.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import pop

enum JHShareViewPlatformType{
    case QQ
    case QZone
    case WechatSession
    case WechatTimeline
    case SinaWeibo
}

protocol JHShareViewDelegate {
    func shareViewBtnClick(index:Int)
}

let _sharedInstance = NSBundle.mainBundle().loadNibNamed("JHShareView", owner: nil, options: nil).first as! JHShareView
let kHeight:CGFloat = 130

class JHShareView: UIView {

    class var sharedInstance:JHShareView {
        return _sharedInstance
    }
    
    private var isShowing:Bool = false
    var delegate:JHShareViewDelegate?
    private var bgView:UIView!
    
    override func awakeFromNib() {
        
    }

    override func didMoveToSuperview() {
        
    }
    
    @IBAction func shareBtnClick(sender: UIButton) {
        
        println(sender.tag)
        
        if let d = delegate {
            d.shareViewBtnClick(sender.tag)
        }
    }
    @IBAction func cancelBtnClick(sender: UIButton) {
        
    }
    
    
    func showInView(view:UIView){
        self.bgView = UIView(frame: view.bounds)
        self.isShowing = true
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kHeight)
        view.addSubview(self)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(0, kScreenHeight - kHeight, kScreenWidth, kHeight)
            }) { (completion) -> Void in
                
        }
    }
    
    class func showInView(view:UIView, delegate:JHShareViewDelegate) {
        
        var shareView = JHShareView.sharedInstance
        shareView.delegate = delegate
        
        if !shareView.isShowing {
            shareView.showInView(view)
        }
        
    }
    
    
}
