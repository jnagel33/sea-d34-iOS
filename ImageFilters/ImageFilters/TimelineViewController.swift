//
//  TimelineViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/8/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UICollectionViewDataSource {

  var flowLayout: UICollectionViewFlowLayout!
  @IBOutlet var collectionView: UICollectionView!
  
  var timelineImageInfo = [TimelineImage]()
  let refreshControl = UIRefreshControl()
  var lastRefresh = NSDate()
  var images = [UIImage]()
  var imageSize: CGSize?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
    self.collectionView.userInteractionEnabled = true
    self.flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
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
      self.fetchTimelinePosts(self.lastRefresh)
    } else {
      self.fetchTimelinePosts(nil)
    }
  }
  
  func refresh(sender: AnyObject) {
    self.refreshControl.beginRefreshing()
    self.fetchTimelinePosts(self.lastRefresh)
    self.refreshControl.endRefreshing()
  }
  
  func fetchTimelinePosts(date: NSDate?) {
    ParseService.fetchPosts(date) { (objects, error) -> Void in
      if error != nil {
        println(error!.description)
      } else {
        for (index, object) in enumerate(objects!) {
          let imageFile = object["imageFile"] as! PFFile
          let message = object["message"] as? String
          var imageInfo = TimelineImage(file: imageFile)
          imageInfo.message = message
          if date != nil {
            self.timelineImageInfo.insert(imageInfo, atIndex: 0)
            self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
          } else {
            self.timelineImageInfo.append(imageInfo)
            self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self.timelineImageInfo.count - 1, inSection: 0)])
          }
        }
      }
      self.lastRefresh = NSDate()
      self.collectionView.userInteractionEnabled = true
    }
  }
  
  func pinchOccurred(sender: UIPinchGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.Changed {
      
      
      let maxSize = self.collectionView.frame.size
      let minSize = CGSize(width: 50, height: 50)
      let oldSize = self.flowLayout.itemSize
      var newSize = CGSize(width: oldSize.width * sender.scale, height: oldSize.height * sender.scale)
      if newSize.width >= maxSize.width {
        newSize = CGSize(width: maxSize.width, height: maxSize.width - 50)
      } else if newSize.width <= minSize.height {
        newSize = minSize
      }
      self.flowLayout.itemSize = newSize
    } else if sender.state == UIGestureRecognizerState.Ended {
      self.collectionView.performBatchUpdates({ () -> Void in
        self.flowLayout.invalidateLayout()
        self.collectionView.reloadData()
        }, completion: nil)
    }
    
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.timelineImageInfo.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCollectionViewCell
    let cellImageHeightPercentageDifferential = cell.imageView.frame.height / cell.frame.height
    var imageFrameSize = CGSize(width: self.flowLayout.itemSize.width, height: self.flowLayout.itemSize.height * cellImageHeightPercentageDifferential)
//    println("test 2 \(self.flowLayout.itemSize.height * cellImageHeightPercentageDifferential)")
//    println("test 2 \(self.flowLayout.itemSize.width)")
//    cell.imageView.frame.size = imageFrameSize
//    println("\(cell.imageView.frame.width) imageview width")
//    println("\(cell.imageView.frame.height) imageview height")
//    println(self.flowLayout.itemSize.width)
//    println(self.flowLayout.itemSize.width)
    let info = timelineImageInfo[indexPath.row]
    cell.configureCell(info)
    return cell
  }
  
  
}
