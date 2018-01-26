//
//  DWPhotoDetailsViewController.h
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DetailBlock)(NSArray *photoArr);

typedef NS_ENUM(NSInteger, PhotoType) {
    AllPhotos = 1,
    SelectPhotos = 2,
};

@interface DWPhotoDetailsViewController : UIViewController

@property NSArray<PHAsset *> *photoArr;
@property NSInteger currentIndex;

@property NSMutableArray<PHAsset *> *selectArr;
@property PhotoType photoType;

@property NSInteger allowSelect;//用于记录可以选择的照片数量

@property (nonatomic, copy) DetailBlock detailBlock;

@end
