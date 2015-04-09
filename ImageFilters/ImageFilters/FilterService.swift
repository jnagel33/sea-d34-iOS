//
//  FilterService.swift
//  ImageFilters
//
//  Created by Josh Nagel on 4/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

import UIKit
import CoreImage

class FilterService {
  
  class func photoEffectTransferFilter(image: UIImage, context: CIContext) -> UIImage {
    let filter = CIFilter(name: "CIPhotoEffectTransfer")
    filter.setDefaults()
    return self.createImageFromFilter(filter, image: image, context: context)
  }
  
  class func sepiaToneFilter(image: UIImage, context: CIContext) -> UIImage {
    let filter = CIFilter(name: "CISepiaTone")
    filter.setValue(0.5, forKey: kCIInputIntensityKey)
    return self.createImageFromFilter(filter, image: image, context: context)
  }
  
  class func photoEffectNoirFilter(image: UIImage, context: CIContext) -> UIImage {
    let filter = CIFilter(name: "CIPhotoEffectNoir")
    return self.createImageFromFilter(filter, image: image, context: context)
  }
  
  class func colorPosterizeFilter(image: UIImage, context: CIContext) -> UIImage {
    let filter = CIFilter(name: "CIColorPosterize")
    filter.setDefaults()
    return self.createImageFromFilter(filter, image: image, context: context)
  }
  
  class func colorInvertFilter(image: UIImage, context: CIContext) -> UIImage {
    let filter = CIFilter(name: "CIColorInvert")
    filter.setDefaults()
    return self.createImageFromFilter(filter, image: image, context: context)
  }
  
  private class func createImageFromFilter(filter: CIFilter?, image: UIImage, context: CIContext) -> UIImage {
    let image = CIImage(image: image)
    filter!.setValue(image, forKey: kCIInputImageKey)
    let result = filter!.valueForKey(kCIOutputImageKey) as CIImage
    let resultRef = context.createCGImage(result, fromRect: result.extent())
    return UIImage(CGImage: resultRef)!

  }
}
