//
//  QQMusicModel.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    var name: String?
    var filename: String?
    var lrcname: String?
    var singer: String?
    var singerIcon: String?
    var icon: String?
    
    override init() {
        super.init()
    }
    
    init(dic: [String: Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
