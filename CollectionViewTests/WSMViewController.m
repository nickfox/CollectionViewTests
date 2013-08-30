//
//  WSMViewController.m
//  CollectionViewTests
//
//  Created by Nick Fox on 8/29/13.
//  Copyright (c) 2013 Nick Fox. All rights reserved.
//

#import "WSMViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation WSMViewController
{
    NSMutableArray *thumbnails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getThumbnailsFromDevice];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [thumbnails count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    cellImageView.image = [thumbnails objectAtIndex:indexPath.row];

    return cell;
}

-(void)getThumbnailsFromDevice
{
    if (!thumbnails) {
        thumbnails = [[NSMutableArray alloc] init];
    }
    
    ALAssetsLibrary *assetLibrary = [WSMViewController defaultAssetsLibrary];
    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                if (asset) {
                    [thumbnails addObject:[UIImage imageWithCGImage:[asset thumbnail]]];
                    [self.collectionView reloadData];
                }
            }];
        }
    }
                    failureBlock:^(NSError *error) {
                        NSLog(@"User did not allow access to library");
                    }];
    
}

// i know this is very "singleton-like" behavior which many devs disagree with but it was best to do it this way
// to deal with having one and only one assets library. apple states this strongly in the documentation.
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^ {
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
