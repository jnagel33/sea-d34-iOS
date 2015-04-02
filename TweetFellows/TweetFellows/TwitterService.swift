//
//  TwitterService.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/31/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation
import Social
import Accounts

class TwitterService {
  var twitterAccount: ACAccount?
  let homeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
  let statusesURL = "https://api.twitter.com/1.1/statuses/show.json"
  
  
  init() {
    
  }
  
  func fetchHomeTimeline(completionHandler: ([Tweet]?, String?) -> Void) {
    let requestURL = NSURL(string: homeTimelineURL)
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = twitterAccount
    
    twitterRequest.performRequestWithHandler { (data, response, error) -> Void in
      if error != nil {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(nil, error.description)
        })
      } else {
        var errorDescription: String?
        var tweets = [Tweet]()
        switch response.statusCode {
        case 200...299:
          tweets = TweetJSONParser.tweetsFromJSONData(data)
        case 400...499:
          errorDescription = "Oops, please try again."
        case 500...599:
          errorDescription = "Service is down, please try again later."
        default:
          errorDescription = "Try again"
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(tweets, errorDescription)
        })
        
      }
    }
  }
  
  func fetchStatuses(id: Int, completionHandler: (Tweet?, String?) -> Void) {
    let requestURL = NSURL(string: statusesURL)
    let parameter = ["id": "\(id)"]
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameter)
    twitterRequest.account = twitterAccount
    
    twitterRequest.performRequestWithHandler { (data, response, error) -> Void in
      if error != nil {
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(nil, error.description)
        })
      } else {
        var errorDescription: String?
        var tweet = Tweet()
        switch response.statusCode {
        case 200...299:
          tweet = TweetJSONParser.tweetFromJSONData(data)
        case 400...499:
          errorDescription = "Oops, please try again."
        case 500...599:
          errorDescription = "Service is down, please try again later."
        default:
          errorDescription = "Try again"
        }
        
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          completionHandler(tweet, errorDescription)
        })
        
      }
    }

  }
}
