//
//  EffectsFilter.m
//  Project3
//
//  Created by Buffalo Hird on 4/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EffectsFilter.h"

@implementation EffectsFilter

@synthesize faceDetector = _faceDetector;
@synthesize fxArray = _fxArray;

// for rotation
#define radians(degrees) (degrees * M_PI/180)

// for using the actual overlay images
#define CREST 0
#define BG 1
#define FADE 2
#define NOISE 3
#define GRAIN 4
#define AGE1 5
#define AGE2 6
#define CRESTBG 7
#define BLOCKS 8
#define STREAK 9
#define SUNCIRCLES 10
#define SUNBG 11
#define FACE 12


- (UIImage *)defaultEffects:(int)effect forImage:(UIImage *)image withAlpha:(float)alpha
{   
    UIImage *crest, *bg, *fade, *noise, *grain, *age1, *age2, *crest_bg, *blocks, *streak, *sun_circles, *sun_bg;
    
    // create all of our overlays and store them in an ivar so that we don't need to alloc/init them more than once
    crest = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crest_overlay" ofType:@"png"]];
    bg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"white_bg" ofType:@"jpg"]];
    fade = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fade" ofType:@"jpg"]];
    noise = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noise" ofType:@"png"]];
    grain = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"grain2" ofType:@"jpg"]];
    age1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"age1" ofType:@"jpeg"]];
    age2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"age2" ofType:@"jpeg"]];
    crest_bg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iPhone_harvard_crest" ofType:@"png"]];
    blocks = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iPhone_overlay_blocks" ofType:@"png"]];
    streak = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"streak" ofType:@"png"]];
    sun_circles = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sun_circles" ofType:@"png"]];
    sun_bg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sun_bg" ofType:@"png"]];
    
    // add the overlays to our array
    self.fxArray = [[NSArray alloc] initWithObjects:crest, bg, fade, noise, grain, age1, age2, crest_bg, blocks, streak, sun_circles, sun_bg, nil];
    
    // returned the modified images
    return [self updateEffects: effect forImage:image withAlpha:alpha];
}

- (UIImage *)updateEffects:(int)effect forImage:(UIImage *)image withAlpha:(float)alpha
{
    // decide the proper effect
    switch (effect)
    {
        case 1:
            return image;
            break;
        case 2:
            return [self grayscale:image withAlpha:alpha];
            break;
        case 3:
            return [self sepia:image withAlpha:alpha];
            break;
        case 4:
            return [self redify:image withAlpha:alpha];
            break;
        case 5:
            return [self overlay:image withOverlay:0 andBlendConstant:0 withAlpha:alpha];
            break;
        case 6:
            return [self overlay:image withOverlay:0 andBlendConstant:1 withAlpha:alpha];
            break;
        case 7:
            return [self overlay:image withOverlay:1 andBlendConstant:2 withAlpha:alpha];
            break;
        case 8:
            return [self overlay:image withOverlay:1 andBlendConstant:0 withAlpha:alpha];
            break;
        case 9:
            return [self seventies:image withAlpha:alpha];
            break;
        case 10:
            return [self aged:image withAlpha:alpha];
            break;
        case 11:
            return [self oilSpill:image withAlpha:alpha];
            break;
        case 12:
            return [self sunBath:image withAlpha:alpha];
            break;
        case 13:
            return [self faceDetection:image withAlpha:alpha];
            break;
        default:
            break;
    }
}

