//
//  TimelineImage.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import Foundation

class TimelineImage {
  var file: PFFile
  var image: UIImage?
  var message: String?
  var maxSizeImageLoaded: Bool = false
  
  init(file: PFFile) {
    self.file = file
  }
}
