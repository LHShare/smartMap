//
//  LoginViewController.swift
//  smartMap
//
//  Created by 刘刘欢 on 15/11/20.
//  Copyright © 2015年 刘刘欢. All rights reserved.
//登陆控制器

import Foundation

class LoginViewController: BaseViewController,UITextFieldDelegate {
    
    var userNameTextField : UITextField!
    var passWordTextField : UITextField!
    var loginButton : UIButton!
    var resignButton : UIButton!
    var db : FMDatabase!
    var accountTool : AccountTool?
    var account : Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "快速登录"
        self.buildUI()
        
        //创建数据库
        self.createDB()
        accountTool = AccountTool.shareAccountTool()
    }
    
    func createDB() {
        let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString).stringByAppendingString("/userDB.db");
        db = FMDatabase(path: path)
        if !db.open() {//数据库没有打开
            print("数据库没有打开")
            
        } else {//数据库打开了
            //创建用户表
            let result = db.executeUpdate(" create table if not exists user(_id integer primary key autoincrement, userName text, passWord text)", withArgumentsInArray: nil)
            if result {
                print("创建表成功")
                
            } else {
                print("创建表失败")
            }
        }
    }
    
    func buildUI() {
        let bgImageView = UIImageView(image: UIImage(named: "bgImage.png"))
        bgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(bgImageView)
        
        userNameTextField = UITextField()
        userNameTextField.frame = CGRectMake(0,10, self.view.frame.size.width, 44);
        userNameTextField.placeholder = "请输入手机号"
        userNameTextField.font = UIFont.systemFontOfSize(14)
        userNameTextField.borderStyle = UITextBorderStyle.None
        userNameTextField.backgroundColor = UIColor.whiteColor()
        userNameTextField.tag = 101
        userNameTextField.delegate = self;
        self.view.addSubview(userNameTextField)
        
        passWordTextField = UITextField()
        passWordTextField.frame = CGRectMake(0, CGRectGetMaxY(userNameTextField.frame) + 10, self.view.frame.size.width, 44)
        passWordTextField.placeholder = "请输入密码"
        passWordTextField.font = UIFont.systemFontOfSize(14)
        passWordTextField.borderStyle = UITextBorderStyle.None
        passWordTextField.backgroundColor = UIColor.whiteColor()
        passWordTextField.tag = 102
        passWordTextField.delegate = self;
        self.view.addSubview(passWordTextField)
        
        resignButton = UIButton(type: UIButtonType.Custom)
        resignButton.setTitle("注册", forState: UIControlState.Normal)
        resignButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resignButton.setBackgroundImage(UIImage(named: "bg_btn_login"), forState: UIControlState.Normal)
        resignButton.frame = CGRectMake(10, CGRectGetMaxY(passWordTextField.frame) + 20, (self.view.frame.size.width - 30) / 2, 30)
        resignButton.adjustsImageWhenHighlighted = false
        resignButton.addTarget(self, action: #selector(LoginViewController.resignBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(resignButton)
        
        loginButton = UIButton(type: UIButtonType.Custom)
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.setBackgroundImage(UIImage(named: "bg_btn_login"), forState: UIControlState.Normal)
        loginButton.frame = CGRectMake(CGRectGetMaxX(resignButton.frame) + 10, CGRectGetMaxY(passWordTextField.frame) + 20, (self.view.frame.size.width - 30) / 2, 30)
        loginButton.adjustsImageWhenHighlighted = false
        loginButton.addTarget(self, action: #selector(LoginViewController.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
    }
    
    //MARK:获得数据库中所有数据
    func getAllUsers() -> FMResultSet {
        let Set : FMResultSet?
        Set = db.executeQuery("select * from user", withArgumentsInArray: nil)
        return Set!
    }
    
    //MARK:判断用户是否存在
    func isExists() -> Bool {
        var exists : Bool = false
        let resultSet = self.getAllUsers()
        while resultSet.next() {
            let userName = resultSet.stringForColumn("userName") as String
            if userName == userNameTextField.text {
                exists = true
                return exists
            }
        }
        return exists
    }
    
    //MARK:判断textfield是否为空
    func isNotFull() -> Bool {
        var full : Bool = false
        if userNameTextField.text=="" || passWordTextField.text=="" {
            full = true
        }
        return full
    }
    
    //MARK:注册按钮点击
    func resignBtnClick() {
        if self.isNotFull() {//空
            return
        } else {//不空
            //插入数据
            if self.isExists() {//用户存在
            } else {//用户不存在
                let userName = userNameTextField.text
                let passWord = passWordTextField.text
                let sqlInsert = "userName,passWord"
                let sqlParam = ":userName,:passWord"
                let param:[String:AnyObject] = ["userName":userName!,"passWord":passWord!]
                let result = db.executeUpdate("insert into user(\(sqlInsert)) values(\(sqlParam))", withParameterDictionary: param)
                if result {
                    print("插入数据成功")
                }
            }
        }
    }
    
    //MARK:登录按钮点击
    func loginBtnClick() {
        let resultSet = self.getAllUsers()
        var userName : String?
        var passWord : String?
        while resultSet.next() {
            userName = resultSet.stringForColumn("userName") as String
            passWord = resultSet.stringForColumn("passWord") as String
            if (userName == userNameTextField.text) && (passWord == passWordTextField.text) {//登录成功
                self.backBtnClick()
                //存储用户
                self.saveAccount()
            } else {//登录失败
                
            }
        }
    }
    
    //MARK:存储帐号
    func saveAccount() {
        var account = accountTool?.accountModel
        if account == nil {
            account = Account()
        }
        account?.userName = userNameTextField.text
        account?.passWord = passWordTextField.text
        accountTool?.saveAccount(account!)
    }
    
    //MARK:textfield代理方法
//    func textFieldDidBeginEditing(textField: UITextField) {
//        if textField.tag == 101 {//用户名
//            userNameTextField.placeholder = ""
//            
//        } else {//密码
//            passWordTextField.placeholder = ""
//        }
//    }
    
}
