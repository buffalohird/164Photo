//
//  UIImage+Crop.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)

- (UIImage *)crop:(CGRect)rect scalable:(BOOL)scaleBool;

@end
