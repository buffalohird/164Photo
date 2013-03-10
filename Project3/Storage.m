//
//  Storage.m
//  Project3
//
//  Created by Buffalo Hird on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Storage.h"

@implementation Storage

@synthesize documentsDirectory = _documentsDirectory;

- (NSString *)getDirectory
{
    // Get the application documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}

- (BOOL)save:(UIImage *)photo
{
    //if the directory is not yet stored, retrieve it
    if(self.documentsDirectory == nil)
        self.documentsDirectory = [self getDirectory];
    
    int saveIndex = 0;
    NSString *fileName;
    while(true)
    {        
        // Create a filename string with the documents path and our filename
        fileName = [self.documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d.png", saveIndex]];
        
        
        // exit the loop once the end of photos is reached
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileName])
            break;
        
        saveIndex++;
    }
    
    // Save image to disk
    [UIImagePNGRepresentation(photo) writeToFile:fileName atomically:YES];
    // save image to generic photo library
    UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        return YES;
    else 
        return NO;
}

- (UIImage *)load:(int)index
{
    //if the directory is not yet stored, retrieve it
    if(self.documentsDirectory == nil)
        self.documentsDirectory = [self getDirectory];
    // Create a filename string with the documents path and our filename
    NSString *fileName = [self.documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d.png", index]];
    
    //return no image if the file can't be found
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        return nil;
    
    UIImage *newImage = [[UIImage alloc] initWithContentsOfFile:fileName];
    return newImage;
}

- (BOOL)delete:(int)index
{
    UIImage *nullPhoto = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"null_photo" ofType:@"jpg"]];
    
    //if the directory is not yet stored, retrieve it
    if(self.documentsDirectory == nil)
        self.documentsDirectory = [self getDirectory];
    
    NSString *fileName = [self.documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d.png", index]];
    
    // removes the photo and adds the tiny (4KB) placeholder to disk
    [[NSFileManager defaultManager] removeItemAtPath:fileName error:NULL];
    [UIImagePNGRepresentation(nullPhoto) writeToFile:fileName atomically:YES];
    return YES;
    
    
}
@end
