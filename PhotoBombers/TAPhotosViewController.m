//
//  TAPhotosViewController.m
//  PhotoBombers
//
//  Created by Harish Upadhyayula on 5/19/14.
//  Copyright (c) 2014 tensor apps. All rights reserved.
//

#import "TAPhotosViewController.h"
#import "TAPhotoCell.h"
#import "SimpleAuth.h"
#import "TADetailViewController.h"
#import "TAPresentDetailTransition.h"
#import "TADismissDetailTransition.h"

@interface TAPhotosViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic)NSArray *photos;
@property (nonatomic)NSString *accessToken;

@end

@implementation TAPhotosViewController

-(instancetype)init{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(106, 106);
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    self.title = @"Photo Bombers";
    return [super initWithCollectionViewLayout:flowLayout];
}

-(void)viewDidLoad{
    [self.collectionView registerClass:[TAPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self refresh];
}

-(void)refresh{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            NSLog(@"Response.. %@", responseObject);
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            
            [userDefaults synchronize];
            
            [self refresh];
        }];
    }else{
        NSLog(@"Signed in");
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/snow/media/recent?access_token=%@", self.accessToken];
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions
                                                                                 error:nil];
            
            self.photos = [responseDictionary valueForKey:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
        }];
        [task resume];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TAPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *photo = self.photos[indexPath.row];
    
    TADetailViewController *detailVC = [[TADetailViewController alloc] init];
    detailVC.modalPresentationStyle = UIModalPresentationCustom;
    detailVC.transitioningDelegate = self;
    
    detailVC.photo = photo;
    
    [self presentViewController:detailVC animated:YES
                     completion:nil];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [[TAPresentDetailTransition alloc] init];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [[TADismissDetailTransition alloc] init];
}

@end
