//
//  CropView.h
//  Project3
//
//  Created by Buffalo Hird on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropView : UIImageView

@property (strong, nonatomic) UIButton *topLeftPin;
@property (strong, nonatomic) UIButton *topRightPin;
@property (strong, nonatomic) UIButton *bottomLeftPin;
@property (strong, nonatomic) UIButton *bottomRightPin;

-(void)finalize;
-(void)redraw;
@end
