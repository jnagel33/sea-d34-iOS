//
//  HomeViewController.swift
//  TweetFellows
//
//  Created by Josh Nagel on 3/30/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var tweets: [Tweet]?
  
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.dataSource = self
      
      if let filePath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
        if let data = NSData(contentsOfFile: filePath) {
          self.tweets = TweetJSONParser.tweetsFromJSONData(data)
        }
      }
    }
  
  //MARK:
  //MARK: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = tweets?.count {
      return count
    } else {
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as UITableViewCell
    let usernameLabel = cell.contentView.viewWithTag(1) as UILabel
    let textLabel = cell.contentView.viewWithTag(2) as UILabel
    usernameLabel.text = tweets![indexPath.row].username
    textLabel.text = tweets![indexPath.row].text
    return cell
  }
}
