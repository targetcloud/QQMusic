//
//  QQSongListTVC.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class QQSongListTVC: UITableViewController {
    var musicMs: [QQMusicModel] = [QQMusicModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        QQMusicDataTool.getMusicMs { (models: [QQMusicModel]) in
            self.musicMs = models
            QQMusicOperationTool.shareInstance.musicMs = models
        }
    }
    
    func setupUI()  {
        tableView.backgroundView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQMusicCell.cellWithTableView(tableView)
        cell.musicM = musicMs[(indexPath as NSIndexPath).row]
        cell.aniation(AnimationType.scale)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        QQMusicOperationTool.shareInstance.playMusic(musicMs[(indexPath as NSIndexPath).row])
        performSegue(withIdentifier: "listToDetail", sender: nil)
    }
}
