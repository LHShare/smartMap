//
//  SpeakViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/17.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//语音输入控制器

import Foundation

class SpeakViewController : BaseViewController,IFlyRecognizerViewDelegate {
    
    var width : CGFloat?
    var height : CGFloat?
    var sprakResultBlock = {(locationName : String) in}
    
    //讯飞语音识别语音控件
    var iflyRecognizerView : IFlyRecognizerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语音搜索"
        //初始化数据
        initData()
        //创建界面
        buildUI()
        //初始化讯飞识别会话的服务代理
        initIFlyReconginzerView()
    }
    
    //初始化讯飞会话识别控件
    func initIFlyReconginzerView() {
        iflyRecognizerView = IFlyRecognizerView(center: self.view.center)
        iflyRecognizerView?.delegate = self
        iflyRecognizerView?.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        //asr_audio_path保存录音文件名，如果不需要，设置为nil表示取消，默认目录是documents
        iflyRecognizerView?.setParameter(nil, forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
    }
    
    //MARK:初始化数据
    func initData() {
        width = self.view.bounds.width
        height = self.view.bounds.height
    }
    
    
    
    func buildUI() {
        creatLabel(CGRectMake(50, 100, width! - 100, 44), fontSize: 19, color: UIColor.blackColor(), text: "请说话...")
        creatLabel(CGRectMake(50, 150, width! - 100, 44), fontSize: 14, color: UIColor.blueColor(), text: "您可以这样说:")
        creatLabel(CGRectMake(50, 200, width! - 100, 44), fontSize: 14, color: UIColor.blackColor(), text: "“北京天安门广场”")
        creatLabel(CGRectMake(50, 230, width! - 100, 44), fontSize: 14, color: UIColor.blackColor(), text: "“株洲市湖南工业大学”")
        creatLabel(CGRectMake(50, 260, width! - 100, 44), fontSize: 14, color: UIColor.blackColor(), text: "“株洲市中心广场”")
        creatLabel(CGRectMake(50, 290, width! - 100, 44), fontSize: 14, color: UIColor.blackColor(), text: "“株洲市神农城”")
        creatLabel(CGRectMake(50, height! - 60, width! - 100, 44), fontSize: 10, color: UIColor.lightGrayColor(), text: "语音核心技术由科大讯飞提供")
        
        //创建button
        let spakeBtn = UIButton(type: UIButtonType.Custom)
        spakeBtn.frame = CGRectMake((width! / 2) - 25, height! - 150, 50, 50)
        spakeBtn.setBackgroundImage(UIImage(named: "startspake.png"), forState: UIControlState.Normal)
        spakeBtn.adjustsImageWhenHighlighted = false
        spakeBtn.addTarget(self, action: #selector(SpeakViewController.spakeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(spakeBtn)
    }
    
    //MARK:说话按钮点击事件
    func spakeBtnClick() {
        //启动识别服务
        iflyRecognizerView?.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
        iflyRecognizerView?.start()
    }
    
    //MARK:创建label
    func creatLabel(frame: CGRect, fontSize: CGFloat, color: UIColor, text: NSString) {
        let label = UILabel(frame: frame)
        label.text = text as String
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
    }
    
    //MARK:讯飞语音识别代理方法
    //MARK:识别结果返回代理
    func onResult(resultArray: [AnyObject]!, isLast: Bool) {
        //resultArray:识别结果
        //islast：表示是否做后一次结果
        let dict : NSDictionary?
        dict = resultArray[0] as? NSDictionary
        for key in dict! {
            let string = String(key)
            print("\(string.characters.count)")
            if string.characters.count <= 9 {
                return
            }
            let string1 = (string as NSString).substringFromIndex(1)
            let range = string.rangeOfString(", 100)")
            let startIndex = range?.startIndex
            let string3 = string1.substringToIndex(startIndex!)
            let lengtn = (string3 as NSString).length - 1
            let string4 = (string3 as NSString).substringToIndex(lengtn)
            let locationDict : Dictionary<String,String> = ["location" : string4]
            let notification = NSNotification(name: "speakResultNotification", object: nil, userInfo: locationDict)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        iflyRecognizerView?.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
}


