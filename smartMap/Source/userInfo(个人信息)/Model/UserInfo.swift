//
//  UserInfo.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/3/19.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class UserInfo: NSObject {
//    var image : UIImage?
    var nickName : String?
//    var selectedButton : SexButton?
    var birthDay : String?
    
    func encodeWithCoder(aCoder : NSCoder) {
//        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeObject(self.nickName, forKey: "nickName")
//        aCoder.encodeObject(self.selectedButton, forKey: "selectedButton")
        aCoder.encodeObject(self.birthDay, forKey: "birthDay")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
//        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
        self.nickName = aDecoder.decodeObjectForKey("nickName") as? String
//        self.selectedButton = aDecoder.decodeObjectForKey("selectedButton") as? SexButton
        self.birthDay = aDecoder.decodeObjectForKey("birthDay") as? String
    }
    
    override init() {
        
    }
    
}
