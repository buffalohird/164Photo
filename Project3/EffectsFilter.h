//
//  EffectsFilter.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceDetector.h"

@interface EffectsFilter : NSObject

@property (nonatomic, strong) FaceDetector *faceDetector;
@property (nonatomic, strong) NSArray * fxArray;

- (UIImage*)defaultEffects:(int)effect forImage:(UIImage *)image withAlpha:(float)alpha;
- (UIImage*)updateEffects:(int)effect forImage:(UIImage *)image withAlpha:(float)alpha;
- (UIImage *)grayscale:(UIImage *)image withAlpha:(float)alpha;
- (UIImage *)sepia: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)redify: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)overlay:(UIImage *)image withOverlay:(int)overlaySetting andBlendConstant:(int)blendConstant withAlpha:(float)alpha;
- (UIImage *)seventies: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)aged: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)oilSpill: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)sunBath: (UIImage *)image withAlpha:(float)alpha;
- (UIImage *)faceDetection:(UIImage *)image withAlpha:(float)alpha;
@end