//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol RetweetUpdateDelegate: class{
    func didRetweet(post: Tweet)
}

protocol TweetCellDelegate: class {
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

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
    @IBOutlet weak var mediaView: UIImageView!
    weak var delegate: RetweetUpdateDelegate?
    weak var tweetDelegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            authorTextLabel.text = "@" + tweet.user.screenName!
            displayNametextLabel.text = tweet.user.name
            
            //setting created at time
            timeLabel.text = tweet.createdAtString
            //let date = Date(tweet.createdAtString)
            //timeLabel.text = date.shortTimeAgoSinceNow
            
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
            
            //setting media
            if let imgURL = tweet.imageURL {
                mediaView.af_setImage(withURL: imgURL)
                print(imgURL)
            }

        }
    }
    
    @IBAction func onRT(_ sender: Any) {
        if tweet.retweeted != true {
            tweet.retweetCount += 1
            tweet.retweeted = true
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
                    if let del = self.delegate {
                        del.didRetweet(post: tweet)
                    }
                }
            }
        } else {
            tweet.retweetCount -= 1
            tweet.retweeted = false
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unretweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                }
            }

        }
        let rtNum = tweet.retweetCount
        retweetNum.text = String(rtNum)
    }
    
    @IBAction func onHeart(_ sender: Any) {
        
        print("This tweet has been favorited: \(tweet.favorited!)")
        if tweet.favorited != true { //if not favorited yet
            tweet.favoriteCount! += 1
            tweet.favorited = true
            favButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error favoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully favorited the following Tweet: \n\(tweet.text)")
                }
            }
        } else {
            tweet.favoriteCount! -= 1
            tweet.favorited = false
            favButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            }

        }
        let favNum = tweet.favoriteCount!
        heartNum.text = String(describing: favNum)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapUserProfile(_:)))
        profileView.addGestureRecognizer(profileTapGestureRecognizer)
        profileView.isUserInteractionEnabled = true
    }
    
    func didTapUserProfile(_ sender: UITapGestureRecognizer) {
        tweetDelegate?.tweetCell(self, didTap: tweet.user)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
