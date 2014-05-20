//
//  TAPhotoCell.m
//  PhotoBombers
//
//  Created by Harish Upadhyayula on 5/20/14.
//  Copyright (c) 2014 tensor apps. All rights reserved.
//

#import "TAPhotoCell.h"
#import "TAPhotoController.h"

@implementation TAPhotoCell

-(void)setPhoto:(NSDictionary *)photo{
    
    _photo = photo;
    
    //NSURL *url = [[NSURL alloc] initWithString:_photo[@"images"][@"standard_resolution"][@"url"]];
    
    [TAPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        
        self.imageView.image = image;
        
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void)like{
    
    NSLog(@"url of the photo.. %@", self.photo[@"link"]);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    NSString *urlstring = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    
    NSURL *url = [[NSURL alloc] initWithString:urlstring];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showCompletion];
        });
    }];
    
    [task resume];
}

-(void)showCompletion{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked!" message:@"You liked this photo" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(void)layoutSubviews{
    
    self.imageView.frame = self.contentView.bounds;
    
}

@end
