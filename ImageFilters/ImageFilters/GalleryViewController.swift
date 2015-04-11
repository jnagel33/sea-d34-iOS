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
  
  var collectionViewCellSize = CGSize(width: 300, height: 300)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
//    var pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchOccurred:")
//    self.collectionView.addGestureRecognizer(pinchRecognizer)
  }
//  
//  func pinchOccurred(sender: UIPinchGestureRecognizer) {
//    var maxWidthHeight: CGFloat = 300
//    var minWidthHeight: CGFloat = 33
//    if sender.state == UIGestureRecognizerState.Changed {
//      var newWidthHeight: CGFloat = self.collectionViewCellSize.width * (sender.scale / 0.50)
//      if newWidthHeight >= maxWidthHeight {
//        newWidthHeight = maxWidthHeight
//      } else if newWidthHeight <= minWidthHeight {
//        newWidthHeight = minWidthHeight
//      }
//      self.flowLayout.itemSize = CGSize(width: newWidthHeight, height: newWidthHeight)
//      
//      
//      self.collectionView.performBatchUpdates({ () -> Void in
//        self.flowLayout.invalidateLayout()
//        }, completion: nil)
//    } else if sender.state == UIGestureRecognizerState.Ended {
//      self.collectionViewCellSize = self.flowLayout.itemSize
//    }
//  }

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
