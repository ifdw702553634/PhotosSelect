//
//  AlbumTableViewCell.m
//  PhotoSelect
//
//  Created by mude on 2018/1/25.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        __weak AlbumTableViewCell *weakSelf = self;
        //创建imageView添加到cell中
        _firstPhoto = [[UIImageView alloc] init];
        [self addSubview:_firstPhoto];
        _firstPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _firstPhoto.clipsToBounds = YES;
        [_firstPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf).offset(10.f);
            make.bottom.mas_equalTo(weakSelf).offset(-10.f);
            make.leading.mas_equalTo(weakSelf).offset(10.f);
            make.width.mas_equalTo(weakSelf.firstPhoto.mas_height);
        }];
        
        _albumName = [[UILabel alloc] init];
        [self addSubview:_albumName];
        _albumName.font = [UIFont systemFontOfSize:16.f];
        [_albumName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf).offset(20.f);
            make.left.mas_equalTo(weakSelf.firstPhoto.mas_right).offset(15.f);
        }];
        
        _albumNum = [[UILabel alloc] init];
        [self addSubview:_albumNum];
        _albumNum.font = [UIFont systemFontOfSize:12.f];
        [_albumNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.albumName.mas_bottom).offset(5.5f);
            make.left.mas_equalTo(weakSelf.firstPhoto.mas_right).offset(15.f);
        }];
        
        UIImage *image = [UIImage imageNamed:@"icon_arrow"];
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.image = image;
        [self addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(image.size.width, image.size.height));
            make.right.mas_equalTo(weakSelf).offset(-20.f);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
