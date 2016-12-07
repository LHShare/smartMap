//
//  SearchTableViewCell.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/21.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//高度54

import Foundation

class SearchTableViewCell: UITableViewCell {
    
    var nameLabel : UILabel?
    var detailLabel : UILabel?
    
    var model : SearchModel? {
        willSet {
            
        }
        didSet {
            nameLabel?.text = model?.name
            detailLabel?.text = model?.district
        }
    }
    
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
        leftImageView?.frame = CGRectMake(13, 16, 18, 23)
        self.addSubview(leftImageView!)
        
        //namelabel
        nameLabel = UILabel()
        nameLabel?.textColor = UIColor.blackColor()
        nameLabel?.font = UIFont.systemFontOfSize(14)
        nameLabel?.frame = CGRectMake(44, 10, 200, 20)
        self.addSubview(nameLabel!)
        
        //detaillabel
        detailLabel = UILabel()
        detailLabel?.textColor = UIColor.lightGrayColor()
        detailLabel?.font = UIFont.systemFontOfSize(12)
        detailLabel?.frame = CGRectMake(44, CGRectGetMaxY((nameLabel?.frame)!), self.frame.size.width - 50, 20)
        self.addSubview(detailLabel!)
        
        //右边的iamgeview
        var rightImageView : UIImageView?
        rightImageView = UIImageView()
        rightImageView?.image = UIImage(named: "icon_goto.png")
        rightImageView?.frame = CGRectMake(CGRectGetMaxX((detailLabel?.frame)!), 16, 18, 23)
        self.addSubview(rightImageView!)
    }
}
