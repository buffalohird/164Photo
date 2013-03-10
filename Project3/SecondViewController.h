//
//  SecondViewController.h
//  Project3
//
//  Created by Buffalo Hird on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectsViewController.h"

@interface SecondViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, retain) UIImageView * photoView;
@property (nonatomic, retain) IBOutlet UIButton *chooseButton;
@property (nonatomic, retain) IBOutlet UIButton *takeButton;
@property (nonatomic, retain) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) UIImage *pin;
@property (nonatomic, strong) UIImageView* pinViewLeft;
@property (nonatomic, strong) UIImageView* pinViewRight;


- (IBAction)getPhoto:(id)sender;
- (IBAction)sendPhoto:(id)sender;

@end
