//
//  PhotoViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import CoreImage

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  let alertController = UIAlertController(title: "Options", message: nil, preferredStyle: .ActionSheet)
  
  @IBOutlet weak var primaryImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    
    let colorInvertFilterAction = UIAlertAction(title: "Color Invert Filter", style: .Default) { (alert) -> Void in
      let colorInvertImage = FilterService.colorInvertFilter(self.primaryImageView.image!)
      self.primaryImageView.image = colorInvertImage
    }
    alertController.addAction(colorInvertFilterAction)
    
    let colorPosterizeFilterAction = UIAlertAction(title: "Color Posterize Filter", style: .Default) { (alert) -> Void in
      let colorPosterizeImage = FilterService.colorPosterizeFilter(self.primaryImageView.image!)
      self.primaryImageView.image = colorPosterizeImage
    }
    alertController.addAction(colorPosterizeFilterAction)

    let photoEffectNoirFilterAction = UIAlertAction(title: "Photo Effect Noir Filter", style: .Default) { (alert) -> Void in
      let photoEffectNoirImage = FilterService.photoEffectNoirFilter(self.primaryImageView.image!)
      self.primaryImageView.image = photoEffectNoirImage
    }
    alertController.addAction(photoEffectNoirFilterAction)

    let photoEffectTransferFilterAction = UIAlertAction(title: "Photo Effect Transfer Filter", style: .Default) { (alert) -> Void in
      let photoEffectTransferImage = FilterService.photoEffectTransferFilter(self.primaryImageView.image!)
      self.primaryImageView.image = photoEffectTransferImage
    }
    alertController.addAction(photoEffectTransferFilterAction)

    let sepiaFilterAction = UIAlertAction(title: "Sepia Filter", style: .Default) { (alert) -> Void in
      let sepiaImage = FilterService.sepiaToneFilter(self.primaryImageView.image!)
      self.primaryImageView.image = sepiaImage
    }
    alertController.addAction(sepiaFilterAction)

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
    }
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}
