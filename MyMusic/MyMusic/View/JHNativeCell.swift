//
//  JHNativeCell.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/30.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

class JHNativeCell: SWTableViewCell {

    
    var song:Song!{
        didSet{
            self.bindDataWithView()
        }
    }
    
    var iconImage: UIImageView!
    var nativeSign: UILabel!
    var author: UILabel!
    var title: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!, containingTableView: UITableView!, leftUtilityButtons: [AnyObject]!, rightUtilityButtons: [AnyObject]!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, containingTableView: containingTableView, leftUtilityButtons: leftUtilityButtons, rightUtilityButtons: rightUtilityButtons)
        
        createCenterUI()
        setupCenterUI()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCenterUI(){
        iconImage  = UIImageView()
        nativeSign = UILabel()
        nativeSign.text = "本地"
        author     = UILabel()
        title      = UILabel()
        self.contentView.addSubview(iconImage)
        self.contentView.addSubview(nativeSign)
        self.contentView.addSubview(author)
        self.contentView.addSubview(title)
        
        autoLayoutSubviews()
    }
    
    
    func autoLayoutSubviews() {
        iconImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView).offset(3)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.left.equalTo(self.contentView)
            make.width.equalTo(iconImage.snp_height)
        }
        
        author.snp_makeConstraints { (make) -> Void in
            make.top.right.equalTo(self.contentView)
            make.left.equalTo(iconImage.snp_right).offset(8)
            make.height.equalTo(21)
        }
        
        nativeSign.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(10)
            make.width.equalTo(19)
            make.top.equalTo(author.snp_bottom).offset(6)
            make.left.equalTo(iconImage.snp_right).offset(8)
        }
        
        title.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nativeSign.snp_right).offset(8)
            make.right.equalTo(self.contentView).offset(-8)
            make.top.equalTo(author.snp_bottom).offset(1)
            make.height.equalTo(21)
        }
    }
    
    func setupCenterUI() {
        iconImage.layer.cornerRadius = 18
        iconImage.layer.masksToBounds = true
        title.textColor               = kUIColorFromRGB(0x969595)
        title.font = UIFont.systemFontOfSize(10)
        nativeSign.layer.borderWidth   = 0.5
        nativeSign.layer.borderColor   = UIColor.blackColor().CGColor
        nativeSign.font = UIFont.systemFontOfSize(9)
        author.font = UIFont.systemFontOfSize(10)
        iconImage.layer.borderWidth   = 2
        iconImage.layer.borderColor   = UIColor.redColor().CGColor
        
    }
    
    
    
    
    func bindDataWithView() {
        iconImage.kf_setImageWithURL(NSURL(string: song.pic_small)!)
        author.text = song.author
        title.text = song.title
    }
    
    
}
