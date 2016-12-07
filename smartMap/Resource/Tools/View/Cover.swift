//
//  Cover.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/3/19.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class Cover: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 0.6
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func creageCover(target : AnyObject,action : Selector) -> Cover {
        let cover = Cover()
        cover.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        return cover
    }
}
