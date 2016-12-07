//
//  MenuView.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/19.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//菜单view

import Foundation

class MenuView: UIView {
    
    var itemsArray : NSMutableArray?
    let MenuItemImageHeight : CGFloat = 90
    let MenuItemTitleHeight : CGFloat = 20
    let MenuItemHorizontalMargin : CGFloat = 10
    let MenuItemVerticalPadding : CGFloat = 10
    let MenuItemAnimationTime : CGFloat = 0.36
    let MenuItemViewAnimationInterval : CGFloat = 0.072
    let MenuItemRriseAnimationID = "MenuItemRriseAnimationID"
    var myBlock = {() in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 47/255.0, green: 61/255.0, blue: 86/255.0, alpha: 1)
        itemsArray = NSMutableArray()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addMenuItem(title: NSString, imageName: NSString, block: () -> ()) {
        let menuItem : MenuItem?
        menuItem = MenuItem()
        menuItem?.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        menuItem?.setTitle(title as String, forState: UIControlState.Normal)
        menuItem?.addTarget(self, action: "menuItemClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(menuItem!)
        itemsArray?.addObject(menuItem!)
        myBlock = block
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for var i = 0; i < itemsArray?.count; i++ {
            let menuItem = itemsArray?.objectAtIndex(i) as? MenuItem
            menuItem?.frame = frameForButtonAtIndex(CGFloat(i))
        }
    }
    
    func menuItemClick(block: () -> ()) {
        myBlock()
    }
    
    func frameForButtonAtIndex(index: CGFloat) -> CGRect {
        //列数
        let columnCount : CGFloat = 3
        //第几列
        let columnIndex : CGFloat = index % columnCount
        //行数
        let rowCount : CGFloat = CGFloat((itemsArray?.count)!) / columnCount + (CGFloat((itemsArray?.count)!) % columnCount > 0 ? 1 : 0)
        //第几行
        let rowIndex :CGFloat = index / columnCount
        
        let itemHeight :CGFloat = (MenuItemImageHeight + MenuItemTitleHeight) * rowCount + (rowCount > 1 ? (rowCount - 1) * MenuItemHorizontalMargin : 0)
        var offsetY : CGFloat = (CGFloat(self.frame.size.height) - CGFloat(itemHeight)) / 2
        let verticalPadding : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(MenuItemHorizontalMargin * 2) - CGFloat(MenuItemImageHeight * 3)) / 2.0
        
        var offsetX : CGFloat = CGFloat(MenuItemHorizontalMargin)
        offsetX = CGFloat(offsetX + (CGFloat(MenuItemImageHeight) + CGFloat(verticalPadding)) * CGFloat(columnIndex))
        offsetY = offsetY + (CGFloat(MenuItemImageHeight) + CGFloat(MenuItemTitleHeight) + CGFloat(MenuItemVerticalPadding)) * CGFloat(rowIndex)
        
        return CGRectMake(offsetX, offsetY, MenuItemImageHeight, MenuItemImageHeight + MenuItemTitleHeight)
    }
    
    func show() {
        let appRootViewController : UIViewController
        let window : UIWindow?
        window = UIApplication.sharedApplication().keyWindow
        appRootViewController = (window?.rootViewController)!
        let topViewController : UIViewController?
        topViewController = appRootViewController
        self.frame = (topViewController?.view.bounds)!
        topViewController?.view.addSubview(self)
        
        riseAnimation()
        
    }
    
    func riseAnimation() {
        let columnCount = 3
        let rowCount = (itemsArray?.count)! / columnCount + ((itemsArray?.count)! % columnCount > 0 ? 1 : 0)
        
        for var i = 0; i < itemsArray?.count; i++ {
            let menuItem : MenuItem?
            menuItem = itemsArray?.objectAtIndex(i) as? MenuItem
            menuItem?.layer.opacity = 0
            let frame : CGRect?
            frame = frameForButtonAtIndex(CGFloat(i))
            let rowIndex = i / columnCount
            let columnIndex = i % columnCount
            let fromPosition : CGPoint?
            fromPosition = CGPointMake((frame?.origin.x)! + MenuItemImageHeight / 2.0, (frame?.origin.y)! + (MenuItemImageHeight + MenuItemTitleHeight) / 2.0 + (CGFloat(rowCount) - CGFloat(rowIndex) + 2) * 200)
            let toPosition : CGPoint?
            toPosition = CGPointMake((frame?.origin.x)! + MenuItemImageHeight / 2.0, (frame?.origin.y)! + (MenuItemImageHeight + MenuItemTitleHeight) / 2.0)
            
            var delayInSeconds : Double
            delayInSeconds = Double(Double(rowIndex) * Double(columnCount) * Double(MenuItemViewAnimationInterval))
            if columnIndex == 0 {
                delayInSeconds = delayInSeconds + Double(MenuItemViewAnimationInterval)
            } else if columnIndex == 2 {
                delayInSeconds = delayInSeconds + Double(MenuItemViewAnimationInterval * 2)
            }
            
            let positionAnimation : CABasicAnimation
            
            positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = NSValue(CGPoint: fromPosition!)
            positionAnimation.toValue = NSValue(CGPoint: toPosition!)
            positionAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.45, 1.2, 0.75, 1.0)
            positionAnimation.duration = Double(MenuItemAnimationTime)
            positionAnimation.beginTime = (menuItem?.layer.convertTime(CACurrentMediaTime(), fromLayer: nil))! + delayInSeconds
            positionAnimation.setValue(NSNumber(integer: Int(i)), forKey: MenuItemRriseAnimationID)
            positionAnimation.delegate = self
            menuItem?.layer.addAnimation(positionAnimation, forKey: "riseAnimation")
            
        }
        
    }
}

