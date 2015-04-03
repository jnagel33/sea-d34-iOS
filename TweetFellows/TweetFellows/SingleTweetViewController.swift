//
//  SingleTweetViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/1/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

  let twitterService: TwitterService!
  var selectedTweet: Tweet!
  
  @IBOutlet weak var profileImageButton: UIButton!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var lineSeperatorView: UIView!
  @IBOutlet weak var createdAtLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tweetTextLabel.text = selectedTweet.text
    self.usernameLabel.text = selectedTweet.username
    self.retweetCountLabel.text = "\(selectedTweet.retweetCount)"
    self.favoriteCountLabel.text = "\(selectedTweet.favoriteCount)"
    self.profileImageButton.setBackgroundImage(selectedTweet.profileImage, forState: .Normal)
    self.profileImageButton.layer.cornerRadius = 8.0
    self.profileImageButton.clipsToBounds = true
    self.activityIndicator.startAnimating()
    
    
    UIView.animateWithDuration(1.5, animations: { () -> Void in
      self.tweetTextLabel.alpha = 1
      self.usernameLabel.alpha = 1
      self.screenNameLabel.alpha = 1
      self.retweetCountLabel.alpha = 1
      self.favoriteCountLabel.alpha = 1
      self.lineSeperatorView.alpha = 1
      self.profileImageButton.alpha = 1
      self.createdAtLabel.alpha = 1
    })
    
    
    
    LoginService.requestTwitterAccount { (account, error) -> Void in
      if account != nil {
        TwitterService.sharedService.twitterAccount = account
        TwitterService.sharedService.fetchStatuses(self.selectedTweet.id!) { (tweet, errorDescription) -> Void in
          if errorDescription != nil {
            let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
          } else {
            if let tweetSelected = tweet {
              self.selectedTweet.screenName = tweetSelected.screenName
              self.configureTweet(tweetSelected)
            }
          }
        }
      }
    }
  }
  
  func configureTweet(tweet: Tweet) {
    self.activityIndicator.stopAnimating()
    self.tweetTextLabel.text = tweet.text
    self.screenNameLabel.text = tweet.screenName
    self.retweetCountLabel.text = "\(tweet.retweetCount)"
    self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
    let formatter = NSDateFormatter()
    formatter.dateStyle = NSDateFormatterStyle.LongStyle
    formatter.timeStyle = .MediumStyle
    let dateString = formatter.stringFromDate(tweet.createdAt)
    self.createdAtLabel.text = dateString
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "UserTweets" {
      let destinationController = segue.destinationViewController as UserTweetsTableViewController
      destinationController.username = selectedTweet.username
      destinationController.screenName = selectedTweet.screenName
      destinationController.profileImage = selectedTweet.profileImage
    }
  }
}

