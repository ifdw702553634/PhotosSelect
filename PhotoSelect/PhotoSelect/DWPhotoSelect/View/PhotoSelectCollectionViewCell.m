//
//  PhotoSelectCollectionViewCell.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "PhotoSelectCollectionViewCell.h"

@implementation PhotoSelectCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        __weak PhotoSelectCollectionViewCell *weakSelf = self;
        _photo = [[UIImageView alloc] init];
        [self addSubview:_photo];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = YES;
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        _selectBtn = [[UIButton alloc] init];
        [self addSubview:_selectBtn];
        [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.top.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

-(void)selectBtnClick{
    self.selectBlock();
}

@end
