//
//  QQDetailVC.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
//updateOnce updateTimes updateLrc三者频率是越来越快的节奏，后两者用定时器实现，分别用每秒和每秒60次两种分别实现updateTimes updateLrc
class QQDetailVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var lrcScrollView: UIScrollView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var foreImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    lazy var lrcVC: QQLrcTVC = {
        return QQLrcTVC()
    }()
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var costTimeLabel: UILabel!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    fileprivate var updateTimesTimer: Timer?
    fileprivate var updateLrcLink: CADisplayLink?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func volume(_ sender: UISlider) {
        QQMusicOperationTool.shareInstance.volume(sender.value)
    }
    
    //UISlider的四个事件（tap、touchDown、touchUp、valueChange）
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        print("tap")
        let value = sender.location(in: sender.view).x / (sender.view?.width)!
        progressSlider.value = Float(value)
        let totalTime = QQMusicOperationTool.shareInstance.getMusicMessageModel().totalTime
        let costTime = totalTime * TimeInterval(value)
        QQMusicOperationTool.shareInstance.seekToTime(costTime)//跳到指定时间点播放
    }
    
    @IBAction func touchDown() {
        removeTimer()
    }
    
    @IBAction func touchUp() {
        addTimer()
        let costTime = QQMusicOperationTool.shareInstance.getMusicMessageModel().totalTime * TimeInterval(progressSlider.value)
        QQMusicOperationTool.shareInstance.seekToTime(costTime)//跳到指定时间点播放
    }
    
    @IBAction func valueChange() {
        let costTime = QQMusicOperationTool.shareInstance.getMusicMessageModel().totalTime * TimeInterval(progressSlider.value)
        costTimeLabel.text = QQTimeTool.getFormatTime(costTime)//更新已播放时长
    }
    
    @IBAction func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            foreImageView.layer.resumeAnimate()
        }else {
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            foreImageView.layer.pauseAnimate()
        }
    }
    
    @IBAction func preMusic() {
        QQMusicOperationTool.shareInstance.preMusic()
        updateOnce()
    }
    
    @IBAction func nextMusic() {
        QQMusicOperationTool.shareInstance.nextMusic()
        updateOnce()
    }
    
    @IBAction func forward(_ sender: UIButton) {
        QQMusicOperationTool.shareInstance.forward()
    }
    
    @IBAction func backward(_ sender: UIButton) {
        QQMusicOperationTool.shareInstance.backward()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateOnce()
        addTimer()
        addLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeLink()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lrcVC.tableView.backgroundColor = UIColor.clear
        lrcScrollView.addSubview(lrcVC.tableView)//添加歌词控制器的tableview（歌词视图） 到 滚动视图中进行占位
        lrcScrollView.delegate = self//滚动代理用UIScrollViewDelegate〈scrollViewDidScroll〉
        lrcScrollView.isPagingEnabled = true//滚动scrollview时分页
        lrcScrollView.showsHorizontalScrollIndicator = false//去掉滚动条
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: UIControlState())
        volumeSlider.setThumbImage(UIImage(named: "playing_volumn_slide_sound_icon"), for: UIControlState())
        NotificationCenter.default.addObserver(self, selector: #selector(QQDetailVC.nextMusic), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
    
    func addTimer() {
        updateTimesTimer = Timer(timeInterval: 1, target: self, selector: #selector(QQDetailVC.updateTimes), userInfo: nil, repeats: true)
        RunLoop.current.add(updateTimesTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func removeTimer() {
        updateTimesTimer?.invalidate()
        updateTimesTimer = nil
    }
    
    func addLink() {
        updateLrcLink = CADisplayLink(target: self, selector: #selector(QQDetailVC.updateLrc))
        updateLrcLink?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func removeLink() {
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
    
    func updateOnce() {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        guard let musicM = musicMessageM.musicM else {return}
        if musicM.icon != nil{
            backImageView.image = UIImage(named: (musicM.icon)!)
            foreImageView.image = UIImage(named: (musicM.icon)!)
        }
        songNameLabel.text = musicM.name
        singerNameLabel.text = musicM.singer
        totalTimeLabel.text = musicMessageM.totalTimeFormat //QQTimeTool.getFormatTime(musicMessageM.totalTime)
        volumeSlider.value = (QQMusicOperationTool.shareInstance.tool.volume)
        //交由歌词控制器来展示
        lrcVC.lrcMs = QQMusicDataTool.getLrcMs(musicM.lrcname)
        //大圆图播放旋转动画
        foreImageView.layer.removeAnimation(forKey: "rotation")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 30
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        foreImageView.layer.add(animation, forKey: "rotation")
        
        if musicMessageM.isPlaying {
            foreImageView.layer.resumeAnimate()
        }else {
            foreImageView.layer.pauseAnimate()
        }
    }
    
    func updateTimes() {//UISlider的播放进度更新，频率比updateLrc低
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        costTimeLabel.text =  musicMessageM.costTimeFormat//QQTimeTool.getFormatTime(musicMessageM.costTime)
        playOrPauseBtn.isSelected = musicMessageM.isPlaying
    }
    
    func updateLrc() {//更新频度比updateTimes快60倍，主要用于一行歌词着色进度需求
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let time = musicMessageM.costTime
        let rowLrcM = QQMusicDataTool.getCurrentLrcM(time, lrcMs: lrcVC.lrcMs)
        let lrcM = rowLrcM.lrcM
        lrcLabel.text = lrcM?.lrcContent//更新歌词，固定的单行歌词
        if lrcM != nil {
            lrcLabel.radio =  CGFloat((time - lrcM!.beginTime) / (lrcM!.endTime - lrcM!.beginTime))
            lrcVC.progress = lrcLabel.radio//同步更新歌词进度，一行歌词着色进度
        }
        lrcVC.scrollRow = rowLrcM.row//流动整屏时用到的位置行
        if UIApplication.shared.applicationState == .background {
            QQMusicOperationTool.shareInstance.setupLockMessage()//更新锁屏界面信息
        }
    }
    
    override func viewWillLayoutSubviews() {//尺寸类的放在这里进行调整，以获取到最终的正确尺寸
        super.viewWillLayoutSubviews()
        lrcVC.tableView.frame = lrcScrollView.bounds//歌词视图大小调整
        lrcVC.tableView.x = lrcScrollView.width//默认放在最右边，滚动时出现
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)//scroll，要实现滚动的前提是要有contentSize，2页的大小
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5//大图片圆形效果
        foreImageView.layer.masksToBounds = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {//alpha change
        let radio = 1 - scrollView.contentOffset.x / scrollView.width
        foreImageView.alpha = radio
        lrcLabel.alpha = radio
    }
    
    override func remoteControlReceived(with event: UIEvent?) {//远程事件
        switch (event?.subtype)! {
        case .remoteControlPlay:
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("...")
        }
        updateOnce()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {//摇一摇
        QQMusicOperationTool.shareInstance.nextMusic()
        updateOnce()
    }

}
