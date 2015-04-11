//
//  GalleryViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import Photos

protocol GalleryImageDelegate : class {
  func imageForPrimaryView(image: UIImage) -> Void
}

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  @IBOutlet var collectionView: UICollectionView!
  
  var assets = PHFetchResult()
  let manager = PHCachingImageManager()
  var delegate: GalleryImageDelegate?
  var imageSizeForPrimaryView: CGSize!
  var collectionViewCellSize = CGSize(width: 100, height: 100)
  let imageViewBuffer: CGFloat = 50
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    var pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchOccurred:")
    self.collectionView.addGestureRecognizer(pinchRecognizer)
  }
  
  func pinchOccurred(sender: UIPinchGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.Changed {
      var maxSizeForCell = self.collectionView.frame.size
      let minSizeForCell = CGSize(width: 75, height: 75)
      let oldSize = self.flowLayout.itemSize
      var newSize = CGSize(width: oldSize.width * sender.scale, height: oldSize.height * sender.scale)
      if newSize.width >= maxSizeForCell.width {
        newSize = CGSize(width: maxSizeForCell.width, height: maxSizeForCell.width - self.imageViewBuffer)
      } else if newSize.width <= minSizeForCell.height {
        newSize = minSizeForCell
      }
      self.flowLayout.itemSize = newSize
    } else if sender.state == UIGestureRecognizerState.Ended {
      self.collectionView.performBatchUpdates({ () -> Void in
        self.flowLayout.invalidateLayout()
        }, completion: nil)
      if self.flowLayout.itemSize.width == self.collectionView.frame.size.width{
        self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0), NSIndexPath(forItem: 1, inSection: 0)])
      }
    }
  }

  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assets.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
    let asset = self.assets[indexPath.row] as! PHAsset
    let image = self.manager.requestImageForAsset(asset, targetSize: self.collectionViewCellSize, contentMode: .AspectFill, options: nil) { [weak self] (image, info) -> Void in
      if self != nil {
        cell.imageView.image = image
      }
    }
    return cell
  }
  
  //MARK:
  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let asset = self.assets[indexPath.row] as! PHAsset
    let image = self.manager.requestImageForAsset(asset, targetSize: self.imageSizeForPrimaryView, contentMode: .AspectFill, options: nil) { [weak self] (image, info) -> Void in
      if self != nil {
        self!.delegate?.imageForPrimaryView(image)
        self!.navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
}
