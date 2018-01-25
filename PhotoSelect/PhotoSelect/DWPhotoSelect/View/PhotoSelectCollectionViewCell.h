//
//  PhotoSelectCollectionViewCell.h
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoSelectCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIButton *selectBtn;
@property(nonatomic,copy) void(^selectBlock)(void);

@end
