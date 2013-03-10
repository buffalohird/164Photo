//
//  EffectsTile.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EffectsFilter.h"

@interface EffectsTile : UIButton {
    
        CALayer *highlightLayer;
}

@property (nonatomic, weak) NSString *effectName;
@property (nonatomic) int effect;
@property (nonatomic, strong) EffectsFilter *effectsFilter;

- (EffectsTile *)setUp:(int)effect;
- (void)createLabel;
- (void)createHighlightLayer;
@end
