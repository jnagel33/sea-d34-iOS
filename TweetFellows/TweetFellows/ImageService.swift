//
//  ImageService.swift
//  TweetFellows
//
//  Created by Josh Nagel on 4/2/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit

class ImageService {
  
  let imageQueue = NSOperationQueue()
  
  func fetchProfileImage(url : String, completionHandler : (UIImage?) ->()) {
    self.imageQueue.addOperationWithBlock { () -> Void in
      if let url = NSURL(string: url) {
        if let imageData = NSData(contentsOfURL: url) {
          if let image = UIImage(data: imageData) {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(image)
            })
            
          }
        }
      }
    }
    //download the image
  }
}