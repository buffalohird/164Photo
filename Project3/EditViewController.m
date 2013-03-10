//
//  EditViewController.m
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"

// width and height of the crop "pins"
#define pinDimension 48

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize photo = _photo;
@synthesize effect = _effect;
@synthesize effectName = _effectName;
@synthesize topBar = _topBar;
@synthesize photoView = _photoView;
@synthesize effectsFilter = _effectsFilter;
@synthesize scale = _scale;
@synthesize slider = _slider;
@synthesize cropActive = _cropActive;
@synthesize confirmCropButton = _confirmCropButton;
@synthesize endCropButton = _endCropButton;
@synthesize cropView = _cropView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup the background
    UIImage *grid = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"grid" ofType:@"jpg"]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:grid];
    
    [self.slider setMinimumValue:0.0];
    [self.slider setMaximumValue:100.0];
    [self.slider setValue:100.0];
    
    // values for image scale/position manipulation ( a la lecture)
    self.scale = 1.0;
    _translation.x = 0.0;
    _translation.y = 0.0;
    
    // disallow multiple tiles from being touched at once
    self.view.multipleTouchEnabled = YES;
    // prepare our effects applying object
    self.effectsFilter = [[EffectsFilter alloc] init];
    
    
    self.photoView = [[UIImageView alloc] init];
    
    // do the default effects to the image for whichever filter
    self.photoView.image = [self.effectsFilter defaultEffects:self.effect forImage:self.photo withAlpha:1.0];
    
    self.photoView.frame = CGRectMake(0.0,64.0, 320.0, 352.0);
    self.photoView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoView.userInteractionEnabled = YES;
    self.photoView.multipleTouchEnabled = YES;
    
    self.photoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.photoView.layer.shadowOffset = CGSizeMake(50.0, 50.0);
    self.photoView.layer.shadowOpacity = 1.0;
    self.photoView .layer.shadowRadius = 70.0;
    self.photoView.clipsToBounds = NO;
    
    [self.view insertSubview:self.photoView belowSubview:self.topBar];
    
    // listen for pan
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.photoView addGestureRecognizer:panGesture];
    
    // listen for pinch
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.photoView addGestureRecognizer:pinchGesture];
    
    
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    // translate Tommy
    CGPoint translation = [sender translationInView:self.photoView];
    CGAffineTransform scale = CGAffineTransformMakeScale(self.scale, self.scale);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(_translation.x + translation.x * self.scale, _translation.y + translation.y * self.scale);
    sender.view.transform = CGAffineTransformConcat(scale, translate);
    
    // remember translation once done panning
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _translation.x += translation.x * self.scale;
        _translation.y += translation.y * self.scale;       
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{    
    CGFloat factor = [sender scale];
    // scale Tommy
    if(self.scale >= 4.0 && factor > 1.0)
        factor = 1;
    else if(self.scale <= 0.8  && factor < 1.0)
        factor = 1;
    else
    {
        
        
        CGAffineTransform scale = CGAffineTransformMakeScale(self.scale * factor, self.scale * factor);
        CGAffineTransform translate = CGAffineTransformMakeTranslation(_translation.x, _translation.y);
        sender.view.transform = CGAffineTransformConcat(scale, translate);
    }
    
    // remember scale once done pinching
    if (sender.state == UIGestureRecognizerStateEnded)
        // resize image if beyond arbitrary bounds (bounce back to a reasonable size)
        self.scale *= factor;
    
    
    
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated: YES];
}


