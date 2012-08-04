//
//  +UIImage.h
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/27/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (scale)

- (UIImage *)scaleToSize: (CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (CGSize) aspectScaledImageSizeForImageView:(UIImageView *)iv image:(UIImage *)im;

@end
