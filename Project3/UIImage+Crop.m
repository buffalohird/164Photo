//
//  UIImage+Crop.m
//  Project3
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

//  Modified by Buffalo Hird
//
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)rect scalable:(BOOL)scaleBool
{
    
    CGFloat scale;
    if(scaleBool == YES)
    {
        scale = [[UIScreen mainScreen] scale];
    }
    
    else
    {
        scale = 1;
    }
    
    if (scale > 1.0)
    {
        rect = CGRectMake(rect.origin.x*scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage ], rect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    return newImage;
}

@end
