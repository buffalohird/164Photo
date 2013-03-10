//
//  CropView.m
//  Project3
//
//  Created by Buffalo Hird on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CropView.h"

#define pinDimension 48

@implementation CropView

@synthesize topLeftPin = _topLeftPin;
@synthesize topRightPin = _topRightPin;
@synthesize bottomLeftPin = _bottomLeftPin;
@synthesize bottomRightPin = _bottomRightPin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)finalize
{

}

-(void)redraw
{
    // redraws the pins in the right corners, so that one must only worry if the pins move properly when dragged.
    self.topLeftPin.frame = CGRectMake(0,0, pinDimension, pinDimension);
    self.bottomLeftPin.frame = CGRectMake(0,self.frame.size.height - pinDimension,pinDimension,pinDimension);
    self.topRightPin.frame = CGRectMake(self.frame.size.width - pinDimension, 0, pinDimension, pinDimension);
    self.bottomRightPin.frame = CGRectMake(self.frame.size.width - pinDimension, self.frame.size.height - pinDimension,pinDimension, pinDimension);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