-(UIImage *)grayscale:(UIImage *)image withAlpha:(float)alpha
{
    // create a colorspace and bitmapContext from the image's data
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       8,
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // draw a bitmap from the original image
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    UInt8 *data = CGBitmapContextGetData(bitmapContext);
    int numComponents = 4;
    
    // get the total number of bytes
    int bytesInContext = CGBitmapContextGetHeight(bitmapContext) * CGBitmapContextGetBytesPerRow(bitmapContext);
    
    
    // initial and final RGB values
    int redIn, greenIn, blueIn, redOut, greenOut, blueOut;
	
    // for each component (R, G, or B)
    for (int i = 0; i < bytesInContext; i += numComponents)
    {
        
        // each color is one item in the array given
        redIn = data[i];
        greenIn = data[i+1];
        blueIn = data[i+2];
        
        
        // as the alpha decreases, these values will approach 1 - the original color value, so that, for example redOut == 1.0 * redIn
        float newRedAlpha = 0.701 * (1 -alpha);
        float newGreenAlpha = 0.413 * (1 - alpha);
        float newBlueAlpha = 0.886 * (1 - alpha);
        
        // as the alpha decreases, the other values reduce to + 0, so that for example redOut is only modified by redIn, not greenIn or blueIn
        float redGrayOut = ((0.299 + newRedAlpha) * redIn) + (0.587 * greenIn * alpha) + (0.114 * blueIn * alpha);
        float greenGrayOut = (0.299 * redIn * alpha) + ((0.587 + newGreenAlpha) * greenIn) + (0.114 * blueIn * alpha);
        float blueGrayOut = (0.299 * redIn * alpha) + (0.587 * greenIn * alpha) + ((0.114 + newBlueAlpha) * blueIn);
        
        
        redOut = (int)(redGrayOut);
        greenOut = (int)(greenGrayOut);
        blueOut = (int)(blueGrayOut);
        
        // if a number overflows its color (shouldn't happen here), set it to the max value
        if (redOut>255) redOut = 255;
        if (blueOut>255) blueOut = 255;
        if (greenOut>255) greenOut = 255;
        
        
        
        // rewrite data
        data[i] = (redOut);
        data[i+1] = (greenOut);
        data[i+2] = (blueOut);
    }
    
    // save bitmap to an imageRed and from here to a UIImage
    CGImageRef outImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return newImage;
}


-(UIImage *)sepia: (UIImage *)image withAlpha:(float)alpha
{
    
    // create a colorspace and bitmapContext from the image's data
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       8,
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // draw a bitmap from the original image
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    UInt8 *data = CGBitmapContextGetData(bitmapContext);
    int numComponents = 4;
    
    // get the total number of bytes
    int bytesInContext = CGBitmapContextGetHeight(bitmapContext) * CGBitmapContextGetBytesPerRow(bitmapContext);
    
    
    // initial and final RGB values
    int redIn, greenIn, blueIn, redOut, greenOut, blueOut;
	
    // for each component (R, G, or B)
    for (int i = 0; i < bytesInContext; i += numComponents)
    {
        
        // each color is one item in the array given
        redIn = data[i];
        greenIn = data[i+1];
        blueIn = data[i+2];
        
        // create all the needed values
		float newRedAlphaRed, newRedAlphaGreen, newRedAlphaBlue,
        newGreenAlphaRed, newGreenAlphaGreen, newGreenAlphaBlue,
        newBlueAlphaRed, newBlueAlphaGreen, newBlueAlphaBlue;
        
        
        // each set works so that as alpha approaches 0, the appropriate color will reach the difference of 1.0 and the default sepia value.  The other colors, meanwhile will come to be the negative of the default sepia value, so that redOut will only be modded by redIn.
        newRedAlphaRed = 0.607 * (1 - alpha);
        newRedAlphaGreen = 0.769 * -(1 - alpha);
        newRedAlphaBlue = 0.189 * -(1 - alpha);
        
        newGreenAlphaRed = 0.349 * -(1 - alpha);
        newGreenAlphaGreen = 0.314 * (1 - alpha);
        newGreenAlphaBlue = 0.168 * -(1 - alpha);
        
        newBlueAlphaRed = 0.272 * -(1 - alpha);
        newBlueAlphaGreen = 0.534 * -(1 - alpha);
        newBlueAlphaBlue = 0.869 * (1 - alpha);
        
        
        // the values based on other colors are added, so that at alpha 0.0 they could equate to, for example redOut = redIn + 0.0 + 0.0
        redOut = (int)(redIn * (.393 + newRedAlphaRed)) + (greenIn * (.769 + newRedAlphaGreen)) + (blueIn * (.189 + newRedAlphaBlue));
        greenOut = (int)(redIn * (.349 + newGreenAlphaRed)) + (greenIn * (.686 + newGreenAlphaGreen)) + (blueIn * (.168 + newGreenAlphaBlue));
        blueOut = (int)(redIn * (.272 + newBlueAlphaRed)) + (greenIn * (.534 + newBlueAlphaGreen)) + (blueIn * (.131 + newBlueAlphaBlue));		
        
        
        // overflow corner case
        if (redOut>255) redOut = 255;
        if (blueOut>255) blueOut = 255;
        if (greenOut>255) greenOut = 255;
        
        
        // rewrite to data
        data[i] = (redOut);
        data[i+1] = (greenOut);
        data[i+2] = (blueOut);
    }
    
    
    // save the bitmap to an imageRef and then to a UIImage
    CGImageRef outImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return newImage;
}

