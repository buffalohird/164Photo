//
//  EditViewController.h
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EffectsFilter.h"
#import "UIImage+Crop.h"
#import "Storage.h"
#import "CropView.h"

@interface EditViewController : UIViewController {
    CGPoint _translation;
    IBOutlet UISlider *slider;
    CGPoint _cropStartPoint;
}


@property (nonatomic, retain) UIImage *photo;
@property (nonatomic) int effect;
@property (nonatomic, retain) NSString *effectName;
@property (weak, nonatomic) IBOutlet UIImageView *topBar;
@property (nonatomic, retain) UIImageView *photoView;
@property (nonatomic, strong) EffectsFilter *effectsFilter;
@property (assign, nonatomic, readwrite) float scale;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) BOOL cropActive;
@property (strong, nonatomic)UIButton *confirmCropButton;
@property (strong, nonatomic)UIButton *endCropButton;
@property (strong, nonatomic)CropView *cropView;



- (IBAction)done:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)cropPhoto:(id)sender;
- (IBAction)changeAlpha:(id)sender;
- (void)commitCropPhoto;
- (void)panCrop:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)endCropPhoto;
- (void)pinTouched:(UIButton *)pin withEvent:(UIEvent *)event;

@end
