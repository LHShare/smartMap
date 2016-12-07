//
//  AboutViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//关于控制器

import Foundation

class AboutViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于smartMap"
        let width = self.view.frame.size.width
        
        let bgImage = UIImageView(image: UIImage(named: "bgImage.png"))
        bgImage.frame = self.view.frame
        self.view.addSubview(bgImage)
        
        let bgView1 = UIView()
        bgView1.frame = CGRectMake(5, 5, width - 10, 350)
        bgView1.backgroundColor = UIColor.lightGrayColor()
        bgView1.layer.masksToBounds = true
        bgView1.layer.cornerRadius = 5
        bgImage.addSubview(bgView1)
        let bgView2 = UIView()
        bgView2.frame = CGRectMake(6, 6, width - 12, 348)
        bgView2.backgroundColor = UIColor.whiteColor()
        bgView2.layer.masksToBounds = true
        bgView2.layer.cornerRadius = 5
        bgImage.addSubview(bgView2)
        
        let icon = UIImageView(image: UIImage(named: "icon.png"))
        icon.center = CGPointMake(width / 2, 70)
        icon.bounds = CGRectMake(0, 0, 60, 60)
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 5
        bgView2.addSubview(icon)

        
        let label1 = UILabel()
        label1.text = "当前版本1.0.0"
        label1.textAlignment = NSTextAlignment.Center
        label1.textColor = UIColor.darkTextColor()
        label1.font = UIFont.systemFontOfSize(14)
        label1.center = CGPointMake(width / 2, CGRectGetMaxY(icon.frame) + 20)
        label1.bounds = CGRectMake(0, 0, 200, 24)
        bgView2.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = "开发人：刘欢";
        label2.textAlignment = NSTextAlignment.Center
        label2.textColor = UIColor.darkTextColor()
        label2.font = UIFont.systemFontOfSize(14)
        label2.center = CGPointMake(width / 2, CGRectGetMaxY(label1.frame) + 44)
        label2.bounds = CGRectMake(0, 0, width - 40, 44)
        label2.numberOfLines = 0
        bgView2.addSubview(label2)
        
        let label3 = UILabel()
        label3.text = "电话：18832263638";
        label3.textAlignment = NSTextAlignment.Center
        label3.textColor = UIColor.darkTextColor()
        label3.font = UIFont.systemFontOfSize(14)
        label3.center = CGPointMake(width / 2, CGRectGetMaxY(label2.frame) + 10)
        label3.bounds = CGRectMake(0, 0, width - 40, 44)
        label3.numberOfLines = 0
        bgView2.addSubview(label3)
        
        let label4 = UILabel()
        label4.text = "邮箱：1395546362@qq.com";
        label4.textAlignment = NSTextAlignment.Center
        label4.textColor = UIColor.darkTextColor()
        label4.font = UIFont.systemFontOfSize(14)
        label4.center = CGPointMake(width / 2, CGRectGetMaxY(label3.frame) + 10)
        label4.bounds = CGRectMake(0, 0, width - 40, 44)
        label4.numberOfLines = 0
        bgView2.addSubview(label4)
        
        let label5 = UILabel()
        label5.text = "注：本软件为毕业设计作品，未经本人允许，不得用作其他用途";
        label5.textAlignment = NSTextAlignment.Center
        label5.textColor = UIColor.darkTextColor()
        label5.font = UIFont.systemFontOfSize(14)
        label5.center = CGPointMake(width / 2, CGRectGetMaxY(label4.frame) + 15)
        label5.bounds = CGRectMake(0, 0, width - 40, 44)
        label5.numberOfLines = 0
        bgView2.addSubview(label5)
        
        let label6 = UILabel()
        label6.text = "刘欢 版权所有"
        label6.textAlignment = NSTextAlignment.Center
        label6.textColor = UIColor.lightGrayColor()
        label6.font = UIFont.systemFontOfSize(10)
        label6.center = CGPointMake(width / 2, self.view.frame.size.height - 30)
        label6.bounds = CGRectMake(0, 0, 200, 15)
        self.view.addSubview(label6)
    }
}
