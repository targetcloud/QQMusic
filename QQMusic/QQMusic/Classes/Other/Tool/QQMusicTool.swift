//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
import AVFoundation

let kPlayFinishNotification = "playFinish"

class QQMusicTool: NSObject {

    var player: AVAudioPlayer?
    
    override init() {
        super.init()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }catch {
            print(error)
            return
        }
    }
    
    func seekToTime(_ time: TimeInterval) {
        player?.currentTime = time
    }
    
    func playMusic(_ musicName: String?) {
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else {return}
        if player?.url == url {
            player?.play()
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
        }catch {
            print(error)
            return
        }
    }
    
    func pauseMusic()  {
        player?.pause()
    }
    
    func playCurrentMusic()  {
        player?.play()
    }
    
    func stopCurrentMusic() {
        player?.currentTime = 0
        player?.stop()
    }
    
}

extension QQMusicTool: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
}
