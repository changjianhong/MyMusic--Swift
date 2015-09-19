//
//  JHMusciListCell.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/22.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit
import Kingfisher

/**
*  cell 上点击事件
*/
protocol JHMusicListCellProtocol{
    func musicListCellClick(type:JHMusicListCellClickType, indexPath:NSIndexPath, isSelected:Bool)
}

enum JHMusicListCellClickType{
    case Switch
    case More
}

class JHMusciListCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var title2HQ: NSLayoutConstraint!
    var clickNum:Int = 0
    var indexPath:NSIndexPath?
    var song:Song?
    var delegate:JHMusicListCellProtocol?
    
    var selectedOrNil:Bool {
        set(newValue){
            switchBtn.selected = newValue
        }
        get{
            return switchBtn.selected
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius  = 2
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth   = 0.2
        iconImageView.layer.borderColor   = UIColor.blackColor().CGColor
        songTitle.textColor               = kUIColorFromRGB(0x969595)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
  
    
    func setupViewsWithData(song:Song, isSelected:Bool, indexPath:NSIndexPath){
        
        self.song = song
        
        let iconUrl = NSURL(string: song.pic_small)!
        iconImageView.kf_setImageWithURL(iconUrl, placeholderImage: nil)

        authorLabel.text = parseString(song.author)
        songTitle.text = parseString(song.title)
        
        if song.has_mv_mobile == 0 {
            logoImageView.hidden = true
            title2HQ.constant = 2
        } else {
            logoImageView.hidden = false
            title2HQ.constant = 22
        }
        
        if clickNum % 2 == 0 {
            switchBtn.selected = false
        }else {
            switchBtn.selected = isSelected
        }
        
        self.indexPath = indexPath
    }
    
    
    
    @IBAction func switchBtnClick(sender: UIButton) {
        
        playBtnClick(true)
        
    }
    
    
    func playBtnClick(isPlaying:Bool) {
        clickNum = clickNum + 1
        
        switchBtn.selected = !switchBtn.selected
        
        if isPlaying {
           delegate?.musicListCellClick(JHMusicListCellClickType.Switch, indexPath: self.indexPath!, isSelected: switchBtn.selected)
        }
    }
    
    
    @IBAction func moreAction(sender: UIButton) {
//        delegate?.musicListCellClick(JHMusicListCellClickType.More, indexPath: self.indexPath!, isNext: false)
    }
}