- (IBAction)savePhoto:(id)sender
{
    
    // connects to storage and sends the user back to the main view if saving is succesful
    Storage *storage = [[Storage alloc] init];
    if([storage save:self.photoView.image] == YES)
    {       
        [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    else
        NSLog(@"saving error");
    
    
}

- (IBAction)cropPhoto:(id)sender
{
    // bool to prevemt multi-clicking of crop button
    if(self.cropActive == NO)
    {
        self.cropActive = YES;
        
        // center the crop in the middle of the image with the image's aspectRatio
        self.cropView = [[CropView alloc] initWithFrame:CGRectMake(self.photoView.center.x - self.photoView.frame.size.width / 4,
                                                                   self.photoView.center.y - self.photoView.frame.size.height / 4,
                                                                   self.photoView.frame.size.width / 2,
                                                                   self.photoView.frame.size.height / 2)];
        self.cropView.userInteractionEnabled = YES;
        self.cropView.multipleTouchEnabled = YES;
        self.cropView.backgroundColor = [UIColor whiteColor];
        self.cropView.alpha = 0.5;
        [self.view insertSubview:self.cropView belowSubview:self.topBar];
        
        
        //draw each of the crop corner pins on top of the cropView in each corner
        self.cropView.topLeftPin = [[UIButton alloc] init];
        [self.cropView.topLeftPin setImage:[UIImage imageNamed:@"ABPicturePasteboardMask@2x.png"] forState:UIControlStateNormal];
        self.cropView.topLeftPin.frame = CGRectMake(0,0, pinDimension, pinDimension);
        
        [self.cropView addSubview:self.cropView.topLeftPin];
        
        self.cropView.bottomLeftPin= [[UIButton alloc] init];
        [self.cropView.bottomLeftPin setImage:[UIImage imageNamed:@"ABPicturePasteboardMask@2x"] forState:UIControlStateNormal];
        self.cropView.bottomLeftPin.frame = CGRectMake(0,self.cropView.frame.size.height - pinDimension,pinDimension,pinDimension);
        
        [self.cropView addSubview:self.cropView.bottomLeftPin];
        
        self.cropView.topRightPin= [[UIButton alloc] init];
        [self.cropView.topRightPin setImage:[UIImage imageNamed:@"ABPicturePasteboardMask@2x"] forState:UIControlStateNormal];
        self.cropView.topRightPin.frame = CGRectMake(self.cropView.frame.size.width - pinDimension, 0, pinDimension, pinDimension);
        
        [self.cropView addSubview:self.cropView.topRightPin];
        
        self.cropView.bottomRightPin= [[UIButton alloc] init];
        [self.cropView.bottomRightPin setImage:[UIImage imageNamed:@"ABPicturePasteboardMask@2x"] forState:UIControlStateNormal];
        self.cropView.bottomRightPin.frame = CGRectMake(self.cropView.frame.size.width - pinDimension, self.cropView.frame.size.height - pinDimension,pinDimension, pinDimension);
        
        [self.cropView addSubview:self.cropView.bottomRightPin];
        
        
        // have pins respond to touch
        [self.cropView.topLeftPin addTarget:self
                                     action:@selector(pinTouched: withEvent:)        
                           forControlEvents:UIControlEventTouchDragInside];
        [self.cropView.topRightPin addTarget:self
                                      action:@selector(pinTouched: withEvent:)     
                            forControlEvents:UIControlEventTouchDragInside];
        
        [self.cropView.bottomLeftPin addTarget:self
                                        action:@selector(pinTouched: withEvent:)        
                              forControlEvents:UIControlEventTouchDragInside];
        
        [self.cropView.bottomRightPin addTarget:self
                                         action:@selector(pinTouched: withEvent:)
                               forControlEvents:UIControlEventTouchDragInside];
        
        
        
        // create the crop confirm button with styling
        self.confirmCropButton = [[UIButton alloc] init];
        [self.confirmCropButton addTarget:self 
                                   action:@selector(commitCropPhoto)
                         forControlEvents:UIControlEventTouchUpInside];
        self.confirmCropButton.frame = CGRectMake(-5.0, -5.0, 246.0, 69.0);
        [self.confirmCropButton setBackgroundImage:[UIImage imageNamed:@"commitCrop.png"]forState:UIControlStateNormal];
        self.confirmCropButton.alpha = 0.7;
        [[self.confirmCropButton layer] setCornerRadius:4.0f];
        [[self.confirmCropButton layer] setMasksToBounds:YES];
        [[self.confirmCropButton layer] setBorderWidth:2.0f];
        [[self.confirmCropButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        
        [self.view addSubview:self.confirmCropButton]; 
        
        
        // add the green icon on top of the confirmCropButton
        UIImageView* confirmCropTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"confirmCropTop"]];
        confirmCropTop.frame = CGRectMake(32, 10, 187, 50);
        confirmCropTop.alpha = 0.9;
        [self.confirmCropButton addSubview:confirmCropTop];
        
        
        // create the end crop button with syling
        self.endCropButton = [[UIButton alloc] init];
        [self.endCropButton addTarget:self 
                               action:@selector(endCropPhoto)
                     forControlEvents:UIControlEventTouchUpInside];
        self.endCropButton.frame = CGRectMake(245.0, -5.0, 81.0, 69.0);
        [self.endCropButton setBackgroundImage:[UIImage imageNamed:@"endCrop.png"]forState:UIControlStateNormal];
        self.endCropButton.alpha = 0.7;
        [[self.endCropButton layer] setCornerRadius:4.0f];
        [[self.endCropButton layer] setMasksToBounds:YES];
        [[self.endCropButton layer] setBorderWidth:2.0f];
        [[self.endCropButton layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        
        [self.view addSubview:self.endCropButton];   
    }
}


- (void)pinTouched:(UIButton *)pin withEvent:(UIEvent *)event
{
    // gets the data from a screen drap on a pin
    UITouch *touch = [[event touchesForView:pin] anyObject];
    
    // gets the location last touched by the drag
    CGPoint location = [touch locationInView:self.view];
    
    // correcting values to place new "pin" centered at location, rather than near it
    CGPoint negativeCenteredLocation = CGPointMake(location.x - pinDimension/2, location.y - pinDimension/2);
    CGPoint positiveCenteredLocation = CGPointMake(location.x + pinDimension/2, location.y + pinDimension/2);
    
    // values for each pin to replace them in the images' corners
    if(pin == self.cropView.topLeftPin)
    {
        self.cropView.frame = CGRectMake(negativeCenteredLocation.x,
                                         negativeCenteredLocation.y,
                                         self.cropView.frame.size.width  + (self.cropView.frame.origin.x - negativeCenteredLocation.x),
                                         self.cropView.frame.size.height + (self.cropView.frame.origin.y - negativeCenteredLocation.y));
        [self.cropView redraw];
    }
    
    else if(pin == self.cropView.bottomLeftPin)
    {
        //if(location.x <= self.cropView.bottomRightPin.center.x + pinDimension/2  && location.y >= self.cropView.topLeftPin.center.y -pinDimension)
        //{
        self.cropView.frame = CGRectMake(negativeCenteredLocation.x,
                                         self.cropView.frame.origin.y,
                                         self.cropView.frame.size.width  + (self.cropView.frame.origin.x - negativeCenteredLocation.x),
                                         positiveCenteredLocation.y - self.cropView.frame.origin.y);
        [self.cropView redraw];
        //}
    }
    
    else if(pin == self.cropView.topRightPin)
    {
        self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                         negativeCenteredLocation.y,
                                         positiveCenteredLocation.x - self.cropView.frame.origin.x,
                                         self.cropView.frame.size.height + (self.cropView.frame.origin.y - negativeCenteredLocation.y));
        [self.cropView redraw];
    }
    
    else if(pin == self.cropView.bottomRightPin)
    {
        self.cropView.frame = CGRectMake(self.cropView.frame.origin.x,
                                         self.cropView.frame.origin.y,
                                         positiveCenteredLocation.x - self.cropView.frame.origin.x,
                                         positiveCenteredLocation.y - self.cropView.frame.origin.y);
        [self.cropView redraw];
    }
}
- (void)commitCropPhoto
{
    
    
    // constants to get the scaling difference of the uiimageview by which to multiply a frame when cropping
    float cropHorizontalConstant = self.photoView.image.size.width / self.photoView.frame.size.width;
    float cropVerticalConstant = self.photoView.image.size.height / self.photoView.frame.size.height;

    // commits the crop using this sclaing
    CGRect cropRect = CGRectMake((self.cropView.frame.origin.x - self.photoView.frame.origin.x) * cropHorizontalConstant,
                                 (self.cropView.frame.origin.y - self.photoView.frame.origin.y) * cropVerticalConstant,
                                 self.cropView.frame.size.width * cropHorizontalConstant, 
                                 self.cropView.frame.size.height * cropHorizontalConstant );
    
    self.photoView.image = [self.photoView.image crop: cropRect scalable:NO];
    [self endCropPhoto];
}

- (void)endCropPhoto
{
  
    // removes the modal cropping interface elements and allows cropping to become active once more
    [self.cropView removeFromSuperview];
    [self.endCropButton removeFromSuperview];
    [self.confirmCropButton removeFromSuperview]; 
    
    self.cropActive = NO;
}
- (IBAction)changeAlpha:(id)sender
{
    //self.photoView.image = [self.effectsFilter defaultEffects:self.effect forImage:self.photo withAlpha:.50];
    self.photoView.image = [self.effectsFilter updateEffects:self.effect forImage:self.photo withAlpha:(self.slider.value / 100)];
}





@end
