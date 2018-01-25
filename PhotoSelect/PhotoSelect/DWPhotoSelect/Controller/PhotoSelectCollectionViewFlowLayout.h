//
//  PhotoSelectCollectionViewFlowLayout.h
//  mHOA
//
//  Created by mude on 16/12/5.
//  Copyright © 2016年 DreamTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout cellCenteredAtIndexPath:(NSIndexPath *)indexPath page:(int)page;
@end
@interface PhotoSelectCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<CustomViewFlowLayoutDelegate> delegate;
@end
