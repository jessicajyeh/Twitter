//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jessica Yeh on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate: class {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIImageView!
    weak var delegate: ComposeViewControllerDelegate?

    @IBOutlet weak var tweetContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setting profile picture
        if let imgURL = User.current?.imgURL {
            profileView.af_setImage(withURL: imgURL)
            profileView.layer.cornerRadius = (profileView?.frame.size.width)! / 2
            profileView.layer.masksToBounds = true
        }
        profileView.layer.cornerRadius = (profileView?.frame.size.width)! / 2
        profileView.layer.masksToBounds = true
    }
    
    @IBAction func onPost(_ sender: Any) {
        let postContent: String = tweetContent.text
        APIManager.shared.composeTweet(with: postContent) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
        dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
