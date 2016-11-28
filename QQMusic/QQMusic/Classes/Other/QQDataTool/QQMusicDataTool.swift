//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicMs(_ result: ([QQMusicModel])->()) {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([QQMusicModel]())
            return
        }
        guard let array = NSArray(contentsOfFile: path) else {
            result([QQMusicModel]())
            return
        }
        var musicMs = [QQMusicModel]()
        for dic in array {
            let musicM = QQMusicModel(dic: dic as! [String : Any])
            musicMs.append(musicM)
        }
        result(musicMs)
    }
    
    class func getLrcMs(_ lrcName: String?) -> [QQLrcModel] {
        if lrcName == nil {
            return [QQLrcModel]()
        }
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else { return [QQLrcModel]() }
        var lrcContent = ""
        do {
            lrcContent = try  String(contentsOfFile: path)
        }catch {
            print(error)
            return [QQLrcModel]()
        }
        let timeContentArray = lrcContent.components(separatedBy: "\n")
        var lrcMs = [QQLrcModel]()
        for timeContentStr in timeContentArray {
            if timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:") || timeContentStr.contains("[al:") { continue }
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
            let timeAndContent = resultLrcStr.components(separatedBy: "]")
            if timeAndContent.count != 2 { continue }
            let time = timeAndContent[0]
            let content = timeAndContent[1]
            let lrcM = QQLrcModel()
            lrcM.beginTime = QQTimeTool.getTimeInterval(time)
            lrcM.lrcContent = content
            lrcMs.append(lrcM)
        }
        
        for i in 0..<lrcMs.count {
            if i == lrcMs.count - 1 { break }
            lrcMs[i].endTime = lrcMs[i + 1].beginTime
        }
        return lrcMs
    }
    
    
    class func getCurrentLrcM(_ currentTime: TimeInterval, lrcMs: [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel?) {
        for i in 0..<lrcMs.count {
            if  currentTime >= lrcMs[i].beginTime && currentTime < lrcMs[i].endTime {
                return (i, lrcMs[i])
            }
        }
        return (0, nil)
    }
}
