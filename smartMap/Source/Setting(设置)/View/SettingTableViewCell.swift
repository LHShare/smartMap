//
//  SettingTableViewCell.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/27.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

import Foundation

class SettingTableViewCell: UITableViewCell {
    
    var switchUI : UISwitch?
    let lockUpMapRotate = "lockUpMapRotate"
    let hideBigAndSmallButton = "hideBigAndSmallButton"
    let hide2dAnd3dButton = "hide2dAnd3dButton"
    
    let showLockUpMapRotate = "noLockUpMapRotate"
    let showBigAndSmallButton = "showBigAndSmallButton"
    let show2dAnd3dButton = "show2dAnd3dButton"
    
    var settingDict : NSMutableDictionary?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        switchUI = UISwitch()
        switchUI!.frame = CGRectMake(self.frame.size.width - 70, 5, 0, 0);
        switchUI?.addTarget(self, action: "switchUIValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(switchUI!)
        self.backgroundView = UIImageView(image: UIImage(named: "bg_check_btn_item.png"))
        self.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_check_btn_item.png"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchUIValueChanged(switchUI: UISwitch) {
        if self.textLabel?.text == "锁定地图旋转" {
            if switchUI.on {//隐藏
                self.postNotificationWithName(lockUpMapRotate)
            } else {
                self.postNotificationWithName(showLockUpMapRotate)
            }
        } else if self.textLabel?.text == "隐藏放大/缩小按钮" {
            if switchUI.on {
                self.postNotificationWithName(hideBigAndSmallButton)
            } else {
                self.postNotificationWithName(showBigAndSmallButton)
            }
        } else if self.textLabel?.text == "隐藏2d/3d按钮" {
            if switchUI.on {
                self.postNotificationWithName(hide2dAnd3dButton)
            } else {
                self.postNotificationWithName(show2dAnd3dButton)
            }
        } else if self.textLabel?.text == "消息推送" {
            
        }
    }
    
    func postNotificationWithName(name : String) {
        let notification = NSNotification(name: name, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    
}
