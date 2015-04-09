//
//  ParseService.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class ParseService {
  
  class func uploadImage(image: UIImage, size: CGSize, completionHandler: (String?) -> Void) {
    let resizedImage = ImageResizer.resizeImage(image, size: size)
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    let imageFile = PFFile(name: "post.jpg", data: imageData)
    let post = PFObject(className: "Post")
    post["imageFile"] = imageFile
    
    post.saveInBackgroundWithBlock { (finished, error) -> Void in
      if error != nil {
        //handle error
      } else {
        println("Successful upload")
        completionHandler(nil)
      }
    }
  }
  
}