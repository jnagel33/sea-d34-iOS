//
//  TimelineViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/8/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UICollectionViewDataSource {

  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  @IBOutlet var collectionView: UICollectionView!
  
  var timelineImageInfo = [TimelineImage]()
  let refreshControl = UIRefreshControl()
  var lastRefresh = NSDate()
  var images = [UIImage]()
//  var collectionViewCellSize = CGSize(width: 100, height: 130)
  
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
    
    var pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchOccurred:")
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
          let message = object["message"] as? String
          var imageInfo = TimelineImage(file: imageFile)
          imageInfo.message = message
          self.timelineImageInfo.append(imageInfo)
          self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self.timelineImageInfo.count - 1, inSection: 0)])
        }
      }
      self.refreshControl.endRefreshing()
      self.lastRefresh = NSDate()
      self.collectionView.userInteractionEnabled = true
    }
  }
  
  func pinchOccurred(sender: UIPinchGestureRecognizer) {
    var maxWidth: CGFloat = 320
    var minWidth: CGFloat = 60
    var maxHeight: CGFloat = 320
    var minHeight: CGFloat = 80
    if sender.state == UIGestureRecognizerState.Changed {
      var newWidth: CGFloat = self.flowLayout.itemSize.width * (sender.scale)
      var newHeight: CGFloat = self.flowLayout.itemSize.height * (sender.scale)
      if newWidth >= maxWidth {
        newWidth = maxWidth
        newHeight = maxHeight
      } else if newWidth <= minWidth {
        newWidth = minWidth
        newHeight = minHeight
      }
      self.flowLayout.itemSize = CGSize(width: newWidth, height: newHeight)
      
      
      self.collectionView.performBatchUpdates({ () -> Void in
        self.flowLayout.invalidateLayout()
      }, completion: nil)
    } else if sender.state == UIGestureRecognizerState.Ended {
//      self.collectionViewCellSize = self.flowLayout.itemSize
    }
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.timelineImageInfo.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell
    let info = timelineImageInfo[indexPath.row]
    cell.configureCell(info)
    return cell
  }
  
  
}
