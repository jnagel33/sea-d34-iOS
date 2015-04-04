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
  
  class var sharedService: TwitterService {
    struct Static {
      static var instance: TwitterService?
    }
    
    if Static.instance == nil {
      Static.instance = TwitterService()
    }
    
    return Static.instance!
  }

  var twitterAccount: ACAccount?
  let homeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
  let statusesURL = "https://api.twitter.com/1.1/statuses/show.json"
  let userTimelineURL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
  
  
  init() {
    
  }
  
  func fetchHomeTimeline(parameters: [String: String]?, completionHandler: ([Tweet]?, String?) -> Void) {
    let requestURL = NSURL(string: homeTimelineURL)
    var addedParameters = [String: String]()
    if let params = parameters {
      if let maxId = params["max_id"] {
        addedParameters["max_id"] = maxId
      }
      if let sinceId = params["since_id"] {
        addedParameters["since_id"] = sinceId
      }
    }
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: addedParameters)
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
  
  func fetchTweetInfo(id: String, completionHandler: (Tweet?, String?) -> Void) {
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
          tweet = TweetJSONParser.tweetInfoFromJSONData(data)
        } else {
          errorDescription = status.errorDescription
        }
      }
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(tweet, errorDescription)
      })
    }
  }
  
  func fetchUserTimeline(screenName: String, parameters: [String: String]?, completionHandler: ([Tweet]?, String?) -> Void) {
    let requestURL = NSURL(string: userTimelineURL)
    var addedParameters: [String: String] = ["screen_name": screenName]
    if let params = parameters {
      if let maxId = params["max_id"] {
        addedParameters["max_id"] = maxId
      }
      if let sinceId = params["since_id"] {
        addedParameters["since_id"] = sinceId
      }
    }
    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: addedParameters)
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
  
  private func checkStatusCode(statusCode: Int) -> (readyToParse: Bool, errorDescription: String?) {
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
