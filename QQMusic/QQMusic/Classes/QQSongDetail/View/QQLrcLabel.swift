//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var radio: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.green.set()
        UIRectFillUsingBlendMode(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * radio, height: rect.size.height), CGBlendMode.sourceIn)
    }

}
