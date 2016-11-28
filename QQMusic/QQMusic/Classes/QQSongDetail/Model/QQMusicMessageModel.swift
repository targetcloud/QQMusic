//
//  QQMusicMessageModel.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {
    var musicM: QQMusicModel?
    var costTime: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var isPlaying: Bool = false
    var costTimeFormat: String {
        get {
            return QQTimeTool.getFormatTime(costTime)
        }
    }
    var totalTimeFormat: String {
        get {
            return QQTimeTool.getFormatTime(totalTime)
        }
    }
}
