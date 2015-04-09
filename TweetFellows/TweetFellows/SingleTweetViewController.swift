//
//  SingleTweetViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/1/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  var twitterService: TwitterService!
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
    self.tweetTextLabel.text = self.selectedTweet.text
    self.usernameLabel.text = self.selectedTweet.username
    self.screenNameLabel.text = self.selectedTweet.screenName
    self.retweetCountLabel.text = "\(self.selectedTweet.retweetCount)"
    self.favoriteCountLabel.text = "\(self.selectedTweet.favoriteCount)"
    self.profileImageButton.setBackgroundImage(self.selectedTweet.profileImage, forState: .Normal)
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    dateFormatter.timeStyle = .MediumStyle
    self.createdAtLabel.text = dateFormatter.stringFromDate(self.selectedTweet.createdAt)
    
    self.profileImageButton.layer.cornerRadius = 8.0
    self.profileImageButton.clipsToBounds = true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "UserTweets" {
      let destinationController = segue.destinationViewController as! UserTweetsTableViewController
      destinationController.username = self.selectedTweet.username
      destinationController.screenName = self.selectedTweet.screenName
      destinationController.profileImage = self.selectedTweet.profileImage
    }
  }
}

