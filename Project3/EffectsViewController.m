//
//  EffectsViewController.m
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectsViewController.h"
#import <stdlib.h>

// for slightly tilting each effectstile (lightroom style)
#define radians(degrees) (degrees * M_PI/180)

// constant for number of scrollable pages
#define PAGESNUMBER 4

// constants for effects
#define STANDARD 1
#define BLACKANDWHITE 2
#define SEPIA 3
#define REDIFY 4
#define BLOCKS1 5
#define BLOCKS2 6
#define CREST1 7
#define CREST2 8
#define SEVENTIES 9
#define AGED 10
#define OILSPILL 11
#define SUNBATH 12
#define FACE 13

// constants for tile x position (tiles are moved based on their center point)
#define TILECENTERX1 82.5
#define TILECENTERX2 237.5
#define TILECENTERX3 402.5
#define TILECENTERX4 557.5
#define TILECENTERX5 722.5
#define TILECENTERX6 877.5
#define TILECENTERX7 1044.5
#define TILECENTERX8 1199.5

// constants for tile y position
#define TILECENTERY1 83.5
#define TILECENTERY2 236.5

// thumbnail constants
#define THUMBNAILSIZE 320.0

@interface EffectsViewController ()

@end

@implementation EffectsViewController

@synthesize photo = _photo;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageControlBeingUsed = _pageControlBeingUsed;
@synthesize navBar = _navBar;
@synthesize previewPhoto = _previewPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup the background
    UIImage *bg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"effects_view_bg2" ofType:@"png"]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:bg];
    
    // each new thumbnail
    [self createThumbnail];
    self.pageControlBeingUsed = NO;
    
    // set up our fancy swipeable setup
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0.0, 400.0, 320.0, 50.0);
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = YES;
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    
    // the actual navigable view itself
    CGRect frame = CGRectMake(0,44,320,386);
    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;  
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];  
    
    // iterate through the pages, set them up
    for (int i = 0; i < PAGESNUMBER; i++)
    {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        // add as subviews
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [self.scrollView insertSubview:subview belowSubview:self.pageControl];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * PAGESNUMBER, self.scrollView.frame.size.height);
    
    // load the thumbnails of different effects applicable to the photo
    // first page
    [self createEffectTile:STANDARD withXCenter:TILECENTERX1 andYCenter:TILECENTERY1];
    [self createEffectTile:BLACKANDWHITE withXCenter:TILECENTERX2 andYCenter:TILECENTERY1];
    [self createEffectTile:SEPIA withXCenter:TILECENTERX1 andYCenter:TILECENTERY2];
    [self createEffectTile:REDIFY withXCenter:TILECENTERX2 andYCenter:TILECENTERY2];
    
    // second page
    [self createEffectTile:BLOCKS1 withXCenter:TILECENTERX3 andYCenter:TILECENTERY1];
    [self createEffectTile:BLOCKS2 withXCenter:TILECENTERX4 andYCenter:TILECENTERY1];
    [self createEffectTile:CREST1 withXCenter:TILECENTERX3 andYCenter:TILECENTERY2];
    [self createEffectTile:CREST2 withXCenter:TILECENTERX4 andYCenter:TILECENTERY2];
    
    // third page
    [self createEffectTile:SEVENTIES withXCenter:TILECENTERX5 andYCenter:TILECENTERY1];
    [self createEffectTile:AGED withXCenter:TILECENTERX6 andYCenter:TILECENTERY1];
    [self createEffectTile:OILSPILL withXCenter:TILECENTERX5 andYCenter:TILECENTERY2];
    [self createEffectTile:SUNBATH withXCenter:TILECENTERX6 andYCenter:TILECENTERY2];
    
    // fourth page
    [self createEffectTile:FACE withXCenter: TILECENTERX7 andYCenter:TILECENTERY1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated: YES];
}

