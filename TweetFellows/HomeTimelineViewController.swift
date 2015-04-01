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
  
  var isLoading = false
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.dataSource = self
      self.tableView.delegate = self
      
      var cellNib = UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle())
      self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
      cellNib = UINib(nibName: "LoadingTableViewCell", bundle: NSBundle.mainBundle())
      self.tableView.registerNib(cellNib, forCellReuseIdentifier: "LoadingCell")
      cellNib = UINib(nibName: "NothingFoundTableViewCell", bundle: NSBundle.mainBundle())
      self.tableView.registerNib(cellNib, forCellReuseIdentifier: "NothingFoundCell")
      
      self.isLoading = true
      
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.estimatedRowHeight = 160.0
      
      
      
      LoginService.requestTwitterAccount { (account, error) -> Void in
        if account != nil {
          self.twitterService.twitterAccount = account
          self.twitterService.fetchHomeTimeline({ (tweets, errorDescription) -> Void in
            if errorDescription != nil {
              self.isLoading = false
              self.tableView.reloadData()
              let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
              let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
              alert.addAction(action)
              self.presentViewController(alert, animated: true, completion: nil)
            }
            if tweets != nil {
              self.tweets = tweets!
              self.isLoading = false
              self.tableView.reloadData()
            }
          })
        } else {
          self.isLoading = false
          self.tableView.reloadData()
          let alert = UIAlertController(title: error, message: "TweetFellows needs your Twitter account to be configured properly on your iOS Device Settings", preferredStyle: .Alert)
          let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
          alert.addAction(action)
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  
  //MARK:
  //MARK: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // If the tweets is empty then you must either be loading or nothing was found. Create a row to display status to the user
    if self.tweets.count == 0 {
      return 1
    } else {
      return tweets.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if self.tweets.count == 0 && self.isLoading {
      return tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as LoadingTableViewCell
    } else if self.tweets.count == 0 {
      return tableView.dequeueReusableCellWithIdentifier("NothingFoundCell", forIndexPath: indexPath) as UITableViewCell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
      cell.textLabel?.text = nil
      cell.usernameLabel?.text = nil
      cell.usernameLabel.text = self.tweets[indexPath.row].username
      cell.tweetTextLabel.text = self.tweets[indexPath.row].text
      return cell
    }
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
