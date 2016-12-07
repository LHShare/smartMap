//
//  MyButton.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/17.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//自定义按钮，更改image和title的位置

import Foundation

class CameraDegreeButton: UIButton {
    
    let imageWidthScale : CGFloat = 0.2
    let imageHeightScale : CGFloat = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.adjustsImageWhenHighlighted = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let x : CGFloat = contentRect.size.width * imageWidthScale
        let imageHeight : CGFloat = contentRect.size.height * imageHeightScale
        let imageWidth : CGFloat = imageHeight
        let y : CGFloat = (contentRect.size.height - imageHeight) / 2
        return CGRectMake(x, y, imageWidth, imageHeight)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        let x : CGFloat = contentRect.size.width * 0.4
        let y : CGFloat = 1
        let width : CGFloat = contentRect.size.width * 0.5
        let height : CGFloat = contentRect.size.height * 0.9
        return CGRectMake(x, y, width, height)
    }
    /*
    btn1.setImage(UIImage(named: "normalCircle.png"), forState: UIControlState.Normal)
    btn1.setImage(UIImage(named: "selectedCircle.png"), forState: UIControlState.Selected)
    btn1.setTitle("2D视角", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    btn1.titleLabel?.font = UIFont.systemFontOfSize(13)
    btn1.adjustsImageWhenHighlighted = false
    btn1.frame = CGRectMake(5, CGRectGetMaxY(lineView1.frame), CGRectGetWidth(lineView1.frame) / 2, 40)
    btn1.addTarget(self, action: "changeMapCameraDegree:", forControlEvents: UIControlEvents.TouchUpInside)
    */
    
    func initButtonData(frame: CGRect, normalImage: NSString, selectedImage: NSString, title: NSString) {
        self.frame = frame
        self.setImage(UIImage(named: normalImage as String), forState: UIControlState.Normal)
        self.setImage(UIImage(named: selectedImage as String), forState: UIControlState.Selected)
        self.setTitle(title as String, forState: UIControlState.Normal)
        
    }
}

