//
//  TAPhotoController.h
//  PhotoBombers
//
//  Created by Harish Upadhyayula on 5/20/14.
//  Copyright (c) 2014 tensor apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPhotoController : NSObject

+(void)imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^)(UIImage *image))completion;

@end
