//
//  ProfileFeedCell.swift
//  twitter_alamofire_demo
//
//  Created by Jessica Yeh on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileFeedCell: UITableViewCell {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var numRetweetLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!

    
    @IBAction func onRetweet(_ sender: Any) {
        
    }
    
    @IBAction func onHeart(_ sender: Any) {

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
