//
//  ThirdViewController.m
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdViewController.h"

#define XCENTER 160.0
#define BG 0
#define EMPTY 1

@interface ThirdViewController ()

@end

@implementation ThirdViewController

// gotta get those getters and setters!
@synthesize index = _index;
@synthesize galleryView = _galleryView;
@synthesize images = _images;
@synthesize deleteButton = _deleteButton;
@synthesize stockImages = _stockImages;
@synthesize firstLoad = _firstLoad;
@synthesize imageLocation = _imageLocation;
@synthesize emptyGallery = _emptyGallery;
@synthesize totalImages = _totalImages;
@synthesize robButton = _robButton;
@synthesize easterView = _easterView;

// pretty stock setup function
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = NSLocalizedString(@"Gallery", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"]; // we made this!
    }
    
    return self;
}

- (void)viewDidLoad
{
    // create our editing environment
    [super viewDidLoad];
    
    UIImage *bg, *empty;
    
    // get our ivars in order
    self.emptyGallery = NO;
    self.firstLoad = YES;
    self.imageLocation = 0;
    self.images = [[NSMutableArray alloc] init];
    self.galleryView = [[UIImageView alloc] init];

    // set up our stock images
    bg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gall_bg" ofType:@"jpg"]];
    empty = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"empty" ofType:@"png"]];

    // these are stored in an ivar so that we don't have to alloc/init them repeatedly (i.e. at 60 times/sec)
    self.stockImages = [[NSArray alloc] initWithObjects:bg, empty, nil];
    
    // pretty sweet looking
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[self.stockImages objectAtIndex:BG]];
    
    // this is where the gallery's images go
    self.galleryView.frame = CGRectMake(10.0, 80.0, 300.0, 212.0);
    self.galleryView.contentMode = UIViewContentModeScaleAspectFit;
    self.galleryView.userInteractionEnabled = YES;
    self.galleryView.multipleTouchEnabled = YES;
    
    // right swipe
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.galleryView addGestureRecognizer:swipeGesture];
    
    // left swipe
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.galleryView addGestureRecognizer:swipeGesture];
    
    // add the gallery to the view
    [self.view addSubview:self.galleryView];
    
    // add our delete button. this is the programatic equivilent to Interface Building it
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.frame = CGRectMake(174.0, 175.0, 222.0, 223.0);
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_sm.png"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_sm_pressed.png"] forState:UIControlStateSelected];
    [self.deleteButton setImage:[UIImage imageNamed:@"delete_sm_disables"] forState:UIControlStateDisabled];
    [self.view addSubview:self.deleteButton];
    
    self.deleteButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.deleteButton.layer.shadowOffset = CGSizeMake(-5, -5);
    self.deleteButton.layer.shadowOpacity = 1.0;
    self.deleteButton.layer.shadowRadius = 30.0;
    self.deleteButton.clipsToBounds = NO;
    
    // add our delete button. this is the programatic equivilent to Interface Building it
    self.robButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.robButton addTarget:self action:@selector(easter) forControlEvents:UIControlEventTouchUpInside];
    self.robButton.frame = CGRectMake(0, 0, 20.0, 20.0);
    self.robButton.alpha = 0.1;
    [self.view addSubview:self.robButton];
    
    // [cribs] and this is where the magin happens ...
    [self loadImages];  
}

