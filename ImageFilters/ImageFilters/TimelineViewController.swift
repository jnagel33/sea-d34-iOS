//
//  TimelineViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/8/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UICollectionViewDataSource {

  @IBOutlet var collectionView: UICollectionView!
  
  var timelineImageInfo = [TimelineImage]()
  let refreshControl = UIRefreshControl()
  var lastRefresh = NSDate()
  var images = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
    self.collectionView.userInteractionEnabled = true
    
    self.navigationController!.navigationBar.setBackgroundImage(MyStyleKit.imageOfNavAndTabBarBackground, forBarMetrics: .Default)
    self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
    
    self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.collectionView.addSubview(refreshControl)
    
    var pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchOccured")
    self.collectionView.addGestureRecognizer(pinchRecognizer)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if !self.timelineImageInfo.isEmpty {
      self.fetchTimelinePosts(lastRefresh)
    } else {
      self.fetchTimelinePosts(nil)
    }
  }
  
  func refresh(sender: AnyObject) {
    self.fetchTimelinePosts(self.lastRefresh)
  }
  
  func fetchTimelinePosts(date: NSDate?) {
    ParseService.fetchPosts(date) { (objects, error) -> Void in
      if error != nil {
        //handle error
      } else {
        for (index, object) in enumerate(objects!) {
          let imageFile = object["imageFile"] as! PFFile
          self.timelineImageInfo.append(TimelineImage(file: imageFile))
          self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self.timelineImageInfo.count - 1, inSection: 0)])
        }
      }
      self.refreshControl.endRefreshing()
      self.lastRefresh = NSDate()
      self.collectionView.userInteractionEnabled = true
    }
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.timelineImageInfo.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimelineCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
    cell.imageView.image = nil
    
    let info = self.timelineImageInfo[indexPath.row]
    
    if let image = info.image {
      cell.imageView.image = image
    } else {
      let imageFile = self.timelineImageInfo[indexPath.row].file
      ParseService.imageFromPFFile(imageFile, size: cell.imageView.frame.size, completionHandler: { (image, error) -> Void in
        if error != nil {
          println(error!.description)
        } else {
          info.image = image
          cell.imageView.image = image
        }
      })
    }
    return cell
  }
  
  
}
