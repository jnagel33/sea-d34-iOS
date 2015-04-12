//
//  TimelineInfoViewController.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/11/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class TimelineInfoViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  
  var timelineImageInfo: TimelineImageInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageView.image = ImageResizer.resizeImage(timelineImageInfo.image!, size: self.imageView.frame.size)
    self.messageLabel.text = nil
    self.locationLabel.text = nil
    if let messageText = timelineImageInfo.message {
      self.messageLabel.text = messageText
    }
    if let locationText = timelineImageInfo.location {
      self.locationLabel.text = locationText
    }
  }
}
