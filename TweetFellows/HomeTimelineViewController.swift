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
  
  let imageService = ImageService()
  
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
      
      
      LoginService.requestTwitterAccount { (account, error) -> Void in
        if account != nil {
          TwitterService.sharedService.twitterAccount = account
          TwitterService.sharedService.fetchHomeTimeline({ (tweets, errorDescription) -> Void in
            if errorDescription != nil {
              let alert =  UIAlertController(title: "Error", message: errorDescription, preferredStyle: .Alert)
              let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
              alert.addAction(action)
              self.presentViewController(alert, animated: true, completion: nil)
            }
            if tweets != nil {
              self.tweets = tweets!
              self.tableView.reloadData()
              UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.tableView.userInteractionEnabled = true
              })
              self.activityIndicator.stopAnimating()
            }
          })
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
      return tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetTableViewCell
    cell.tag++
    let tag = cell.tag
    cell.textLabel?.text = nil
    cell.usernameLabel?.text = nil
    cell.imageView?.image = nil
    let tweet = tweets[indexPath.row]
    cell.tweetLabel.text = tweet.text
    cell.usernameLabel.text = tweet.username
    cell.profileImage.image = tweet.profileImage
      
    if let image = tweet.profileImage {
      cell.profileImage.image = image
    } else {
        
      self.imageService.fetchProfileImage(tweet.profileImageURL, completionHandler: { [weak self] (image) -> () in
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
    
    let tweet = tweets[indexPath.row]
    let singleTweetContoller = self.storyboard?.instantiateViewControllerWithIdentifier("SingleTweetViewController") as SingleTweetViewController
    
    singleTweetContoller.selectedTweet = tweet
    
    navigationController?.pushViewController(singleTweetContoller, animated: true)
  }
}
