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
  
  
  init() {
    
  }
  
  func fetchHomeTimeline(completionHandler: ([Tweet]?, String?) -> Void) {
    let requestURL = NSURL(string: homeTimelineURL)
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
    twitterRequest.account = twitterAccount
    
    twitterRequest.performRequestWithHandler { (data, response, error) -> Void in
      var errorDescription: String?
      var tweets: [Tweet]?
      if error != nil {
        errorDescription = error.description
      } else {
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
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(tweets, errorDescription)
      })
    }
  }
}
