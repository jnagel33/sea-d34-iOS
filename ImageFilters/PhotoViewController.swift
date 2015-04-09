//
//  PhotoViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import CoreImage

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

  let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
  
  @IBOutlet weak var photoButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var constraintCollectionViewBottom: NSLayoutConstraint!
  @IBOutlet weak var primaryImageView: UIImageView!
  
  @IBOutlet weak var constraintImageLeading: NSLayoutConstraint!
  @IBOutlet weak var constrantImageTrailing: NSLayoutConstraint!
  @IBOutlet weak var constraintImageTop: NSLayoutConstraint!
  @IBOutlet weak var constraintImageBottom: NSLayoutConstraint!
  
  let constraintcollectionViewBottomInFilter: CGFloat = 8
  let collectionViewHeight: CGFloat = 75
  var originalImageConstraintTopLeadingTrailing: CGFloat = 0
  var originalImageConstraintBottom: CGFloat = 0
  let constraintBuffer: CGFloat = 50
  
  let imageToUploadSize = CGSize(width: 600, height: 600)
  let animationDuration = 0.3
  let thumbnailImageSize = CGSize(width: 75, height: 75)
  var currentThumbnailImage: UIImage!
  var originalThumbnailImage : UIImage!
  var originalImage: UIImage!
  
  let filters = [FilterService.colorInvertFilter, FilterService.photoEffectChromeFilter, FilterService.photoEffectInstantFilter, FilterService.vignetteFilter, FilterService.photoEffectFadeFilter, FilterService.sepiaToneFilter, FilterService.gaussianBlurFilter, FilterService.colorPosterizeFilter, FilterService.photoEffectNoirFilter, FilterService.photoEffectTransferFilter, FilterService.greenMonochromeFilter, FilterService.blueMonochromeFilter, FilterService.hueAdjustFilter]
  var context: CIContext!
  
  var currentImage : UIImage! {
    didSet {
      self.primaryImageView.image = self.currentImage
      self.originalThumbnailImage = ImageResizer.resizeImage(self.currentImage, size: self.thumbnailImageSize)
      self.collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.originalImage = UIImage(named: "photo2.jpg")
    self.currentImage = self.originalImage
    
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.context = CIContext(EAGLContext: eaglContext, options: options)
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    self.originalImageConstraintBottom = self.constraintCollectionViewBottom.constant
    self.originalImageConstraintTopLeadingTrailing = self.constraintImageLeading.constant
    
    self.constraintCollectionViewBottom.constant = -tabBarController!.tabBar.frame.height - collectionViewHeight
    self.constraintImageLeading.constant = self.originalImageConstraintTopLeadingTrailing
    self.constrantImageTrailing.constant = self.originalImageConstraintTopLeadingTrailing
    self.constraintImageTop.constant = self.originalImageConstraintTopLeadingTrailing
    self.constraintImageBottom.constant = self.originalImageConstraintBottom
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let cameraAction = UIAlertAction(title: "Take A Picture", style: .Default) { (alert) -> Void in
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      }
      alertController.addAction(cameraAction)
    }
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
      let photoLibraryAction = UIAlertAction(title: "Choose Existing Photo", style: .Default) { (alert) -> Void in
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      }
      alertController.addAction(photoLibraryAction)
    }
    
    //MARK: UIAlertActions

    let filterAction = UIAlertAction(title: "Filter", style: .Default) { [weak self] (alert) -> Void in
      if self != nil {
        self!.enterFilterMode()
      }
    }
    alertController.addAction(filterAction)
    
    let undoFilterAction = UIAlertAction(title: "Undo Filter", style: .Default) { [weak self] (alert) -> Void in
      if self != nil {
        self!.currentImage = self!.originalImage
      }
    }
    alertController.addAction(undoFilterAction)
    
    let uploadAction = UIAlertAction(title: "Upload", style: .Default) { (alert) -> Void in
      ParseService.uploadImage(self.primaryImageView.image!, size: self.imageToUploadSize, completionHandler: { (error) -> Void in
      })
    }
    alertController.addAction(uploadAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
  }
  
  func enterFilterMode() {
    self.constraintImageLeading.constant += self.constraintBuffer
    self.constrantImageTrailing.constant += self.constraintBuffer
    self.constraintImageTop.constant += self.constraintBuffer
    self.constraintImageBottom.constant += self.constraintBuffer
    self.constraintCollectionViewBottom.constant = self.constraintcollectionViewBottomInFilter
    self.photoButton.enabled = false
    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilterMode")
  }
  
  func exitFilterMode() {
    self.constraintImageLeading.constant = self.originalImageConstraintTopLeadingTrailing
    self.constrantImageTrailing.constant = self.originalImageConstraintTopLeadingTrailing
    self.constraintImageTop.constant = self.originalImageConstraintTopLeadingTrailing
    self.constraintImageBottom.constant = self.originalImageConstraintBottom
    self.constraintCollectionViewBottom.constant = -tabBarController!.tabBar.frame.height - collectionViewHeight
    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      self.view.layoutIfNeeded()
      self.photoButton.enabled = true
    })
    
    self.navigationItem.rightBarButtonItem = nil
  }
  
  @IBAction func photoButtonPressed(sender: UIButton) {
    if let popoverController = self.alertController.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
    }
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  //MARK:
  //MARK: UIImagePickerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    if let photo = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.primaryImageView.image = photo
      self.currentImage = photo
      self.originalImage = photo
    }
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK:
  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! ImageCollectionViewCell
    let filter = self.filters[indexPath.row]
    cell.imageView.image = filter(self.originalThumbnailImage, context: self.context)
    return cell
  }
  
  //MARK:
  //MARK: UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let filter = self.filters[indexPath.row]
    self.currentImage = filter(self.currentImage, context: self.context)
  }
}
