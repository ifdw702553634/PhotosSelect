//
//  PhotoCollectionViewCell.h
//  PhotoSelect
//
//  Created by mude on 2018/1/26.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIButton *deleteBtn;

@property (nonatomic,copy) void (^deleteBlock)();

@end
