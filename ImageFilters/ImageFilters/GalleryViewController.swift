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

  @IBOutlet var collectionView: UICollectionView!
  
  var assets = PHFetchResult()
  
  let manager = PHCachingImageManager()
  
  var delegate: GalleryImageDelegate?
  
  var imageSizeForPrimaryView: CGSize!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }

  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assets.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as! GalleryCollectionViewCell
    
    let asset = self.assets[indexPath.row] as! PHAsset
    
    let image = self.manager.requestImageForAsset(asset, targetSize: CGSize(width: cell.frame.width, height: cell.frame.height), contentMode: .AspectFill, options: nil) { [weak self] (image, info) -> Void in
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
