//
//  UserTweetsTableViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/2/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class UserTweetsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var backgroundImage: UIImage?
  var profileImage: UIImage?
  var username: String!
  var screenName: String!
  var userTweets = [Tweet]()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.activityIndicator.startAnimating()
      self.tableView.userInteractionEnabled = false
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.estimatedRowHeight = 160
      self.tableView.rowHeight = UITableViewAutomaticDimension
      
      let cellNib = UINib(nibName: "TweetTableViewCell", bundle: NSBundle.mainBundle())
      self.tableView.registerNib(cellNib, forCellReuseIdentifier: "TweetCell")
  
      self.usernameLabel.text = self.username
      self.screenNameLabel.text = self.screenName
      self.profileImageView.image = self.profileImage
      self.profileImageView.layer.cornerRadius = 8.0
      self.profileImageView.clipsToBounds = true
      
      self.refreshControl = UIRefreshControl()
      self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
      self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
      self.tableView.addSubview(refreshControl!)
      self.tableView.contentInset = UIEdgeInsets(top: 144, left: 0 ,bottom: 0 , right: 0)
      self.getTweets(nil)
    }
  
  func refresh(sender: AnyObject) {
    if !userTweets.isEmpty {
      if let mostRecentTweet = self.userTweets.first {
        self.getTweets(["since_id": mostRecentTweet.id])
      }
    }
    self.refreshControl!.endRefreshing()
    self.tableView.reloadData()
  }
  
  func getTweets(parameters: [String: String]?) {
    LoginService.requestTwitterAccount { (account, error) -> Void in
      if account != nil {
        TwitterService.sharedService.twitterAccount = account
        TwitterService.sharedService.fetchUserTimeline(self.screenName, parameters: parameters) { (tweets, errorDescription) -> Void in
          if errorDescription != nil {
            let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
          } else {
            if tweets != nil {
              if self.userTweets.isEmpty {
                self.userTweets = tweets!
              } else {
                self.userTweets += tweets!
              }
              if !tweets!.isEmpty {
                let firstTweet = self.userTweets[0]
                ImageService.sharedService.fetchProfileImage(firstTweet.profileBackgroundImageURL, completionHandler: { [weak self] (image) -> () in
                  if self != nil {
                    self!.backgroundImageView.image = image
                  }
                })
              }
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIView.animateWithDuration(1.0, animations: { () -> Void in
              self.tableView.userInteractionEnabled = true
            })
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
        for (index, tweet) in enumerate(self.userTweets) {
          if self.userTweets[index].didRetreivedRetweetInfo == false {
            if self.userTweets[index].retweetedId != nil {
              TwitterService.sharedService.twitterAccount = account
              TwitterService.sharedService.fetchTweetInfo(self.userTweets[index].retweetedId, completionHandler: { (tweet, error) -> Void in
                self.userTweets[index] = tweet!
                self.userTweets[index].didRetreivedRetweetInfo = true
                let indexPathsForReloading = [NSIndexPath(forRow: index, inSection: 0)]
                self.tableView.reloadRowsAtIndexPaths(indexPathsForReloading, withRowAnimation: .Automatic)
              })
            }
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

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.userTweets.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
    let tweet = self.userTweets[indexPath.row]
    cell.configureCell(tweet)
    return cell
  }

  //MARK:
  //MARK: UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let tweet = self.userTweets[indexPath.row]
    let singleTweetContoller = self.storyboard?.instantiateViewControllerWithIdentifier("SingleTweetViewController") as SingleTweetViewController
    singleTweetContoller.selectedTweet = tweet
    navigationController?.pushViewController(singleTweetContoller, animated: true)
  }
  
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    var lastId: String?
    if indexPath.row == userTweets.count - 4 {
      if let lastTweet = userTweets.last {
        let param: [String: String] = ["max_id": lastTweet.id]
        self.getTweets(param)
      }
    }
  }
}
