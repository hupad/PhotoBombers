//
//  TADetailViewController.m
//  PhotoBombers
//
//  Created by Harish Upadhyayula on 5/20/14.
//  Copyright (c) 2014 tensor apps. All rights reserved.
//

#import "TADetailViewController.h"
#import "TAPhotoController.h"

@interface TADetailViewController ()

@property (nonatomic)UIImageView *imageView;

@end

@implementation TADetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    [TAPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    [self tapGesture];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    CGSize imageSize = CGSizeMake(size.width, size.height);
    
    self.imageView.frame = CGRectMake(0, (size.height - imageSize.height)/2, imageSize.width, imageSize.height);
    
}

-(void)tapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
}

-(void)close{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
