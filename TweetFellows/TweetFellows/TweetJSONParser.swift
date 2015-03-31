//
//  TweetJSONParser.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/30/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class TweetJSONParser {
  
  class func tweetsFromJSONData(data: NSData) -> [Tweet] {
    var tweets = [Tweet]()
    var error: NSError?
    
    if let jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [[String: AnyObject]] {
      for object in jsonObject {
        var tweetText: String = ""
        var tweetUsername: String = ""
        if let text = object["text"] as? String {
          tweetText = text
        }
        if let user = object["user"] as? [String: AnyObject] {
          if let username = user["name"] as? String {
            tweetUsername = username
          }
        }
        let tweet = Tweet(text: tweetText, username: tweetUsername)
        tweets.append(tweet)
      }
    }
    return tweets
  }
  
}
