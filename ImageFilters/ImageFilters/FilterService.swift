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
  
  class func photoEffectTransferFilter(image: UIImage) -> UIImage {
    let image = CIImage(image: image)
    let photoEffectTransferFilter = CIFilter(name: "CIPhotoEffectTransfer")
    photoEffectTransferFilter.setDefaults()
    photoEffectTransferFilter.setValue(image, forKey: kCIInputImageKey)
    return self.createImageFromFilter(photoEffectTransferFilter)
  }
  
  class func sepiaToneFilter(image: UIImage) -> UIImage {
    let image = CIImage(image: image)
    let sepiaToneFilter = CIFilter(name: "CISepiaTone")
    sepiaToneFilter.setValue(0.5, forKey: kCIInputIntensityKey)
    sepiaToneFilter.setValue(image, forKey: kCIInputImageKey)
    return self.createImageFromFilter(sepiaToneFilter)
  }
  
  class func photoEffectNoirFilter(image: UIImage) -> UIImage {
    let image = CIImage(image: image)
    let photoEffectNoirFilter = CIFilter(name: "CIPhotoEffectNoir")
    photoEffectNoirFilter.setValue(image, forKey: kCIInputImageKey)
    return self.createImageFromFilter(photoEffectNoirFilter)
  }
  
  class func colorPosterizeFilter(image: UIImage) -> UIImage {
    let image = CIImage(image: image)
    let colorPosterizeFilter = CIFilter(name: "CIColorPosterize")
    colorPosterizeFilter.setDefaults()
    colorPosterizeFilter.setValue(image, forKey: kCIInputImageKey)
    return self.createImageFromFilter(colorPosterizeFilter)
  }
  
  class func colorInvertFilter(image: UIImage) -> UIImage {
    let image = CIImage(image: image)
    let colorInvertFilter = CIFilter(name: "CIColorInvert")
    colorInvertFilter.setDefaults()
    colorInvertFilter.setValue(image, forKey: kCIInputImageKey)
    return self.createImageFromFilter(colorInvertFilter)
  }
  
  private class func createImageFromFilter(filter: CIFilter) -> UIImage {
    let result = filter.valueForKey(kCIOutputImageKey) as CIImage
    
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let context = CIContext(EAGLContext: eaglContext, options: options)
    
    let resultRef = context.createCGImage(result, fromRect: result.extent())
    return UIImage(CGImage: resultRef)!

  }
}
