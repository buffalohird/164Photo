//
//  Storage.h
//  Project3
//
//  Created by Buffalo Hird on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

@property (strong, nonatomic) NSString * documentsDirectory;

-(NSString *)getDirectory;
-(BOOL)save:(UIImage *)photo;
-(UIImage *)load:(int)index;
-(BOOL)delete:(int)index;

@end