- (BOOL) loadImages
{
    // easy way to see the number of real images that we're loading
    self.totalImages = 0;    
    int i = 0;
    
    // used to get our stored photos
    Storage *storage = [[Storage alloc] init];
    
    // load all the images until we hit a null (nil) terminator
    while(true)
    {        
        // load up the image in question
        UIImage *image = [storage load:i];
        
        // we've reached the end of our stored images
        if (image == nil)
            break;
        
        // when the user deletes an image, we overwrite it with a null photo as a placeholder in memory
        // after many hours of screwing with different designs, this is an intuitive, lightweight way to go about it.
        else if (image.size.width == 1.0)
        {
            [self.images addObject:@"empty"];
            i++;
            continue;
        }
        
        // ad our actual valid photo to our ivar array
        [self.images addObject:image];
        i++;
        self.totalImages++;
    }
    
    // set the gallery's photo to be the last one the user stored
    self.galleryView.image = [self findLastPhoto];
    
    // this is implicit, but this is set just for securit's sake
    if(!self.emptyGallery)
    {
        self.deleteButton.enabled = YES;
        return YES;
    }
    else 
        return NO;
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    // if this is not the first time the view is loading. no need to do this twice
    if(!self.firstLoad)
    {
        // see block comment below for reason why we reset/reload the images array
        [self.images removeAllObjects];
        [self loadImages];
        
        if(self.easterView)
            [self.easterView removeFromSuperview];
        
        // this is similary to what happens in ViewDidLoad, except we need to refresh it every time the user visits the view as the gallery's contents have changed
        if(!self.emptyGallery)
        {
            self.deleteButton.enabled = YES;
            self.galleryView.image = [self findLastPhoto];
        }
    }
    
    // now the view has been loaded, so any further loadings form here on out won't be the firstLoad
    self.firstLoad = NO;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)sender
{
    // this is just for looks ...
    CATransition *transition = [CATransition animation];
    transition.duration = .5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.galleryView.layer addAnimation:transition forKey:nil];
    
    // handle the actual swipe
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];
    switch (direction)
    {
        // we dont care about verticle swiping
        case UISwipeGestureRecognizerDirectionUp:
        case UISwipeGestureRecognizerDirectionDown:
            break;
            
        // left
        case UISwipeGestureRecognizerDirectionLeft:
            if(self.totalImages ==1)
                break;
            self.index = [self findLeft];
            break;
            
        //right
        case UISwipeGestureRecognizerDirectionRight:
            if(self.totalImages ==1)
                break;
            self.index = [self findRight];
            break;
            
        // always clutch
        default:
            break;
    }
    
    // update the images
    self.galleryView.image = [self.images objectAtIndex:self.index];
        
}

- (IBAction)deletePhoto:(id)sender
{
    Storage *storage = [[Storage alloc] init];
    
    // this just makes it look cool, not related to actual functioality
    CATransition *transition = [CATransition animation];
    transition.duration = .5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    [self.galleryView.layer addAnimation:transition forKey:nil];
    
    // overwrite the image with a null photo as a placeholder
    [storage delete:self.index];
    
    // reset our images array
    [self.images removeAllObjects];
    
    // reload with new images
    [self loadImages];
    
    /*
     *
     * The reason that our images array gets reset and reloaded is this: in the (near) future, when we release the app to the app store,
     * we hopefully want the user to further manipulate their stored images without having to worry about them being modified in the gallery.
     * By releading and redisplaying it like this, we hope to increase performance in these types of situations, where the user isn't just
     * modifying one photo. We're doing it for scalability!
     *
     */
    
    // now display the next image (direction is arbitrary)
    if(!self.emptyGallery)
        self.galleryView.image = [self.images objectAtIndex:[self findLeft]];
    
}
- (UIImage *)findLastPhoto
{
    // start at the end of our stored photos
    int i = [self.images count] - 1;
    
    // this is a while loop and not a for loop so that down the road (upon completion of the project), when we want to
    // launch our app on the app store, we mess around with gallery functionality that isn't included in this release
    // the other find methods use for loops. they are all functionally equivilent
    while (true)
    {
        // looks like the user's gallery is empty
        if(i == -1)
            break;
        
        // these are photos the user deleted
        if([self.images objectAtIndex:i] == @"empty")
        {
            i--;
            continue;
        }
        
        // here's the last (valid) photo
        self.index = i;
        self.deleteButton.enabled = YES;
        return [self.images objectAtIndex:i];
    }
    
    // no valid photos got returned, user's gallery must be empty. plan accordingly
    self.emptyGallery = YES;
    self.deleteButton.enabled = NO;
    return [self.stockImages objectAtIndex:EMPTY];
}

// swipe to the left looks for images to the right!
- (int)findLeft
{
    // iterate through our images
    for(int i = 1; i <= [self.images count]; i++)
    {
        // if the nest image to the right has been deleted
        if([self.images objectAtIndex:((self.index + i) % [self.images count])] == @"empty")
        {
            continue;
        }
        // we've got a good one
        else
        {    
            return (self.index + i) % [self.images count];
        }
    }
    
    // when the last image has been deleted, the user now has an emtpy gallery. set it up ...
    self.emptyGallery = YES;
    self.deleteButton.enabled = NO;
    return 0;
}

// conversely, swiping to the right looks for images to the left
- (int)findRight
{
    for(int i = 1; i <= [self.images count]; i++)
    {
        // the image to the left has been deleted
        if([self.images objectAtIndex:((self.index + [self.images count] - i) % [self.images count])] == @"empty")
        {
            continue;
        }
        // we've found a good one
        else
        {    
            return (self.index + [self.images count] - i) % [self.images count];
        }
    }
    
    return 0;
}

-(void)easter
{
    self.easterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rob.png"]];
    self.easterView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:self.easterView];
}

@end
