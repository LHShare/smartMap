//
//  SuggestViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//意见反馈控制器

import Foundation

class SuggestViewController: BaseViewController {
    
    var textView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        buildUI()
        let navigationController : NavigationViewController?
        navigationController = NavigationViewController()
        self.navigationController?.pushViewController(navigationController!, animated: false)

    }
    
    //MARK:创建界面
    func buildUI() {
        let width = self.view.frame.size.width;
        let bgView = UIView()
        bgView.backgroundColor = UIColor.lightGrayColor()
        bgView.frame = CGRectMake(8, 70, width - 16, 180)
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 5
        self.view.addSubview(bgView)
        
        textView = UITextView()
        textView?.frame = CGRectMake(9, 71, width - 18, 178)
        textView?.text = "勇敢说出你的想法吧～";
        textView?.textColor = UIColor.lightGrayColor()
        textView?.font = UIFont.systemFontOfSize(14)
        textView?.layer.masksToBounds = true
        textView?.layer.cornerRadius = 5
        self.view.addSubview(textView!)
        
        let commitBtn = UIButton(type: UIButtonType.Custom)
        commitBtn.setBackgroundImage(UIImage(named: "bg_btn_login.png"), forState: UIControlState.Normal)
        commitBtn.frame = CGRectMake(8, CGRectGetMaxY(bgView.frame) + 20, width - 16, 30)
        commitBtn.setTitle("提交", forState: UIControlState.Normal)
        commitBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        commitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commitBtn.addTarget(self, action: "commitBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        commitBtn.adjustsImageWhenHighlighted = false
        self.view.addSubview(commitBtn)
    }
    
    func commitBtnClick() {
        
    }
}
