//
//  Tweet.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/30/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class Tweet {
  var id: String!
  var retweetedId: String!
  var text: String!
  var username: String!
  var retweetCount: Int!
  var favoriteCount: Int!
  var createdAt: NSDate!
  var screenName: String!
  var profileImageURL: String!
  var profileImage: UIImage?
  var profileBackgroundImageURL: String!
  var profileBackgroundImage: UIImage?
  var didRetreivedRetweetInfo = false
  
  
  init() {
    
  }
}
