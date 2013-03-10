//
//  FaceDetector.m
//  Project3
//
//  Created by Buffalo Hird on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceDetector.h"

@implementation FaceDetector

-(UIImage *)setUp:(int)effect forImage:(UIImage *)image withAlpha:(float)alpha
{     
    NSString *accuracy = CIDetectorAccuracyLow;
    NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
    // creates the detector which will discover facial features
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
    
    // creates a core graphics version of the image
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    // finds the facial features discovered by the detector
    NSArray *features = [detector featuresInImage:ciImage];
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
     
    // Flip Context
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    if (scale > 1.0) {
        // Loaded 2x image, scale context to 50%
        CGContextScaleCTM(context, 0.5, 0.5);
    }

    
    for (CIFaceFeature *feature in features)
    {
        
        
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f * 1);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 0.4f);
        
        if (feature.hasLeftEyePosition)
        {
            [self drawFeatureInContext:context atPoint:feature.leftEyePosition];
        }
        if (feature.hasRightEyePosition)
        {
            [self drawFeatureInContext:context atPoint:feature.rightEyePosition];
        }
        if (feature.hasMouthPosition)
        {
            [self drawFeatureInContext:context atPoint:feature.mouthPosition];
        }
        
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}

- (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint 
{
    CGFloat radius = 20.0f * [UIScreen mainScreen].scale;
    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
}



@end
