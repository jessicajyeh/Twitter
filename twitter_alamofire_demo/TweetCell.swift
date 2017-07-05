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
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            authorTextLabel.text = tweet.user.screenName
            displayNametextLabel.text = tweet.user.name
            
            //setting created at time
            timeLabel.text = tweet.createdAtString
            
            //setting profile images
            if let imgURL = tweet.user.imgURL {
                profileView.af_setImage(withURL: imgURL)
                profileView.layer.cornerRadius = (profileView?.frame.size.width)! / 2
                profileView.layer.masksToBounds = true
            }
            
            //initializing colors of buttons and fav/rt text
            if tweet.retweeted == true {
                rtButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            } else {
                rtButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
            if tweet.favorited == true {
                favButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            } else {
                favButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
            let rtNum = tweet.retweetCount 
            let favNum = tweet.favoriteCount!
            retweetNum.text = String(rtNum)
            heartNum.text = String(favNum)
        }
    }
    
    @IBAction func onRT(_ sender: Any) {
        if tweet.retweeted != true {
            tweet.retweetCount += 1
            tweet.retweeted = true
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            tweet.retweetCount -= 1
            tweet.retweeted = false
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
        let rtNum = tweet.retweetCount
        retweetNum.text = String(rtNum)
    }
    
    @IBAction func onHeart(_ sender: Any) {
        if tweet.favorited != true {
            tweet.favoriteCount! += 1
            tweet.favorited = true
            favButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        } else {
            tweet.favoriteCount! -= 1
            tweet.favorited = false
            favButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        let favNum = tweet.favoriteCount!
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
