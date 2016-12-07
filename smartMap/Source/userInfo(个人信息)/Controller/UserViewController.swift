//
//  UserViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//

//用户设置控制器

import Foundation

class UserViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    var width : CGFloat?
    var userIcon : UIImageView?
    var nickName : UITextField?
    var manButton : SexButton?
    var womanButton : SexButton?
    var commitButton : UIButton?
    var birthdayField : UITextField?
    var ageField : UITextField?
    var cover : Cover?
    var selectedSexButton : SexButton?
    var datePicker : UIDatePicker?
    let filePath : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingString("/userInfo.data")
    var userinfo : UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人信息"
        width = self.view.frame.size.width
        //创建界面
        buildUI()
        userinfo = UserInfo()
        self.getUserInfo()
    }
    
    //MARK:创建界面
    func buildUI() {
        let image = UIImage(named: "bgImage")
        let bgImageView = UIImageView(image: image)
        bgImageView.frame = CGRectMake(0, 0, width!, self.view.frame.size.height)
        self.view.addSubview(bgImageView)
        
        //头像
        let centerX = self.view.frame.size.width / 2;
        userIcon = UIImageView(image: UIImage(named: "user_icon.png"))
        userIcon?.center = CGPointMake(centerX - 90, 60)
        userIcon?.layer.masksToBounds = true
        userIcon?.layer.cornerRadius = 33
        userIcon?.bounds = CGRectMake(0, 0, 65, 65)
        userIcon?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(userIcon!)
        
        let photoButton = UIButton(type: UIButtonType.Custom)
        photoButton.center = CGPointMake(centerX + 20, 40)
        photoButton.bounds = CGRectMake(0, 0, 88, 30)
        photoButton.setBackgroundImage(UIImage(named: "bg_btn_getcp.png"), forState: UIControlState.Normal)
        photoButton.adjustsImageWhenHighlighted = false
        photoButton.setTitle("拍照", forState: UIControlState.Normal)
        photoButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        photoButton.addTarget(self, action: "userIconBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(photoButton)
        
        let pickerButton = UIButton(type: UIButtonType.Custom)
        pickerButton.center = CGPointMake(centerX + 20, CGRectGetMaxY(photoButton.frame) + 20)
        pickerButton.bounds = CGRectMake(0, 0, 88, 30)
        pickerButton.setBackgroundImage(UIImage(named: "bg_btn_getcp.png"), forState: UIControlState.Normal)
        pickerButton.adjustsImageWhenHighlighted = false
        pickerButton.setTitle("选择", forState: UIControlState.Normal)
        pickerButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        pickerButton.addTarget(self, action: "userIconBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(pickerButton)
        
        //昵称
        let line1 = createLine(CGRectMake(5, CGRectGetMaxY(pickerButton.frame) + 40, width! - 10, 1))
        let label1 = createLabel("昵称", frame: CGRectMake(25, CGRectGetMaxY(line1.frame) + 8, 30, 24))
        nickName = createTextField(CGRectMake(CGRectGetMaxX(label1.frame) + 20, CGRectGetMaxY(line1.frame) + 7, 200, 28))
        nickName?.delegate = self
        nickName?.tag = 1
        //性别
        let line2 = createLine(CGRectMake(5, CGRectGetMaxY((nickName?.frame)!) + 7, width! - 10, 1))
        let label2 = createLabel("性别", frame: CGRectMake(25, CGRectGetMaxY(line2.frame) + 8, 30, 24))
        manButton = SexButton()
        manButton?.frame = CGRectMake(CGRectGetMaxX(label2.frame) + 20, CGRectGetMaxY(line2.frame) + 7, 75, 28)
        manButton?.setTitle("男", forState: UIControlState.Normal)
        manButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        manButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
        manButton?.tag = 100
        var selectedImage : UIImage?
        selectedImage = UIImage(named: "btn_selected.png")
        let noselectedImage = UIImage(named: "btn_noselected.png")
        manButton?.setImage(selectedImage, forState: UIControlState.Selected)
        manButton?.setImage(noselectedImage, forState: UIControlState.Normal)
        manButton?.addTarget(self, action: "manBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(manButton!)
        womanButton = SexButton()
        womanButton?.frame = CGRectMake(CGRectGetMaxX((manButton?.frame)!) + 20, CGRectGetMaxY(line2.frame) + 7, 75, 28)
        womanButton?.setTitle("女", forState: UIControlState.Normal)
        womanButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        womanButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
        womanButton?.setImage(selectedImage, forState: UIControlState.Selected)
        womanButton?.setImage(noselectedImage, forState: UIControlState.Normal)
        womanButton?.tag = 101
        womanButton?.addTarget(self, action: "manBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(womanButton!)
        //生日
        let line3 = createLine(CGRectMake(5, CGRectGetMaxY((womanButton?.frame)!) + 7, width! - 10, 1))
        let label3 = createLabel("生日", frame: CGRectMake(25, CGRectGetMaxY(line3.frame) + 8, 30, 24))
        birthdayField = createTextField(CGRectMake(CGRectGetMaxX(label3.frame) + 20, CGRectGetMaxY(line3.frame) + 7, 200, 28))
        birthdayField?.delegate = self
        birthdayField?.tag = 2
        //年龄
//        let line4 = createLine(CGRectMake(5, CGRectGetMaxY((birthdayField?.frame)!) + 8, width! - 10, 1))
//        let label4 = createLabel("年龄", frame: CGRectMake(25, CGRectGetMaxY(line4.frame) + 7, 30, 24))
//        ageField = createTextField(CGRectMake(CGRectGetMaxX(label4.frame) + 20, CGRectGetMaxY(line4.frame) + 7, 200, 28))
//        ageField?.delegate = self
        //提交按钮
        let line5 = createLine(CGRectMake(5, CGRectGetMaxY((birthdayField?.frame)!) + 8, width! - 10, 1))
        let commitBtn = UIButton(type: UIButtonType.Custom)
        commitBtn.setBackgroundImage(UIImage(named: "bg_btn_login.png"), forState: UIControlState.Normal)
        commitBtn.frame = CGRectMake(5, CGRectGetMaxY(line5.frame) + 20, width! - 10, 30)
        commitBtn.setTitle("提交", forState: UIControlState.Normal)
        commitBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        commitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commitBtn.addTarget(self, action: "commitBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        commitBtn.adjustsImageWhenHighlighted = false
        self.view.addSubview(commitBtn)
        commitButton = commitBtn
    }
    
    //MARK:创建textfield
    func createTextField(frame: CGRect) -> UITextField {
        let textField = UITextField()
        textField.frame = frame
        textField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(textField)
        return textField
    }
    
    //MARK:创建分割线
    func createLine(frame : CGRect) -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.lightGrayColor()
        line.frame = frame
        self.view.addSubview(line)
        return line
    }
    //MARK:创建文字描述
    func createLabel(text : String,frame : CGRect) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Center
        label.frame = frame
        self.view.addSubview(label)
        return label
    }
    
    //MARK:照片按钮点击事件
    func userIconBtnClick(button : UIButton) {
        if button.titleLabel?.text == "拍照" {
            self.getPickerFormCamera()
        } else {
            self.getPicderFromLibrary()
        }
    }
    
    //MARK:拍照获取相片
    func getPickerFormCamera()
    {
        let picker : UIImagePickerController?
        picker = UIImagePickerController();
        picker?.sourceType = UIImagePickerControllerSourceType.Camera;
        picker?.allowsEditing = true;
        picker?.delegate = self;
        self.presentViewController(picker!, animated: true, completion: nil);
    }
    
    //MARK:从图片库获取相片
    func getPicderFromLibrary()
    {
        let picker : UIImagePickerController?
        picker = UIImagePickerController();
        picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        picker?.allowsEditing = true;
        picker?.delegate = self;
        self.presentViewController(picker!, animated: true, completion: nil);
    }
    
    //MARK:相片选择器代理方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if (image.isKindOfClass(UIImage)) {
            userIcon?.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:性别按钮点击事件
    func manBtnClick(button : SexButton) {
        selectedSexButton?.selected = false
        button.selected = true
        selectedSexButton = button
        
    }
    
    //MARK:提交按钮点击事件
    func commitBtnClick() {
        self.userInfowriteToFile()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK:将数据存入沙盒
    func userInfowriteToFile() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(userIcon?.image, forKey: "userIconImage")
//        defaults.setObject(nickName?.text, forKey: "nickName")
//        defaults.setObject(selectedSexButton?.tag, forKey: "sexButtonTag")
//        defaults.setObject(birthdayField?.text, forKey: "birthdayText")
//        defaults.synchronize()
        if ((userIcon!.image!.isKindOfClass(UIImage)) && (nickName?.text == "") && (selectedSexButton!.isKindOfClass(SexButton)) && (birthdayField?.text == "")) {
            return
        }
//        let array = NSMutableArray()
//        array.addObject((userIcon?.image)!)
//        array.addObject((nickName?.text)!)
//        array.addObject(selectedSexButton!)
//        array.addObject((birthdayField?.text)!)
//        
//        NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
//        userinfo!.image = userIcon?.image
        userinfo!.nickName = nickName?.text
        userinfo!.birthDay = birthdayField?.text
//        userinfo!.selectedButton = selectedSexButton
        let array = NSMutableArray()
        array.addObject(userinfo!)
        NSKeyedArchiver.archiveRootObject(array, toFile: filePath)
    }
    
    //MARK:从沙盒读取数据
    func getUserInfo() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let image = defaults.objectForKey("userIconImage") as! UIImage
//        userIcon?.image = image
//        nickName?.text = defaults.objectForKey("nickName") as? String
//        let tag = defaults.objectForKey("sexButtonTag") as! NSInteger
//        if tag == 100 {
//            manButton?.selected = true
//            selectedSexButton = manButton
//            womanButton?.selected = false
//        } else {
//            manButton?.selected = false
//            womanButton?.selected = true
//            selectedSexButton = womanButton
//        }
//        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath)
//        if (array == nil) {
//            return
//        } else {
//            let image = array![0] as! UIImage
//            userIcon?.image = image
//            let nick = array![1] as! NSString
//            nickName?.text = nick as String
//            let button = array![2] as! SexButton
//            if selectedSexButton?.tag == 100 {
//                manButton?.selected = true
//                womanButton?.selected = false
//                selectedSexButton = manButton
//            } else {
//                manButton?.selected = false
//                womanButton?.selected = true
//                selectedSexButton = womanButton
//            }
//            let birth = array![3] as! NSString
//            birthdayField?.text = birth as String
//        }
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? NSArray
        if (array?.count > 0) {
            let user = array![0]
//            userIcon?.image = user.image
            nickName?.text = user.nickName
            birthdayField?.text = user.birthDay
//            selectedSexButton = user.selectedButton
//            if selectedSexButton?.titleLabel?.text == "男" {
//                manButton?.selected = true
//                womanButton?.selected = false
//            } else {
//                manButton?.selected = false
//                womanButton?.selected = true
//            }
        }
    }
    
    //MARK:输入框开始输入
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            cover = Cover.creageCover(self, action: "coverClick")
            cover!.alpha = 0.02
            cover?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.addSubview(cover!)
            return true
        } else if textField.tag == 2 {
            self.createDataPicker()
            return false
        }
        return false
    }
    
    func createDataPicker() {
        var height = self.view.frame.size.height - CGRectGetMaxY((commitButton?.frame)!)
        if height > 300 {
            height = 300
        }
        cover = Cover.creageCover(self, action: "coverClick")
        cover?.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 150)
        cover?.alpha = 0.02
        self.view.addSubview(cover!)
        
        let local = NSLocale(localeIdentifier: "zh_CN")
        datePicker = UIDatePicker()
        datePicker!.frame = CGRectMake(0, CGRectGetMaxY((commitButton?.frame)!) + 10, self.view.frame.size.width, height)
        datePicker!.locale = local
        datePicker!.datePickerMode = UIDatePickerMode.Date
        datePicker!.addTarget(self, action: "dataPickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(datePicker!)
    }
    
    func dataPickerValueChanged(datePicker : UIDatePicker) {
        let date = datePicker.date
        let fmt = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let dateString = fmt.stringFromDate(date)
        birthdayField?.text = dateString
    }
    
    func coverClick() {
        cover?.removeFromSuperview()
        nickName?.resignFirstResponder()
        birthdayField?.resignFirstResponder()
        datePicker?.removeFromSuperview()
    }
}
