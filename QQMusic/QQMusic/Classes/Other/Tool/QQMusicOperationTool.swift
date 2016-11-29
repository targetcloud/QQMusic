//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
import MediaPlayer

class QQMusicOperationTool: NSObject {
    static let shareInstance = QQMusicOperationTool()
    let tool = QQMusicTool()
    var musicMs: [QQMusicModel] = [QQMusicModel]()
    fileprivate var lastRow = -1
    fileprivate var artWork: MPMediaItemArtwork?
    
    fileprivate var currentPlayIndex = -1 {
        didSet {
            if currentPlayIndex < 0{
                currentPlayIndex = (musicMs.count) - 1
            }
            if currentPlayIndex > (musicMs.count) - 1{
                currentPlayIndex = 0
            }
        }
    }
    
    fileprivate var musicMessageM = QQMusicMessageModel()
    func getMusicMessageModel() -> QQMusicMessageModel {
        if musicMs == nil {
            return musicMessageM
        }
        musicMessageM.musicM = musicMs[currentPlayIndex]
        musicMessageM.costTime = (tool.player?.currentTime) ?? 0
        musicMessageM.totalTime = (tool.player?.duration) ?? 0
        musicMessageM.isPlaying = (tool.player?.isPlaying) ?? false
        return musicMessageM
    }
    
    func playMusic(_ musicM: QQMusicModel) {
        tool.playMusic(musicM.filename)
        currentPlayIndex = musicMs.index(of: musicM)!
    }
    
    func playCurrentMusic() {
        let model = musicMs[currentPlayIndex]
        playMusic(model)
    }
    
    func pauseCurrentMusic() {
        tool.pauseMusic()
    }
    
    func nextMusic()  {
        currentPlayIndex += 1
        let model = musicMs[currentPlayIndex]
        playMusic(model)
    }
    
    func preMusic()  {
        currentPlayIndex -= 1
        let model = musicMs[currentPlayIndex]
        playMusic(model)
    }
    
    func seekToTime(_ time: TimeInterval) {
        tool.seekToTime(time)
    }
    
    func forward(){
        tool.fastforward(10)
    }
    
    func backward(){
        tool.fastbackward(10)
    }
    
    func volume(_ value : Float){
        tool.volume(value)
    }
    
    func setupLockMessage() {
        let musicMessageM = getMusicMessageModel()
        let center = MPNowPlayingInfoCenter.default()
        
        let musicName = musicMessageM.musicM?.name ?? ""
        let singerName = musicMessageM.musicM?.singer ?? ""
        let costTime = musicMessageM.costTime
        let totalTime = musicMessageM.totalTime
        
        let lrcFileName = musicMessageM.musicM?.lrcname
        let lrcMs = QQMusicDataTool.getLrcMs(lrcFileName)
        let lrcModelAndRow = QQMusicDataTool.getCurrentLrcM(musicMessageM.costTime, lrcMs: lrcMs)
        let lrcM = lrcModelAndRow.lrcM
        
        var resultImage: UIImage?
        if lastRow != lrcModelAndRow.row {
            lastRow = lrcModelAndRow.row
            resultImage = QQImageTool.getNewImage(UIImage(named: musicMessageM.musicM?.icon ?? ""), str: lrcM?.lrcContent)
            if resultImage != nil {
                artWork = MPMediaItemArtwork(image: resultImage!)
            }
        }
        
        let dic: NSMutableDictionary = [
            MPMediaItemPropertyAlbumTitle: musicName,
            MPMediaItemPropertyArtist: singerName,
            MPMediaItemPropertyPlaybackDuration: totalTime,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime
        ]
        if artWork != nil {
            dic.setValue(artWork!, forKey: MPMediaItemPropertyArtwork)
        }
        
        let dicCopy = dic.copy()
        center.nowPlayingInfo = dicCopy as? [String: Any]
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

}
