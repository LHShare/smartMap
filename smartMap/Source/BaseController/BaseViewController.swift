//
//  BaseViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/17.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//所有控制器的父类

import Foundation

class BaseViewController: UIViewController {
    var showSearchBar : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector("setEdgesForExtendedLayout:") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
//        self.navigationController?.navigationBar.alpha = 0
        let backBtn = UIButton(frame: CGRectMake(0, 0, 10, 17))
        backBtn.setBackgroundImage(UIImage(named: "btn_back.png"), forState: UIControlState.Normal)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.addTarget(self, action: "backBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtn
        showSearchBar = false
    }
    
    //MARK:返回按钮的点击事件
    func backBtnClick() {
        self.navigationController?.popViewControllerAnimated(false)
    }
}