-(UIImage *)redify: (UIImage *)image withAlpha:(float)alpha
{
    
    // create a colorspace and bitmapContext from the image's data
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       8,
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // draw a bitmap from the original image
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    UInt8 *data = CGBitmapContextGetData(bitmapContext);
    int numComponents = 4;
    
    // get the total number of bytes
    int bytesInContext = CGBitmapContextGetHeight(bitmapContext) * CGBitmapContextGetBytesPerRow(bitmapContext);
    
    
    // initial and final RGB values
    int redIn, greenIn, blueIn, redOut;
	
    // for each component (R, G, or B)
    for (int i = 0; i < bytesInContext; i += numComponents)
    {
        
        // each color is one item in the array given
        redIn = data[i];
        greenIn = data[i+1];
        blueIn = data[i+2];
        
        // set so that the mod of redOut is 3 * redIn at alpha 1.0 and 1 * redIn at alpha 0.0
        float newRedAlpha = alpha * 2 + 1;
        redOut = (int)(newRedAlpha * redIn);	
        
        // overflow case for red only
        if (redOut>255) redOut = 255; 
        
        
        // rewrite to data
        data[i] = (redOut);
        data[i+1] = (greenIn);
        data[i+2] = (blueIn);
    }
    
    // write bitmap to imageRed and then to UIImage
    CGImageRef outImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return newImage;
}
-(UIImage *)oilSpill: (UIImage *)image withAlpha:(float)alpha
{
    
    // create a colorspace and bitmapContext from the image's data
    CGImageRef originalImage = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       CGImageGetWidth(originalImage),
                                                       CGImageGetHeight(originalImage),
                                                       8,
                                                       CGImageGetWidth(originalImage)*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // draw a bitmap from the original image
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGBitmapContextGetWidth(bitmapContext), CGBitmapContextGetHeight(bitmapContext)), originalImage);
    UInt8 *data = CGBitmapContextGetData(bitmapContext);
    int numComponents = 4;
    
    // get the total number of bytes
    int bytesInContext = CGBitmapContextGetHeight(bitmapContext) * CGBitmapContextGetBytesPerRow(bitmapContext);
    
    
    // initial and final RGB values
    int redIn, greenIn, blueIn, redOut, greenOut, blueOut;
	
    // for each component (R, G, or B)
    for (int i = 0; i < bytesInContext; i += numComponents)
    {
        
        // each color is one item in the array given
        redIn = data[i];
        greenIn = data[i+1];
        blueIn = data[i+2];
        
        // each color value is amplified so that there is "bleed over" past the 255 limit.  As alpha approaches 0.0, colorOut approaches colorIn * 1.0
        float newRedAlpha = alpha * 1.5 + 1.0;
        float newGreenAlpha = alpha * 2.0 + 1.0;
        float newBlueAlpha = alpha * 2.2 + 1.0;
        
        redOut = (int)(newRedAlpha * redIn);
        greenOut = (int)(newGreenAlpha * greenIn);
        blueOut = (int)(newBlueAlpha * blueIn);
        
        // rewrite to data
        data[i] = (redOut);
        data[i+1] = (greenOut);
        data[i+2] = (blueOut);
    }
    
    // write bitmap to imageRed and then to UIImage
    CGImageRef outImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return newImage;
}


