//
//  JHImageHelper.swift
//  MyMusic
//
//  Created by 常健洪 on 15/8/26.
//  Copyright (c) 2015年 常健洪. All rights reserved.
//

import UIKit

func getBrighterImage(originalImage:UIImage) -> UIImage {
    var brighterImage:UIImage
    var context = CIContext(options: nil)
    var inputImage = CIImage(CGImage: originalImage.CGImage)
    
    var filter = CIFilter(name: "CIColorControls")
    filter.setValue(inputImage, forKey: kCIInputImageKey)
    filter.setValue(NSNumber(float: 1), forKey: "inputBrightness")
    filter.setValue(NSNumber(float: 0.5), forKey: "inputSaturation")
    filter.setValue(NSNumber(float: 4), forKey: "inputContrast")
    
    var result: CIImage = filter.outputImage
    var cgImage = context.createCGImage(result, fromRect: result.extent())
    brighterImage = UIImage(CGImage: cgImage)!
    return brighterImage
}

extension UIImage{
    
    func imageWithTintColor(tintColor:UIColor) -> UIImage {
        return imageWithTintColorAndblendMode(tintColor, blendMode: kCGBlendModeDestinationIn)
    }
    
    func imageWithGradientTintColor(tintColor:UIColor) -> UIImage {
        return imageWithTintColorAndblendMode(tintColor, blendMode: kCGBlendModeOverlay)
    }
    
    func imageWithTintColorAndblendMode(tintColor:UIColor, blendMode:CGBlendMode)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        var bounds = CGRectMake(0, 0, self.size.width, self.size.height)
        UIRectFill(bounds)
        
        self.drawInRect(bounds, blendMode: blendMode, alpha: 1.0)
        
        if blendMode.value != kCGBlendModeDestinationIn.value {
            self.drawInRect(bounds, blendMode: kCGBlendModeDestinationIn, alpha: 1.0)
        }
        
        var tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
}
