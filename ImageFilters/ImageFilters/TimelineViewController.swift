//
//  TimelineViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/8/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  var flowLayout: UICollectionViewFlowLayout!
  @IBOutlet var collectionView: UICollectionView!
  
  var timelineImageInfo = [TimelineImageInfo]()
  let refreshControl = UIRefreshControl()
  var lastRefresh = NSDate()
  var selectedImage: TimelineImageInfo?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
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
    ParseService.fetchPosts(date) { [weak self] (objects, error) -> Void in
      if self != nil {
        if error != nil {
          println(error!.description)
        } else {
          for (index, object) in enumerate(objects!) {
            let imageFile = object["imageFile"] as! PFFile
            let message = object["message"] as? String
            let location = object["location"] as? String
            var imageInfo = TimelineImageInfo()
            imageInfo.file = imageFile
            imageInfo.message = message
            imageInfo.location = location
            if date != nil {
              self!.timelineImageInfo.insert(imageInfo, atIndex: 0)
              self!.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            } else {
              self!.timelineImageInfo.append(imageInfo)
              self!.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self!.timelineImageInfo.count - 1, inSection: 0)])
            }
          }
        }
        self!.lastRefresh = NSDate()
        self!.refreshControl.endRefreshing()
        self!.collectionView.userInteractionEnabled = true
      }
    }
  }
  
  func pinchOccurred(sender: UIPinchGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.Changed {
      var maxSizeForCell = self.collectionView.frame.size
      let minSizeForCell = CGSize(width: 75, height: 75)
      let oldSize = self.flowLayout.itemSize
      var newSize = CGSize(width: oldSize.width * sender.scale, height: oldSize.height * sender.scale)
      if newSize.width >= maxSizeForCell.width {
        newSize = CGSize(width: maxSizeForCell.width, height: maxSizeForCell.width)
      } else if newSize.width <= minSizeForCell.height {
        newSize = minSizeForCell
      }
      self.flowLayout.itemSize = newSize
    } else if sender.state == UIGestureRecognizerState.Ended {
      self.collectionView.performBatchUpdates({ () -> Void in
        self.collectionView.reloadData()
        self.flowLayout.invalidateLayout()
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
    let info = timelineImageInfo[indexPath.row]
    cell.configureCell(info)
    return cell
  }
  
  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    self.selectedImage = self.timelineImageInfo[indexPath.row]
    self.performSegueWithIdentifier("ShowTimelineInfo", sender: self)
  }
  
  //MARK: Prepare for segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowTimelineInfo" {
      let destinationController = segue.destinationViewController as! TimelineInfoViewController
      destinationController.timelineImageInfo = self.selectedImage
    }
  }
}
