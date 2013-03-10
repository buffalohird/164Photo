//
//  EffectsTile.m
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectsTile.h"

// each tile's dimensions
#define TILEWIDTH 145
#define TILEHEIGHT 145

@implementation EffectsTile

@synthesize effectName = _effectName;
@synthesize effect = _effect;
@synthesize effectsFilter = _effectsFilter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // custom initialization
    }
    return self;
}

- (void)createHighlightLayer
{
    // what happens when the user clicks. make the settings
    highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = [UIColor colorWithRed: 0.10f
                                                     green: 0.10f
                                                      blue: 0.10f
                                                     alpha: 0.60].CGColor;
    highlightLayer.frame = self.layer.bounds;
    highlightLayer.hidden = YES;
    
    // insert it
    [self.layer insertSublayer:highlightLayer above:self.layer];
}

- (void)setHighlighted:(BOOL)highlight
{
    highlightLayer.hidden = !highlight;
    [super setHighlighted:highlight];
}


- (EffectsTile *)setUp:(int)effect
{
    self.effectsFilter = [[EffectsFilter alloc] init];
    
    // set the label for each effect
    switch (effect)
    {
        case 1:
            self.effectName = @"Normal";
            break;
        case 2:
            self.effectName = @"Black and White";
            break;
        case 3:
            self.effectName = @"Sepia";
            break;
        case 4:
            self.effectName = @"Redify";
            break;
        case 5:
            self.effectName = @"Warholify";
            break;
        case 6:
            self.effectName = @"ColorDip";
            break;
        case 7:
            self.effectName = @"Harvardify";
            break;
        case 8:
            self.effectName = @"Harvardify2";
            break;
        case 9:
            self.effectName = @"seventies";
            break;
        case 10:
            self.effectName = @"aged";
            break;
        case 11:
            self.effectName = @"Oil Spill";
            break;
        case 12:
            self.effectName = @"SunBath";
            break;
        case 13:
            self.effectName = @"FaceDetection";
            break;
        default:
            break;
    }
    
    // sets the image to the image with effects of the type related to the tile
    [self setImage:[self.effectsFilter defaultEffects:self.effect forImage:self.imageView.image withAlpha:1.0] 
          forState:UIControlStateNormal];
    
    // set the dimensions and settings
    self.frame = CGRectMake(0, 0, TILEWIDTH, TILEHEIGHT);
    self.contentMode = UIViewContentModeScaleToFill;
    [self canBecomeFirstResponder];
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    
    //add our fancy label
    [self createLabel];
    
    return self;
}

// creates the label to be added to each tile's image
- (void)createLabel
{
    // make out label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,115,TILEWIDTH,30)];
    label.text = [NSString stringWithFormat: @"%@", self.effectName];
    label.textColor = [UIColor whiteColor];
    label.textAlignment   = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    label.userInteractionEnabled = NO;
    label.exclusiveTouch = NO;
    [self addSubview:label];
}
@end