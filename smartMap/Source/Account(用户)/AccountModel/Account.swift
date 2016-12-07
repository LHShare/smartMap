//
//  Account.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/3/12.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class Account: NSObject {
    var userName : String?
    var passWord : String?
    
    func encodeWithCoder(aCoder : NSCoder) {
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeObject(self.passWord, forKey: "passWord")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.userName = aDecoder.decodeObjectForKey("userName") as? String
        self.passWord = aDecoder.decodeObjectForKey("passWord") as? String
    }
    
    override init() {
        
    }
    
}
