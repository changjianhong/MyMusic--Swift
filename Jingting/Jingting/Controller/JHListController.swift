//
//  JHListController.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/21.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import LiquidFloatingActionButton
import pop

class JHListController: UIViewController,ServiceProtocol,UITableViewDelegate,UITableViewDataSource,JHMusicListCellProtocol,SongPlayDelegate,LiquidFloatingActionButtonDelegate,LiquidFloatingActionButtonDataSource,UIScrollViewDelegate {

    @IBOutlet var nativeSongListView: JHNativeSongView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var musicProgress: UIProgressView!

    weak var progress: UIProgressView!
    var selectedIndex:Int?
    var returnOrNot:Bool?
    var audioPlay = SongPlay.shareInstance()
    var currentLrcData:NSArray!
    let identifier = "JHMusicListCell"
    var timer:NSTimer?
    var service:JHBaseService!
    lazy var songList = NSArray()
    //  歌词
    var touchBeginPoint:CGPoint!
    @IBOutlet var lyricView: UIView!
    @IBOutlet weak var thirdLyric: UILabel!
    @IBOutlet weak var nextLyric: UILabel!
    @IBOutlet weak var currentLyric: UILabel!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    @IBOutlet weak var leftContraint: NSLayoutConstraint!
    //  刷新
    var refreshControl:UIRefreshControl!
    var isfreshing:Bool = false
    //  本地
    var nativeSongs:NSArray!
    var nativeIndex = 0
    //  按钮
    var floatingActionButton:LiquidFloatingActionButton!
    var cells: [LiquidFloatingCell] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        initData()
        setupCenterUI()
        loadData()
    }
    
    func initData() {
        //网络请求
        let service = JHBaseService()
        self.service = service
        service.delegate = self
        
        self.audioPlay.delegate = self
    
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        } catch {
            
        }
        
        
        self.tableView.registerNib(UINib(nibName: "JHMusciListCell", bundle:nil), forCellReuseIdentifier: identifier)
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            return LiquidFloatingCell(icon: UIImage(named: iconName)!)
        }
        
        cells.append(cellFactory("ic_brush_black_24dp_2x"))
        cells.append(cellFactory("list_icon_music_book"))
        cells.append(cellFactory("detail_btn_download"))
        cells.append(cellFactory("ic_color_lens_black_24dp_2x"))
    }
    
    func setupCenterUI(){
        
        self.view.insertSubview(nativeSongListView, atIndex: 2)
        nativeSongListView.snp_makeConstraints { (make) -> Void in
            make.bottom.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(22)
            make.right.equalTo(self.view)
        }
        nativeSongListView.alpha = 0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "并没什么卵用")
        self.tableView.addSubview(refreshControl)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        //##########
        let floatingFrame = CGRect(x: kScreenWidth - 46 - 16, y: kScreenHeight - 46 - 16, width: 46, height: 46)
        print(kScreenWidth,kScreenHeight)
        floatingActionButton = LiquidFloatingActionButton(frame: floatingFrame)
        self.view.addSubview(floatingActionButton)

        floatingActionButton.color = UIColor.grayColor()
        floatingActionButton.delegate = self
        floatingActionButton.dataSource = self
        
        let height:CGFloat = 3
        let width:CGFloat = (kScreenHeight - 20)
        let y:CGFloat = 20 + width / 2
        let x:CGFloat = kScreenWidth - width / 2 - 1
        let progress = UIProgressView(frame: CGRectMake(x, y, width, height))
        progress.tintColor = UIColor.redColor()
        self.view.addSubview(progress)
        self.progress = progress
        self.progress.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 * 3))
        
    }
    
    func refreshData(){
        print("refreshData")
        NSThread.sleepForTimeInterval(2)
        refreshControl.endRefreshing()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if isfreshing { return }
        
        if scrollView == self.tableView {
            
            if scrollView.contentOffset.y + kScreenHeight - 22 >= scrollView.contentSize.height - 50 {
                isfreshing = true
                service.getSongList(kMusicListURL)
            }
        }
    }
    
    
    func loadData() {
        service.getSongList(kMusicListURL)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(){
        
        var nibNameOrNil:String? = "JHListController"
        
        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType:"nib") == nil {
            
            nibNameOrNil = nil
            
        }
        self.init(nibName:nibNameOrNil, bundle:nil);
    }
    
    
    /**
    service Delegate
    
    :param: result
    */
    func didRecieveResults(result: AnyObject) {
        
        if refreshControl.refreshing {
            refreshControl.endRefreshing()
        }
        isfreshing = false
        let songlist = result as! NSArray
        songList = songlist
        self.audioPlay.songList = songList
        self.audioPlay.currentSong = songList[0] as! Song
        tableView.reloadData()
    }
    
    
    /**
    *  UITableViewDataSource UITableViewDelegate
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? JHMusciListCell
        
        if cell == nil {
            cell = JHMusciListCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        let song = songList[indexPath.row] as! Song
        cell?.delegate = self
        cell?.setupViewsWithData(song, isSelected: selectedIndex == indexPath.row, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let song = songList[indexPath.row] as! Song
        
        let vc = JHMusicPlayController(song: song)
        
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            return 54
        }
        
        return 44
    }
    
    
    func songPlayBackDidFinish(palyResource: SongPlayResource) {
        
        if palyResource == SongPlayResource.Online {
            let currentIndexPath = NSIndexPath(forRow: selectedIndex!, inSection: 0)
            let currentCell = self.tableView.cellForRowAtIndexPath(currentIndexPath) as! JHMusciListCell
            currentCell.playBtnClick(false)

            let nextIndexPath = NSIndexPath(forRow: selectedIndex! + 1, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(nextIndexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            
            // 延迟1秒执行
            weak var weakSelf:JHListController? = self
            let delayInSeconds:Int64 = 1
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
//                weakSelf!.musicListCellClick(JHMusicListCellClickType.Switch, indexPath: indexPath, isSelected: true)
                
                let nextCell = weakSelf!.tableView.cellForRowAtIndexPath(nextIndexPath) as! JHMusciListCell
                nextCell.playBtnClick(true)
                
            }
        } else if palyResource == SongPlayResource.Native {
            playNativeSong()
        }
        print("songPlayBackDidFinish")
    }
    

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan")
        for touch in touches {
            let t = touch 
            touchBeginPoint = t.locationInView(lyricView)
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let t = touch
            let point = t.locationInView(lyricView)
            topContraint.constant = topContraint.constant + (point.y - touchBeginPoint.y)
            leftContraint.constant = leftContraint.constant + (point.x - touchBeginPoint.x)
        }
    }
  
    ///JHMusicListCellProtocol
    func musicListCellClick(type:JHMusicListCellClickType, indexPath:NSIndexPath, isSelected:Bool) {
        
        let song = songList[indexPath.row] as! Song
        if type == JHMusicListCellClickType.Switch {
            if indexPath.row != selectedIndex {
                
            }
            if !isSelected{
                self.audioPlay.songPause()
            } else {
                weak var weakSelf:JHListController? = self
                weakSelf!.audioPlay.songBegin(song, playSucceed: { () -> () in
                    parseLyricWithUrl(song.lrclink, succeed: { (result) -> () in
                        weakSelf?.currentLrcData = result
                    })
                }, playFail: { () -> () in
                    print("playFail")
                    weakSelf!.songPlayBackDidFinish(SongPlayResource.Online)
                })
                selectedIndex = indexPath.row
            }
        } else if type == JHMusicListCellClickType.More {
            print("More")
        }
        self.tableView.reloadData()
    }
    
    
    //更新歌词
    func updateTime(){
        let c = audioPlay.currentTime
        if c > 0.0  {
            let t=self.audioPlay.duration
            let p:CFloat=CFloat(c/t)
            self.progress.progress = p
            self.musicProgress.progress = p
            if currentLrcData != nil {
                let predicate:NSPredicate = NSPredicate(format: "total = %d", Int(c))
                let lrcData = currentLrcData!.filteredArrayUsingPredicate(predicate)
                if lrcData.count > 0 {
                    let lrcLine:SongLrc = lrcData.last as! SongLrc
                    currentLyric.text = lrcLine.text as String
                    let currentIndex = currentLrcData.indexOfObject(lrcLine)
                    if currentIndex > currentLrcData.count - 3 { return }
                    let nextLine = currentLrcData[currentIndex + 1] as! SongLrc
                    nextLyric.text = nextLine.text as String
                    let thirdLine = currentLrcData[currentIndex + 2] as! SongLrc
                    thirdLyric.text = thirdLine.text as String
                }
            }

        }
    }
    
    
    func playNativeSong() {
        
        nativeSongs = getNativeSongList()
        if (nativeSongs != nil) {
            if nativeSongs?.count > nativeIndex {
                let song = nativeSongs!.objectAtIndex(nativeIndex) as! Song
                self.audioPlay.nativeSongPlay(song)
                
                if selectedIndex >= 0 {
                    let currentIndexPath = NSIndexPath(forRow: selectedIndex!, inSection: 0)
                    let currentCell = self.tableView.cellForRowAtIndexPath(currentIndexPath) as! JHMusciListCell
                    currentCell.playBtnClick(false)
                    selectedIndex = -1
                }
                
                weak var weakSelf:JHListController? = self
                parseLyricWithUrl(song.lrclink, succeed: { (result) -> () in
                    weakSelf?.currentLrcData = result
                })
                nativeIndex++
            }
        }
    }
    
    
    func nativeSongsList() {
        
        if nativeSongListView.alpha != 0 {return}
    
        nativeSongs = getNativeSongList()
        nativeSongListView.songsFunc = nativeSongs
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        anim.fromValue = NSNumber(int: 0)
        anim.duration = 1.0
        anim.toValue = NSNumber(int: 1)
        nativeSongListView.pop_addAnimation(anim, forKey: "insert")
    
    
    }
    
    func onLineSongsList() {
        
        if nativeSongListView.alpha == 0 {return}
        
        let anim = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.duration = 1.0
        anim.fromValue = NSNumber(int: 1)
        anim.toValue = NSNumber(int: 0)
        
        nativeSongListView.pop_addAnimation(anim, forKey: "removed")
    }
 
    /**
    *  LiquidFloatingActionButton
    */
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        
        return cells[index]
        
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        
        switch index {
        case 0:
            let userController = JHUserController(nibName: "JHUserController", bundle: nil)
            self.navigationController?.pushViewController(userController, animated: true)

            break
        case 1:
            onLineSongsList()
            break
        case 2:
            nativeSongsList()
            break
        case 3:
            playNativeSong()
            break
        default:
            break
        }
        
        floatingActionButton.close()
    }
    
}



