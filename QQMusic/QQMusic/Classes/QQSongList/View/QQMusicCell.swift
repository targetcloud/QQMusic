//
//  QQMusicCell.swift
//  QQMusic
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
enum AnimationType {
    case rotation
    case transition
    case scale
}
class QQMusicCell: UITableViewCell {

    @IBOutlet weak var singerIconImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    
    var musicM: QQMusicModel? {
        didSet {
            if musicM?.singerIcon != nil {
                singerIconImageView.image = UIImage(named: (musicM?.singerIcon)!)
            }
            songNameLabel.text = musicM?.name
            singerNameLabel.text = musicM?.singer
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none//取消选中效果
        singerIconImageView.layer.cornerRadius = singerIconImageView.width * 0.5
        singerIconImageView.layer.masksToBounds = true
    }
    
    
    class func cellWithTableView(_ tableView: UITableView) -> QQMusicCell {
        let cellID = "music"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQMusicCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("QQMusicCell", owner: nil, options: nil)?.first as? QQMusicCell
        }
        return cell!
    }
    
    func aniation(_ type: AnimationType) {
        if type == .rotation {
            self.layer.removeAnimation(forKey: "rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [-1/6 * M_PI, 0, 1/6 * M_PI, 0]
            animation.duration = 0.2
            animation.repeatCount = 3
            self.layer.add(animation, forKey: "rotation")
        }
        if type == .scale {
            self.layer.removeAnimation(forKey: "scale")
            let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
            animation.values = [0.5, 1, 0.5, 1]
            animation.duration = 0.2
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "scale")
        }
    }
    
}
