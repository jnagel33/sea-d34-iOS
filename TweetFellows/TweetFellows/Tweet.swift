//
//  Tweet.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/30/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class Tweet {
  let text: String
  let username: String
  
  init(text: String, username: String) {
    self.text = text
    self.username = username
  }
}
