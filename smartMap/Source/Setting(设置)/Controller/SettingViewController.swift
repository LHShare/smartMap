//
//  SettingViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//设置控制器

import Foundation

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var width : CGFloat?
    var height : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        width = self.view.frame.size.width
        height = self.view.frame.size.height
        buildUI()
    }
    
    //MARK:搭建界面
    func buildUI() {
        let bgImageView = UIImageView(image: UIImage(named: "bgImage.png"));
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
        let settingTableView = UITableView()
        settingTableView.frame = CGRectMake(0, 0, width!, height!)
        settingTableView.backgroundColor = UIColor.clearColor()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(settingTableView)
    }
    
    func showTitleForHeaderInTableView(tableSection: Int) -> String {
        var title : String?
        switch tableSection {
        case 0:
            title = "地图设置"
            /*
        case 1:
            title = "导航设置"
*/
        case 1:
            title = "消息推送"
        case 2:
            title = "检查更新"
        default:
            break
        }
        return title!
    }
    
    func showCellForTableview(cell: UITableViewCell,indexPath: NSIndexPath) {
//        if indexPath.section == 0 {
//            
//        } else if indexPath.section == 1 {
//            
//        } else if indexPath.section == 2 {
//            
//        } else if indexPath.section == 3 {
//            
//        }
        
        switch indexPath.section {
        case 0://地图设置
            if indexPath.row == 0 {//地图旋转
                cell.textLabel?.text = "隐藏路况按钮"
            } else if indexPath.row == 1 {//隐藏放大缩小按钮
                cell.textLabel?.text = "隐藏放大/缩小按钮"
            } else if indexPath.row == 2 {//隐藏转换按钮
                cell.textLabel?.text = "隐藏2d/3d按钮"
            }
            /*
        case 1://导航设置
            if indexPath.row == 0 {//
                
            } else if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                
            }*/
        case 1://消息推送
            cell.textLabel?.text = "消息推送"
            break
        case 2://检查更新
            cell.textLabel?.text = "检查更新"
            break
        default:
            break
        }
    }
    
    //MARK:tableview的代理方法和数据源方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3;
        }/* else if section == 1 {
            return 3;
        } */else if section == 1 {
            return 1;
        } else if section == 2 {
            return 1;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reusableIdentifier")
        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusableIdentifier")
            cell = SettingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reusableIdentifier")
        }
        showCellForTableview(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitle = showTitleForHeaderInTableView(section)
        return headerTitle
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(44)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2 {//检查版本更新
            
        }
    }
    
}
