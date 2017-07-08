//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jessica Yeh on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var userTweets: [Tweet]!
    var user: User = User.current!
    var setTweets = false
    
    override func viewDidAppear(_ animated: Bool) {
        self.setTweets = false
    }
    
    override func viewDidLoad() {
        self.setTweets = false
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        APIManager.shared.getUserTimeline(user.screenName!) { (tweets: [Tweet]?, error: Error?) in
            if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            } else {
                self.userTweets = tweets!
                self.setTweets = true
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setting content of tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for the feedCells
        if indexPath.section == 1, let tweets = self.userTweets {
            //getting the cell and tweet
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFeedCell") as! ProfileFeedCell
            let tweet = tweets[indexPath.row]
            
            //set the labels
            cell.displayNameLabel.text = tweet.user.name
            if let imgURL = tweet.user.imgURL {
                cell.profileView.af_setImage(withURL: imgURL)
                cell.profileView.layer.cornerRadius = (cell.profileView?.frame.size.width)! / 2
                cell.profileView.layer.masksToBounds = true
            }
            cell.usernameLabel.text = "@" + tweet.user.screenName!
            cell.createdAtLabel.text = tweet.createdAtString
            cell.tweetLabel.text = tweet.text
            
            //setting likes and retweets
            cell.numLikesLabel.text = String(describing: tweet.favoriteCount!)
            cell.numRetweetLabel.text = String(tweet.retweetCount)
            if tweet.retweeted == true {
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            } else {
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
            if tweet.favorited == true {
                cell.heartButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            } else {
                cell.heartButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
            return cell
            
        } else { //for the static cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
            if let imgURL = user.imgURL {
                cell.profileView.af_setImage(withURL: imgURL)
                cell.profileView.layer.cornerRadius = (cell.profileView?.frame.size.width)! / 2
                cell.profileView.layer.masksToBounds = true
            }
            if let covURL = user.coverURL {
                cell.coverView.af_setImage(withURL: covURL)
            }
            cell.displayNameLabel.text = "@" + user.screenName!
            cell.usernameLabel.text = user.name
            cell.bioLabel.text = user.bio
            cell.followingLabel.text = String(describing: user.following!)
            cell.followersLabel.text = String(describing: user.followers!)
            return cell
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if let tweets = userTweets {
            return tweets.count
        }
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailViewController {
            let cell = sender as! ProfileFeedCell
            let indexPath = tableView.indexPath(for: cell)
            detailVC.tweet = userTweets[(indexPath?.row)!]
        }
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
