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
    let parameters: [String: AnyObject] = ["count": "100"]
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameters)
    twitterRequest.account = twitterAccount
    
    twitterRequest.performRequestWithHandler { (data, response, error) -> Void in
      var errorDescription: String? = nil
      var tweets: [Tweet]? = nil
      if error != nil {
        errorDescription = error.description
      } else {
        let status = self.checkStatusCode(response.statusCode)
        if status.readyToParse {
          tweets = TweetJSONParser.tweetsFromJSONData(data)
        } else {
          errorDescription = status.errorDescription
        }
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(tweets, errorDescription)
      })
    }
  }
  
  func fetchStatuses(id: Int, completionHandler: (Tweet?, String?) -> Void) {
    let requestURL = NSURL(string: statusesURL)
    let parameter = ["id": "\(id)"]
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: parameter)
    twitterRequest.account = twitterAccount
    
    twitterRequest.performRequestWithHandler { (data, response, error) -> Void in
      var errorDescription: String? = nil
      var tweet: Tweet? = nil
      if error != nil {
        errorDescription = error.description
      } else {
        let status = self.checkStatusCode(response.statusCode)
        if status.readyToParse {
          tweet = TweetJSONParser.tweetFromJSONData(data)
        } else {
          errorDescription = status.errorDescription
        }
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(tweet, errorDescription)
      })
    }
  }
  
  func checkStatusCode(statusCode: Int) -> (readyToParse: Bool, errorDescription: String?) {
    var readyToParse: Bool = false
    var errorDescription: String? = nil
    switch statusCode {
    case 200...299:
      readyToParse = true
    case 400...499:
      errorDescription = "Oops, please try again."
    case 500...599:
      errorDescription = "Service is down, please try again later."
    default:
      errorDescription = "Try again"
    }
    return (readyToParse, errorDescription)
  }
}