-(UIImage *)overlay:(UIImage *)image withOverlay:(int)overlaySetting andBlendConstant:(int)blendConstant withAlpha:(float)alpha
{
    // our image to be overlayed and the rectangle wrapper to hold the image
    UIImage *overlay;
    CGRect imageRect, overlayRect;
    
    // which overlay to use
    switch (overlaySetting)
    {
        // colored blocks
        case 0:
            overlay = [self.fxArray objectAtIndex:BLOCKS];
            imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            break;
        
        // harvard crest
        case 1:
            overlay = [self.fxArray objectAtIndex:CRESTBG];
            imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            overlayRect = CGRectMake(0.0, 0.0, 320.0, 480.0);
            break;
    }
    
    // create a new context with size of our image in question
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext(size);
    
    // draw the user's chosen into the rectangle
    [image drawInRect:imageRect];
    
    // decide how to blend
    switch (blendConstant)
    {
        case 0:
            [overlay drawInRect:imageRect blendMode:kCGBlendModeExclusion alpha:alpha];
            break;
        case 1:
            [overlay drawInRect:imageRect blendMode:kCGBlendModeOverlay alpha:alpha];
            break;
        case 2:
            [overlay drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:alpha];
            break;            
        default:
            break;
    }
    
    // return the image to be displayed as a thumbnail
    return UIGraphicsGetImageFromCurrentImageContext();
    
}

-(UIImage *)seventies:(UIImage *)image withAlpha:(float)alpha
{
    // establish the right image size, image rectangle
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    // create new context, then add the overlays. alpha proportionality constants experimentally derived
    UIGraphicsBeginImageContext(size);
    [[self.fxArray objectAtIndex:BG] drawInRect:imageRect];
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:(1-(alpha * .444))];
    [[self.fxArray objectAtIndex:FADE] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .595)];
    [[self.fxArray objectAtIndex:NOISE] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .180)];
    
    // return the image in our current context
    return UIGraphicsGetImageFromCurrentImageContext();
}

-(UIImage *)aged:(UIImage *)image withAlpha:(float)alpha
{
    // establish the right image size, image rectangle
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    // create new context, then add the overlays. alpha proportionality constants experimentally derived
    UIGraphicsBeginImageContext(size);
    [[self.fxArray objectAtIndex:BG] drawInRect:imageRect];
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:(1-(alpha * .465))];
    [[self.fxArray objectAtIndex:AGE2] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .385)];
    [[self.fxArray objectAtIndex:AGE1] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .221)];
    [[self.fxArray objectAtIndex:GRAIN] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .3)];
    
    // return the image in our current context
    return UIGraphicsGetImageFromCurrentImageContext();
}

-(UIImage *)sunBath:(UIImage *)image withAlpha:(float)alpha
{
    // establish the right image size, image rectangle
    CGSize size = CGSizeMake(image.size.width, image.size.height);
    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    // create new context, then add the overlays. alpha proportionality constants experimentally derived
    UIGraphicsBeginImageContext(size);
    [[self.fxArray objectAtIndex:BG] drawInRect:imageRect];
    [image drawInRect:imageRect blendMode:kCGBlendModeNormal alpha:(1-(alpha * .4))];
    [[self.fxArray objectAtIndex:STREAK] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .265)];
    [[self.fxArray objectAtIndex:SUNBG] drawInRect:imageRect blendMode:kCGBlendModeDarken alpha:(alpha * .301)];
    [[self.fxArray objectAtIndex:SUNCIRCLES] drawInRect:imageRect blendMode:kCGBlendModeMultiply alpha:(alpha * .034)];
    
    // return the image in our current context
    return UIGraphicsGetImageFromCurrentImageContext();
}

-(UIImage *)faceDetection:(UIImage *)image withAlpha:(float)alpha
{
    self.faceDetector = [[FaceDetector alloc] init];
    return [self.faceDetector setUp:0 forImage:image withAlpha: alpha];
    
}
@end