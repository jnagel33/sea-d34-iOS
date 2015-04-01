//
//  HomeViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/30/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit


class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  let twitterService = TwitterService()
  
  var tweets = [Tweet]()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.dataSource = self
      self.tableView.delegate = self
      
      LoginService.requestTwitterAccount { (account, error) -> Void in
        if account != nil {
          self.twitterService.twitterAccount = account
          self.twitterService.fetchHomeTimeline({ (tweets, errorDescription) -> Void in
            if errorDescription != nil {
            //TODO
            }
            if tweets != nil {
              self.tweets = tweets!
              self.tableView.reloadData()
            }
          })
        } else {
          let alert = UIAlertController(title: error, message: "TweetFellows needs your Twitter account to be configured properly on your iPhone Settings", preferredStyle: .Alert)
          let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
          alert.addAction(action)
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  
  //MARK:
  //MARK: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.tweets.count == 0 {
      // Row will be created to tell user that no tweets were found
      return 1
    } else {
      return tweets.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
    if self.tweets.count == 0 {
      cell.usernameLabel.text = ""
      cell.tweetTextLabel.text = "No tweets found"
    } else {
      cell.usernameLabel.text = tweets[indexPath.row].username
      cell.tweetTextLabel.text = tweets[indexPath.row].text
    }
    return cell
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
