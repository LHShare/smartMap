//
//  HistoryTableViewCell.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/21.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

import Foundation

class HistoryTableViewCell: UITableViewCell {
    
    var nameLabel : UILabel?
    var imgView : UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildUI() {
        //左边的imageview
        var leftImageView : UIImageView?
        leftImageView = UIImageView()
        leftImageView?.image = UIImage(named: "icon_location.png")
        leftImageView?.frame = CGRectMake(20, 16, 18, 23)
        self.addSubview(leftImageView!)
        imgView = leftImageView
        
        //namelabel
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.blackColor()
        nameLabel?.font = UIFont.systemFontOfSize(14)
        nameLabel?.frame = CGRectMake(50, 16, 200, 20)
        self.addSubview(nameLabel!)
    }
}
