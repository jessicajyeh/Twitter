//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var authorTextLabel: UILabel!
    @IBOutlet weak var displayNametextLabel: UILabel!
    @IBOutlet weak var replyNum: UILabel!
    @IBOutlet weak var retweetNum: UILabel!
    @IBOutlet weak var heartNum: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            authorTextLabel.text = tweet.user.screenName
            displayNametextLabel.text = tweet.user.name
            if let imgURL = tweet.user.imgURL {
                profileView.af_setImage(withURL: imgURL)
            }
            
            let rtNum = tweet.retweetCount 
            let favNum = tweet.favoriteCount!
            retweetNum.text = String(rtNum)
            heartNum.text = String(favNum)
        }
    }
    
    @IBAction func onRT(_ sender: Any) {
        tweet.retweetCount += 1
        let rtNum = tweet.retweetCount
        retweetNum.text = String(rtNum)
    }
    
    @IBAction func onHeart(_ sender: Any) {
        tweet.favoriteCount! += 1
        let favNum = tweet.favoriteCount
        heartNum.text = String(describing: favNum)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
