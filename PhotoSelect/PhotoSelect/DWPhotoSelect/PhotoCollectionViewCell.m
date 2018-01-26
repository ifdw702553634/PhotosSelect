//
//  PhotoCollectionViewCell.m
//  PhotoSelect
//
//  Created by mude on 2018/1/26.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        __weak PhotoCollectionViewCell *weakSelf = self;
        _photo = [[UIImageView alloc] init];
        [self addSubview:_photo];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf).with.insets(UIEdgeInsetsMake(8, 0, 0, 8));
        }];
        
        _deleteBtn = [[UIButton alloc] init];
        [self addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_picture_delete"] forState:UIControlStateNormal];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.top.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

-(void)deleteBtnClick{
    self.deleteBlock();
}

@end
