//
//  SexButton.swift
//  smartMap
//
//  Created by 刘刘欢 on 16/3/19.
//  Copyright © 2016年 刘刘欢. All rights reserved.
//

import Foundation

class SexButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        let x = contentRect.width / 2
        let y = contentRect.height / 4
        return CGRectMake(x, y, 20, 20)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(15, 0, 30, 30)
    }
}
