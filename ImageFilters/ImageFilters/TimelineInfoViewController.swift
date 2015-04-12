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
  var timelineImageInfo: TimelineImageInfo!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.imageView.image = ImageResizer.resizeImage(timelineImageInfo.image!, size: self.imageView.frame.size)
    if let messageText = timelineImageInfo.message {
      self.messageLabel.text = messageText
    }
    
  }
}
