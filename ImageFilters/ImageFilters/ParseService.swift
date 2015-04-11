//
//  ParseService.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class ParseService {
  
  class func uploadImageInfo(image: UIImage, message: String?, size: CGSize, completionHandler: (String?) -> Void) {
    let resizedImage = ImageResizer.resizeImage(image, size: size)
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    let imageFile = PFFile(name: "post.jpg", data: imageData)
    let post = PFObject(className: "Post")
    post["imageFile"] = imageFile
    post["message"] = message
    
    post.saveInBackgroundWithBlock { (finished, error) -> Void in
      if error != nil {
        //handle error
      } else {
        println("Successful upload")
        completionHandler(nil)
      }
    }
  }
  
  class func fetchPosts(date: NSDate?, completionHandler: ([PFObject]?, NSError?) -> Void) {
    var query = PFQuery(className: "Post")
    if let lastItemDate = date {
      query.whereKey("createdAt", greaterThan: lastItemDate)
    }
    query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
      if error != nil {
        // handle error
      } else {
        let posts = objects as! [PFObject]
        completionHandler(posts, nil)
      }
    }
  }
  
  class func imageFromPFFile(file: PFFile, size: CGSize, completionHandler: (UIImage?, NSError?) -> Void) {
    file.getDataInBackgroundWithBlock { (data, error) -> Void in
      if error != nil {
        //handle error
      } else {
        if let image = UIImage(data: data!) {
          let resizedImage = ImageResizer.resizeImage(image, size: size)
          completionHandler(resizedImage, nil)
        }
      }
    }
  }
}