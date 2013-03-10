//
//  ThirdViewController.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "storage.h"
#import <QuartzCore/QuartzCore.h>

@interface ThirdViewController : UIViewController

@property (assign, nonatomic, readwrite) int index;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImageView * galleryView;
@property (nonatomic) BOOL emptyGallery;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSArray *stockImages;
@property (nonatomic) BOOL firstLoad;
@property (nonatomic) int imageLocation;
@property (nonatomic) int totalImages;
@property (nonatomic, strong) UIButton *robButton;
@property (nonatomic, strong) UIImageView * easterView;

- (BOOL)loadImages;
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender;
- (IBAction)deletePhoto:(id)sender;
- (UIImage *)findLastPhoto;
- (int)findLeft;
- (int)findRight;
- (void)easter;
@end
