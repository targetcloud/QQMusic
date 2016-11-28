//
//  QQImageTool.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {
    class func getNewImage(_ sourceImage: UIImage?, str: String?) -> UIImage? {
        guard let image = sourceImage else { return nil }
        guard let resultStr = str else { return image }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let textRect = CGRect(x: 0, y: 0, width: image.size.width, height: 28)
        let textDic = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSParagraphStyleAttributeName: style
        ]
        (resultStr as NSString).draw(in: textRect, withAttributes: textDic)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}