// creates the effectTile
- (void)createEffectTile:(int)effect withXCenter: (float)xCenter andYCenter: (float)yCenter
{
    // set up our effects tiles
    EffectsTile *photoView = [EffectsTile buttonWithType: UIButtonTypeCustom];
    [photoView setImage:self.previewPhoto forState:UIControlStateNormal];
    [photoView setEffect: effect];
    [photoView addTarget:self
                  action:@selector(tileTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    
    // initialize effects quickview with the proper effect type
    [photoView setUp: effect];
    
    // move effects view to proper location
    photoView.center = CGPointMake(xCenter, yCenter);
    
    // these are if we're going for a lightbox effect. we may use it for the app store but it's
    // worth keeping around. looks pretty cool
    //int random = ((arc4random() % 6) - 3);
    //photoView.transform = CGAffineTransformMakeRotation(radians(random));
    
    // add the photoView
    [self.scrollView addSubview:photoView];
    
    photoView.layer.shadowColor = [UIColor blackColor].CGColor;
    photoView.layer.shadowOffset = CGSizeMake(0.0, 30.0);
    photoView.layer.shadowOpacity = 1.0;
    photoView .layer.shadowRadius = 30.0;
    photoView.clipsToBounds = NO;
}

// tile responds to selection
- (void)tileTouched:(EffectsTile *)tile
{
    // send the selected photo to the effectsViewController, so that an effect can be chosen
    EditViewController *editViewController = [[EditViewController alloc] init];
    editViewController.photo = self.photo;
    editViewController.effect = tile.effect;
    editViewController.effectName = tile.effectName;
    editViewController.modalTransitionStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:editViewController animated:YES];
}

- (void)changePage
{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed = YES;
    [self changeNavTitle:self.pageControl.currentPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!self.pageControlBeingUsed)
    {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
        [self changeNavTitle:page];
	}
}

- (void)changeNavTitle:(int)currentPage
{
    switch (currentPage)
    {
        // first page
        case 0:
            self.navBar.topItem.title = [NSString stringWithFormat:@"Coloring"];
            break;
            
        // second page
        case 1:
            self.navBar.topItem.title = [NSString stringWithFormat:@"Overlays"];
            break;
            
        // third page
        case 2:
            self.navBar.topItem.title = [NSString stringWithFormat:@"Hipster"];
            break;
            
        // can't live without it
        default:
            self.navBar.topItem.title = [NSString stringWithFormat:@"Photo Effects"];
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControlBeingUsed = NO;
}

- (void)createThumbnail
{
    // for resizing
    float aspectRatio = self.photo.size.height / self.photo.size.width;
    
    // create the previews
    self.previewPhoto = [[UIImage alloc] init];
    
    // resize appropriately
    
    // if too tall, set a standard width and let the height be proportional
    if(self.photo.size.height > self.photo.size.width)
    {
        self.previewPhoto = [self.photo resizedImage:CGSizeMake(THUMBNAILSIZE, THUMBNAILSIZE * aspectRatio)
                                interpolationQuality:kCGInterpolationHigh];
    }
    
    // if too wide, set a standard height and let the width be proportional
    else if(self.photo.size.width > self.photo.size.height)
    {
        self.previewPhoto = [self.photo resizedImage:CGSizeMake(THUMBNAILSIZE * (1/aspectRatio), THUMBNAILSIZE)
                                interpolationQuality:kCGInterpolationHigh];
        
    }
    // if square, perfect
    else
    {
        self.previewPhoto = [self.photo resizedImage:CGSizeMake(THUMBNAILSIZE, THUMBNAILSIZE)
                                interpolationQuality:kCGInterpolationHigh];
    }
    
    // center and crop (aesthetics)
    
    // the shorter side previously will become one coordinate of the thumbnail square.  The other longer coordinate will be cropped to match it in length
    CGRect cropRect = CGRectMake(self.previewPhoto.size.width / 2 - THUMBNAILSIZE/2, self.previewPhoto.size.height / 2 - THUMBNAILSIZE/2, THUMBNAILSIZE, THUMBNAILSIZE);
    self.previewPhoto = [self.previewPhoto  crop:cropRect scalable:NO];
}
@end
