//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jessica Yeh on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var numRetweetLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextLabel.text = tweet?.text
        authorNameLabel.text = "@" + (tweet?.user.screenName)!
        displayNameLabel.text = tweet?.user.name
        
        //setting created at time
        createdAtLabel.text = tweet?.createdAtString
        
        //setting profile images
        if let imgURL = tweet?.user.imgURL {
            profileView.af_setImage(withURL: imgURL)
            profileView.layer.cornerRadius = (profileView?.frame.size.width)! / 2
            profileView.layer.masksToBounds = true
        }
        
        //initializing colors of buttons and fav/rt text
        if tweet?.retweeted == true {
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
        } else {
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
        }
        if tweet?.favorited == true {
            favButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
        } else {
            favButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
        }
        
        let rtNum = tweet?.retweetCount
        let favNum = tweet?.favoriteCount!
        numRetweetLabel.text = String(describing: rtNum!)
        numLikesLabel.text = String(describing: favNum!)
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if tweet.retweeted != true {
            tweet.retweetCount += 1
            tweet.retweeted = true
            rtButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
                if let  error = error {
                    print("Error retweeting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully retweeted the following Tweet: \n\(tweet.text)")
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
        numRetweetLabel.text = String(rtNum)

    }
    
    @IBAction func onLike(_ sender: Any) {
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
        numLikesLabel.text = String(describing: favNum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let timelineVC = segue.destination as! TimelineViewController
        timelineVC.refreshFeed()
        print("kay")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
