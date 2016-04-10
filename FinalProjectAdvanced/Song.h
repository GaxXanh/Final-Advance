//
//  Song.h
//  AdvancedFinal
//
//  Created by Pham Anh on 4/8/16.
//  Copyright © 2016 com.gaxxanh.iosFinalProject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

- (id) initWithFilePath:(NSString *)filePath;
- (NSString *)getName;
- (NSString *)getExtensionPath;
- (float)getDuration;
- (NSString *)getFilePath;

@end
