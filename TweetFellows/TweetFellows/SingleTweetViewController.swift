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
  var tweetText: String?
  var tweetUsername: String?
  
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var hashtagsLabel: UILabel!
  @IBOutlet weak var profilePicImage: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var lineSeperatorView: UIView!
  @IBOutlet weak var retweetLabel: UILabel!
  @IBOutlet weak var favoriteLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tweetTextLabel.text = tweetText
    self.usernameLabel.text = tweetUsername
    self.activityIndicator.startAnimating()
    
    
    UIView.animateWithDuration(1.5, animations: { () -> Void in
      self.tweetTextLabel.alpha = 1
      self.usernameLabel.alpha = 1
      self.screenNameLabel.alpha = 1
      self.retweetLabel.alpha = 1
      self.retweetCountLabel.alpha = 1
      self.favoriteLabel.alpha = 1
      self.favoriteCountLabel.alpha = 1
      self.hashtagsLabel.alpha = 1
      self.lineSeperatorView.alpha = 1
      self.profilePicImage.alpha = 1
      self.createdAtLabel.alpha = 1
    })
    
    
    
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
            if let tweetSelected = tweet {
              self.configureTweet(tweetSelected)
            }
          }
        }
      }
    }
  }
  
  func configureTweet(tweet: Tweet) {
    self.currentTweet = tweet
    self.activityIndicator.stopAnimating()
    self.usernameLabel.text = tweet.username
    self.screenNameLabel.text = tweet.screenName
    self.tweetTextLabel.text = tweet.text
    self.retweetCountLabel.text = "\(tweet.retweetCount!)"
    self.favoriteCountLabel.text = "\(tweet.favoriteCount!)"
    
    let formatter = NSDateFormatter()
    formatter.dateStyle = NSDateFormatterStyle.LongStyle
    formatter.timeStyle = .MediumStyle
    let dateString = formatter.stringFromDate(tweet.createdAt!)
    self.createdAtLabel.text = dateString

    var hashtagString = "Hashtags used: "
    if let hashtags = tweet.hashtags {
      for hashtag in hashtags {
        hashtagString += "#\(hashtag) "
      }
    }
    self.hashtagsLabel.text = hashtagString
    if let profileImageData = tweet.profilePic {
      self.profilePicImage.image = UIImage(data: profileImageData)
    }
  }
}

