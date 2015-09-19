//
//  JHNativeSongView.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/28.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

class JHNativeSongView: UIView,UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataView: UILabel!
   
   
    let identifier = "JHNativeCell"
    
    var songs:NSArray = NSArray()
    
    var songsFunc:NSArray!{
        set(newValue) {
            songs = newValue
            if newValue.count == 0 {
                noDataView.hidden = false
            }else {
                noDataView.hidden = true
            }
            self.tableView.reloadData()
        }
        get {
            return self.songs
        }
    }
    
    override func awakeFromNib() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.rowHeight = 44
        self.tableView.allowsSelection = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? JHNativeCell
        if cell == nil {
            
            let rightUtilityButtons = NSMutableArray()
            rightUtilityButtons.addUtilityButtonWithColor(UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1.0), title: "置顶")
            rightUtilityButtons.addUtilityButtonWithColor(UIColor(red: 1.0, green: 0.231, blue: 0.188, alpha: 1.0), title: "删除")
            
            cell = JHNativeCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier, containingTableView: self.tableView, leftUtilityButtons: nil, rightUtilityButtons: rightUtilityButtons as [AnyObject])
            
            cell?.delegate = self
        }
        let song = songs[indexPath.row] as! Song
        
        cell?.song = song
//        cell?.textLabel?.text = song.title
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath \(indexPath.row)")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("scroll view did begin dragging")
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // Set background color of cell here if you don't want white
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK:- SWTableViewCellDelegate
    
    func swippableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        let songList = NSMutableArray(array: songs)
        let nativeCell = cell as! JHNativeCell
        let selectedIndex = self.tableView.indexPathForCell(nativeCell)
        let song = songs[selectedIndex!.row] as! Song
        
        print(selectedIndex?.row)
        
        switch index {
        case 0:
            print("置顶")
            songList.removeObjectAtIndex(selectedIndex!.row)
            songList.insertObject(song, atIndex: 0)
            songs = songList
            self.tableView.reloadData()
            break
        case 1:
            print("删除")
            deleteNativeSong(song.title)
            songList.removeObjectAtIndex(selectedIndex!.row)
            songs = songList
            self.tableView.deleteRowsAtIndexPaths([selectedIndex!], withRowAnimation: UITableViewRowAnimation.Fade)
            break
        default:
            break
        }
    }
    
    
    
    
}
