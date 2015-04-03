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
        let tweet = Tweet()
        if let id = object["id"] as? NSNumber {
          tweet.id = id.integerValue
        }
        if let text = object["text"] as? String {
          tweet.text = text
        }
        if let userInfo = object["user"] as? [String: AnyObject] {
          if let username = userInfo["name"] as? String {
            tweet.username = username
          }
          if let profilePicURL = userInfo["profile_image_url"] as String? {
            tweet.profileImageURL = profilePicURL
          }
        }
        tweets.append(tweet)
      }
    }
    return tweets
  }
  
  class func tweetFromJSONData(data: NSData) -> Tweet {
    var error: NSError?
    let tweet = Tweet()
    
    if let tweetInfo = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: AnyObject] {
        if let id = tweetInfo["id"] as? Int {
          tweet.id = id
        }
        if let text = tweetInfo["text"] as? String {
          tweet.text = text
        }
        if let retweetCount = tweetInfo["retweet_count"] as? Int {
          tweet.retweetCount = retweetCount
        }
        if let createdAt = tweetInfo["created_at"] as? String {
          var dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
          if let date = dateFormatter.dateFromString(createdAt) {
            tweet.createdAt = date
          }
        }
        if let userInfo = tweetInfo["user"] as? [String: AnyObject] {
          if let username = userInfo["name"] as? String {
            tweet.username = username
          }
          if let screenName = userInfo["screen_name"] as? String {
            tweet.screenName = screenName
          }
          if let favoriteCount = userInfo["favourites_count"] as? Int {
            tweet.favoriteCount = favoriteCount
          }
        }
      }
    return tweet
  }
}
