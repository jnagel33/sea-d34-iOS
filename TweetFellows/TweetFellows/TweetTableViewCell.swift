//
//  TweetTableViewCell.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/2/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favoritesCountLabel: UILabel!
  
  func configureCell(tweet: Tweet) {
    self.tag++
    let tag = self.tag
    self.textLabel!.text = nil
    self.usernameLabel!.text = nil
    self.imageView!.image = nil
    self.retweetCountLabel.text = nil
    self.favoritesCountLabel.text = nil
    
    self.tweetLabel.text = tweet.text
    self.usernameLabel.text = tweet.username
    self.retweetCountLabel.text = "\(tweet.retweetCount)"
    self.favoritesCountLabel.text = "\(tweet.favoriteCount)"
    self.profileImage.image = tweet.profileImage
    
    if let image = tweet.profileImage {
      self.profileImage.image = image
    } else {
      ImageService.sharedService.fetchProfileImage(tweet.profileImageURL, completionHandler: { [weak self] (image) -> () in
        if self != nil {
          tweet.profileImage = image
          if tag == self!.tag {
            self!.profileImage.image = tweet.profileImage
            self!.profileImage.layer.cornerRadius = 8.0
            self!.profileImage.clipsToBounds = true
          }
        }
      })
    }
    self.layoutIfNeeded()
  }
}
