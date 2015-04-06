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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var tweets = [Tweet]()
  
  var refreshControl:UIRefreshControl!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      self.tableView.dataSource = self
      self.tableView.delegate = self
      let cellNib = UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle())
      self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
      self.activityIndicator.startAnimating()
      self.tableView.userInteractionEnabled = false
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.estimatedRowHeight = 160.0
      self.tableView.alpha = 0
      UIView.animateWithDuration(2.0, animations: { () -> Void in
        self.tableView.alpha = 1
      })
      
      self.refreshControl = UIRefreshControl()
      self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
      self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
      self.tableView.addSubview(refreshControl)
      
      self.getTweets(nil)
  }
  
  func refresh(sender:AnyObject) {
    if !self.tweets.isEmpty {
      if let mostRecentTweet = self.tweets.first {
        self.getTweets(["since_id": mostRecentTweet.id])
      }
    }
    self.tableView.reloadData()
    self.refreshControl.endRefreshing()
  }
  
  func getTweets(parameters: [String: String]?) {
    LoginService.requestTwitterAccount { (account, error) -> Void in
      if account != nil {
        TwitterService.sharedService.twitterAccount = account
        TwitterService.sharedService.fetchHomeTimeline(parameters) { (tweets, errorDescription) -> Void in
          if errorDescription != nil {
            let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
          } else {
            if tweets != nil {
              if self.tweets.isEmpty {
                self.tweets = tweets!
              } else {
                self.tweets += tweets!
              }
            }
            self.checkForRetweets()
          }
        }
      } else {
        let alert = UIAlertController(title: error, message: "TweetFellows needs your Twitter account to be configured properly on your iOS Device Settings", preferredStyle: .Alert)
          let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
          alert.addAction(action)
          self.presentViewController(alert, animated: true, completion: nil)
      }
    }
  }
  
  func checkForRetweets() {
    LoginService.requestTwitterAccount { (account, error) -> Void in
      if account != nil {
        for (index, tweet) in enumerate(self.tweets) {
          var retweetCount: Int = 0
          if self.tweets[index].retweetedId != nil {
            retweetCount++
            TwitterService.sharedService.twitterAccount = account
            TwitterService.sharedService.fetchTweetInfo(self.tweets[index].retweetedId, completionHandler: { (tweet, error) -> Void in
              self.tweets[index] = tweet!
              self.tableView.reloadData()
              self.activityIndicator.stopAnimating()
              UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.tableView.userInteractionEnabled = true
              })
            })
          }
          if retweetCount == 0 {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIView.animateWithDuration(1.0, animations: { () -> Void in
              self.tableView.userInteractionEnabled = true
            })
          }
        }
      } else {
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
      return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
    cell.tag++
    let tag = cell.tag
    cell.textLabel?.text = nil
    cell.usernameLabel?.text = nil
    cell.imageView?.image = nil
    cell.retweetCountLabel.text = nil
    cell.favoritesCountLabel.text = nil
    
    let tweet = self.tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.usernameLabel.text = tweet.username
    cell.retweetCountLabel.text = "\(tweet.retweetCount)"
    cell.favoritesCountLabel.text = "\(tweet.favoriteCount)"
    cell.profileImage.image = tweet.profileImage
      
    if let image = tweet.profileImage {
      cell.profileImage.image = image
    } else {
      ImageService.sharedService.fetchProfileImage(tweet.profileImageURL, completionHandler: { [weak self] (image) -> () in
        if self != nil {
          tweet.profileImage = image
          if tag == cell.tag {
            cell.profileImage.image = tweet.profileImage
            cell.profileImage.layer.cornerRadius = 8.0
            cell.profileImage.clipsToBounds = true
          }
        }
      })
    }
    cell.layoutIfNeeded()
    return cell
  }
  
  //MARK:
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let tweet = self.tweets[indexPath.row]
    let singleTweetContoller = self.storyboard?.instantiateViewControllerWithIdentifier("SingleTweetViewController") as SingleTweetViewController
    singleTweetContoller.selectedTweet = tweet
    navigationController?.pushViewController(singleTweetContoller, animated: true)
  }
  
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    var lastId: String?
    if indexPath.row == self.tweets.count - 4 {
      if let lastTweet = self.tweets.last {
        let param: [String: String] = ["max_id": lastTweet.id]
        self.getTweets(param)
      }
    }
  }
}
