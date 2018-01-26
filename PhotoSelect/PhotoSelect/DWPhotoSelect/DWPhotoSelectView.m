//
//  DWPhotoSelectView.m
//  PhotoSelect
//
//  Created by mude on 2018/1/26.
//  Copyright © 2018年 mude. All rights reserved.
//

#import "DWPhotoSelectView.h"
#import "DWAlbumViewController.h"
#import "PhotoCollectionViewCell.h"

@interface DWPhotoSelectView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _allowSelect;//用于记录可以选择的照片数量
}
@end

@implementation DWPhotoSelectView

- (instancetype)initWithFrame:(CGRect)frame withItemSize:(CGSize)itemSize withMinimumLineSpacing:(CGFloat)minimumLineSpacing withMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing withAllowSelect:(NSInteger)allowSelect{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置单元格大小
    flowLayout.itemSize = itemSize;
    //最小行间距(默认为10)
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    //最小item间距（默认为10）
    flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (!self) {
        return nil;
    }
    _allowSelect = allowSelect;
    self.delegate=self;
    self.dataSource=self;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    
    return self;
}

- (void)enumerateAssetsWithCompletionBlock:(void (^)(UIImage *image))completionBlock withAsset:(PHAsset *)asset original:(BOOL)original
{
    __block UIImage *image;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
    CGSize size = CGSizeZero;
    if (original == YES) {
        size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    }else{
        size = CGSizeMake(180, 180);
    }
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        //设置BOOL判断，确认返回高清照片
        if (downloadFinined) {
            if (result != nil) {
                image = result;
                completionBlock(image);
            }else{
                image = [UIImage imageNamed:@"placeholder"];
                completionBlock(image);
            }
        }
    }];
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



#pragma mark - CollectionDeleDate
//有多少的分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分组里有多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArr.count < _allowSelect) {
        return _photoArr.count + 1;
    }
    return _photoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据identifier从缓冲池里去出cell
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.userInteractionEnabled=YES;
    if (indexPath.row == _photoArr.count) {
        cell.photo.image = [UIImage imageNamed:@"btn_picture_upload"];
        cell.deleteBtn.hidden = YES;
    }else{
        cell.deleteBtn.hidden = NO;
        [self enumerateAssetsWithCompletionBlock:^(UIImage *image) {
            cell.photo.image = image;
        } withAsset:_photoArr[indexPath.row] original:NO];
    }
    cell.deleteBlock = ^{
        [_photoArr removeObjectAtIndex:indexPath.row];
        [self reloadData];
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _photoArr.count) {
        __weak DWPhotoSelectView *weakSelf = self;
        DWAlbumViewController *vc = [[DWAlbumViewController alloc] init];
        vc.currentPhotoArr = self.photoArr;
        vc.allowSelect = _allowSelect;
        vc.albumBlock = ^(NSArray *arr){
            weakSelf.photoArr = [arr mutableCopy];
            [self reloadData];
        };
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
};

@end
