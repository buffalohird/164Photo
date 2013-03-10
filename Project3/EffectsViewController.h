//
//  EffectsViewController.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectsTile.h"
#import "EditViewController.h"
#import "UIImage+Resize.h"

@interface EffectsViewController : UIViewController <UIScrollViewDelegate>


@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property BOOL pageControlBeingUsed;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) UIImage *previewPhoto;


- (IBAction)done:(id)sender;
- (void)createEffectTile:(int)effect withXCenter: (float)xCenter andYCenter: (float)yCenter;
- (void)tileTouched:(EffectsTile *)tile;
- (void)changePage;
- (void)changeNavTitle:(int)currentPage;
- (void)createThumbnail;

@end
