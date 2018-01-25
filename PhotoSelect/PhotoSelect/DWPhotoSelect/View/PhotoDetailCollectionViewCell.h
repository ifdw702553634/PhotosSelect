//
//  PhotoDetailCollectionViewCell.h
//  mHOA
//
//  Created by mude on 16/11/24.
//  Copyright © 2016年 DreamTouch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoDetailCollectionViewCell : UICollectionViewCell

@property(nonatomic,copy) void(^handleSingleBlock)(void);

-(void)loadPHAssetItemForPics:(PHAsset *)assetItem;

-(void)recoverSubview;

@end
