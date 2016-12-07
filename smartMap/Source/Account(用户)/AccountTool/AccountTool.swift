//
//  AccountTool.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/3/12.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class AccountTool : NSObject {
    struct Private {
        static var accountTool : AccountTool? = nil
        static var _once : dispatch_once_t = 0
    }
    let filePath : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0].stringByAppendingString("/account.data")
    var accountModel : Account?
    
    class func shareAccountTool() -> AccountTool  {
        dispatch_once(&Private._once) { () -> Void in
            Private.accountTool = AccountTool()
        }
        return Private.accountTool!
    }
    
    override init() {
        super.init()
        accountModel = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Account
    }
    
    func saveAccount(account : Account) {
        accountModel = account
        NSKeyedArchiver.archiveRootObject(account, toFile: filePath)
    }
}
