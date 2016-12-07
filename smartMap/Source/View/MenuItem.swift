//
//  MenuItem.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/19.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//菜单的item

import Foundation

class MenuItem: UIButton {
    
    let imageScale : CGFloat = 0.7
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.backgroundColor = UIColor.clearColor()
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        self.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.adjustsImageWhenHighlighted = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let width = contentRect.width * imageScale
        let height = contentRect.height * imageScale
        let x = (contentRect.size.width - width) / 2
        let y : CGFloat = 0
        return CGRectMake(x, y, width, height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let x : CGFloat = 0
        let y : CGFloat = contentRect.height * imageScale
        let width = contentRect.width
        let height = contentRect.height * (1-imageScale)
        return CGRectMake(x, y, width, height)
    }
}

