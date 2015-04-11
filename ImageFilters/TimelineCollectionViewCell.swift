//
//  TimelineCollectionViewCell.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/10/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
    
  @IBOutlet weak var messageLabel: UILabel!
  
  
  func configureCell(timelineImageInfo: TimelineImageInfo) {
    self.tag++
    let tag = self.tag
    self.messageLabel.text = nil
    self.imageView.image = nil
    if timelineImageInfo.image != nil && timelineImageInfo.image?.size.height >= self.imageView.frame.height {
      self.imageView.image = timelineImageInfo.image
    } else {
      self.messageLabel.text = timelineImageInfo.message
      let imageFile = timelineImageInfo.file
      ParseService.imageFromPFFile(imageFile, size: self.imageView.frame.size, completionHandler: { [weak self] (image, error) -> Void in
        if self != nil {
          if error != nil {
            //handle error
          } else {
            if tag == self!.tag {
              timelineImageInfo.image = image
              self!.imageView.image = image
            }
          }
        }
      })
    }
  }
}
