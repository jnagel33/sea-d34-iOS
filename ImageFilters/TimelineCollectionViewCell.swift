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
  
  func configureCell(timelineImageInfo: TimelineImage) {
    self.messageLabel.text = nil
    self.imageView.image = nil
    
    self.messageLabel.text = timelineImageInfo.message
    if let image = timelineImageInfo.image {
      self.imageView.image = image
    } else {
      let imageFile = timelineImageInfo.file
      ParseService.imageFromPFFile(imageFile, size: self.imageView.frame.size, completionHandler: { (image, error) -> Void in
        if error != nil {
          println(error!.description)
        } else {
          timelineImageInfo.image = image
          self.imageView.image = image
        }
      })
    }

  }
}
