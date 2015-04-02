//
//  SingleTweetViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/1/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

  let twitterService = TwitterService()
  var currentTweet: Tweet?
  var tweetId: Int?
  
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var hashtagsLabel: UILabel!
  @IBOutlet weak var profilePicImage: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.activityIndicator.startAnimating()
    self.usernameLabel.text = ""
    self.screenNameLabel.text = ""
    self.tweetTextLabel.text = ""
    self.hashtagsLabel.text = ""
    
    LoginService.requestTwitterAccount { (account, error) -> Void in
      if account != nil {
        self.twitterService.twitterAccount = account
        self.twitterService.fetchStatuses(self.tweetId!) { (tweet, errorDescription) -> Void in
          if errorDescription != nil {
            let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
          } else {
            if tweet != nil {
              self.activityIndicator.stopAnimating()
              self.currentTweet = tweet
              self.usernameLabel.text = self.currentTweet!.username
              self.screenNameLabel.text = self.currentTweet!.screenName
              self.tweetTextLabel.text = self.currentTweet!.text
              var hashtagString = "Hashtags used: "
              if let hashtags = self.currentTweet!.hashtags {
                for hashtag in hashtags {
                  hashtagString += "#\(hashtag) "
                }
              }
              self.hashtagsLabel.text = hashtagString
              if let profileImageData = self.currentTweet!.profilePic {
                self.profilePicImage.image = UIImage(data: profileImageData)
              }
            }
          }
        }
      }
    }
  }
}

