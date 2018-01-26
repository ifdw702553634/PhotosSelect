//
//  DWPhotoSelectView.h
//  PhotoSelect
//
//  Created by mude on 2018/1/26.
//  Copyright © 2018年 mude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWPhotoSelectView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame withItemSize:(CGSize)itemSize withMinimumLineSpacing:(CGFloat)minimumLineSpacing withMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing withAllowSelect:(NSInteger)allowSelect;

@property NSMutableArray<PHAsset *> *photoArr;

@end
