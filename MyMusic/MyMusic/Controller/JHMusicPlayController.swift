//
//  JHMusicPlayController.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/22.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import pop

class JHMusicPlayController: UIViewController {
    
    @IBOutlet weak var menuViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lyric: UITextView!
    
    var currentLrcData:NSArray!
    var song:Song!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCenterUI()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(song:Song){
        
        var nibNameOrNil:String? = "JHMusicPlayController"
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType:"nib") == nil {
            
            nibNameOrNil = nil
            
        }
        self.init(nibName:nibNameOrNil, bundle:nil);
        self.song = song
    }

    @IBAction func returnBtnClick(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func moreBtnClick(sender: AnyObject) {
        menuView.hidden = false
        menuAppearAnimation()
    }
    
    @IBAction func shareBtnClick(sender: AnyObject) {
        showShareMenu(self.view, song.title)
    }
    
    @IBAction func downloadBtnClick(sender: AnyObject) {
        downloadSongMP3(self.song)
    }
    
    
    @IBAction func cancelBtnClick(sender: AnyObject) {
        menuDisappearAnimation()
    }
  
    func menuAppearAnimation(){
        var anim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        
        anim.springSpeed = 10
        anim.springBounciness = 20
        anim.toValue = NSNumber(int: 0)
        
        menuViewTopContraint.pop_addAnimation(anim, forKey: "appear")
    }
    
    func menuDisappearAnimation(){
        var anim = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        
        anim.toValue = NSNumber(int: -155)
        anim.duration = 1.0
        
        menuViewTopContraint.pop_addAnimation(anim, forKey: "disappear")
    }
    
    
    func setupCenterUI() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blureView2 = UIVisualEffectView(effect: blurEffect)
        photoImageView.addSubview(blureView2)
        blureView2.snp_makeConstraints { (make) -> Void in
            make.right.left.top.equalTo(photoImageView)
            make.height.equalTo(55)
            
        }
        let blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blureView3 = UIVisualEffectView(effect: blurEffect)
        menuView.insertSubview(blureView3, atIndex: 0)
        blureView3.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(menuView)
        }
        
        
        let blureView=UIVisualEffectView(effect: blurEffect)
        backgroundImageView.addSubview(blureView)
        blureView.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(backgroundImageView)
        }
        
        returnBtn.tintColor = UIColor.redColor()
        var image = UIImage(named: "placeholder.png")
        backgroundImageView.kf_setImageWithURL(NSURL(string: song.pic_huge)!, placeholderImage: image)
        
        photoImageView.kf_setImageWithURL(NSURL(string: song.pic_huge)!, placeholderImage: image)
        titleName.text = song.title
        authorLabel.text = song.author
        
        weak var weakSelf:JHMusicPlayController? = self
        loadLyric { (lyricStr) -> () in
            weakSelf!.lyric.text = lyricStr
        }
    }
    
    func loadLyric(succeedBlock:(String)->()) {
        weak var weakSelf:JHMusicPlayController? = self
        parseLyricWithUrl(song.lrclink, { (result) -> () in
            var lyricStr = ""
            for  lyric in result! {
                var songLyric = lyric as! SongLrc
                var lyricLine = songLyric.text as! String
                lyricStr = lyricStr.stringByAppendingString(lyricLine).stringByAppendingString("\n")
            }
            succeedBlock(lyricStr)
        })
        
    }
    
    //这个不写 会执行到JHListController中的去  可能我复制xib的原因
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("JHMusicPlayController_touchesBegan")
        
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
}
