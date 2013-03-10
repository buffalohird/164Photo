//
//  SecondViewController.m
//  Project3
//
//  Created by Buffalo Hird on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"

#define radians(degrees) (degrees * M_PI/180)

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize photoView = _photoView;
@synthesize chooseButton = _chooseButton;
@synthesize takeButton = _takeButton;
@synthesize selectButton = _selectButton;
@synthesize pin = _pin;
@synthesize pinViewLeft = _pinViewLeft;
@synthesize pinViewRight = _pinViewRight;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Upload", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"]; // we also made this one!
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // pretty snazzy!
    UIImage *wood = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wood" ofType:@"png"]];
    UIImage *unchosen = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"unchosen2" ofType:@"png"]];
    
    // set out background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:wood];
    
    // the user has to pick an image before they can move further ...
    self.selectButton.enabled = NO;
    
    // this is where the user's chose photo will appear
    self.photoView = [[UIImageView alloc] init];
    self.photoView.frame = CGRectMake(20.0, 10.0, 280.0, 314.0);
    self.photoView.image = unchosen;
    self.photoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.photoView];
    
    // pretty shadows
    self.chooseButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.chooseButton.layer.shadowOffset = CGSizeMake(15.0, -15.0);
    self.chooseButton.layer.shadowOpacity = 1.0;
    self.chooseButton.layer.shadowRadius = 30.0;
    self.chooseButton.clipsToBounds = NO;
    
    self.takeButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.takeButton.layer.shadowOffset = CGSizeMake(15.0, -15.0);
    self.takeButton.layer.shadowOpacity = 1.0;
    self.takeButton.layer.shadowRadius = 30.0;
    self.takeButton.clipsToBounds = NO;
    
    self.selectButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.selectButton.layer.shadowOffset = CGSizeMake(15.0, -15.0);
    self.selectButton.layer.shadowOpacity = 1.0;
    self.selectButton.layer.shadowRadius = 30.0;
    self.selectButton.clipsToBounds = NO;
    
    
    // just for effect
    self.pinViewLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_sm.png"]];
    self.pinViewRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin_sm.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// set up called when an image has been selected
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // set up how we'll get the image
	[picker dismissModalViewControllerAnimated:YES];
	self.photoView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // to resize the image
    float aspectRatio = self.photoView.image.size.height / self.photoView.image.size.width;
    self.photoView.contentMode = UIViewContentModeScaleToFill;
    
    // handle resizing
    if(aspectRatio > 1)
        self.photoView.frame = CGRectMake(20.0, 10.0, 275.0 / aspectRatio, 275.0);
    else 
        self.photoView.frame = CGRectMake(20.0, 10.0, 245.0, 245.0 * aspectRatio);
    
    // gathered experimentally
    self.photoView.center = CGPointMake(160.0, 167.0);
    
    // aesthetics
    self.photoView.layer.cornerRadius = 8.0f;
    self.photoView.layer.masksToBounds = YES;
    self.photoView.layer.borderWidth = 2.0f;
    self.photoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.photoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.photoView.layer.shadowOffset = CGSizeMake(30.0, -40.0);
    self.photoView.layer.shadowOpacity = 1.0;
    self.photoView.layer.shadowRadius = 50.0;
    self.photoView.clipsToBounds = NO;
    
    
    // also gathered experimentally.  Ideally we'd finetune these more, but it took a surprisingly long time to create these values to keep the pins inside the bounds of any photo
    self.pinViewLeft.frame = CGRectMake(self.photoView.frame.origin.x + self.photoView.frame.size.width/(20 * aspectRatio) + 10,
                               self.photoView.frame.origin.y - self.photoView.frame.size.height/(20 * 1/aspectRatio) - 10,
                               46.0,
                               85.0);
    
    // set up the left pin
    self.pinViewLeft.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:self.pinViewLeft aboveSubview:self.photoView];

    // experimentally again
    self.pinViewRight.frame = CGRectMake(self.photoView.frame.origin.x + self.photoView.frame.size.width - self.photoView.frame.size.width/(20 * aspectRatio) - 20,
                               self.photoView.frame.origin.y + self.photoView.frame.size.height/(30 * 1/aspectRatio),
                               46.0,
                               85.0);
    
    // now set up the right pin
    self.pinViewRight.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:self.pinViewRight aboveSubview:self.photoView];

    // 7 degrees of tilt
    self.photoView.transform = CGAffineTransformMakeRotation(radians(7));
    
    // the user has not selected their image, so they may proceed
    if(self.selectButton.enabled == NO)
        self.selectButton.enabled = YES;
    
    // change the tabbar's title to edit. photo is already uploaded
    self.title = NSLocalizedString(@"Edit", @"Second");
}

- (IBAction)getPhoto:(id)sender
{
    // set up the picker
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
    // if a photo is to be chosen, display the user's photos
	if((UIButton *) sender == self.chooseButton) 
    {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    
    // if a photo is to be taken, display the user's camera
    else if((UIButton *) sender == self.takeButton)
    {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
	[self presentModalViewController:picker animated:YES];
}

- (IBAction)sendPhoto:(id)sender
{
    // send the selected photo to the effectsViewController, so that an effect can be chosen
    EffectsViewController *effectsViewController = [[EffectsViewController alloc] init];
    effectsViewController.photo = self.photoView.image; 
    [self presentModalViewController:effectsViewController animated:YES];
    
    
    // iOS5 deprecated easy access to this from subViews.  To be most simple, we switch views now so when the subviews are dismissed the user is brought to the updated gallery
    [self.tabBarController setSelectedIndex:0];
}
@end
